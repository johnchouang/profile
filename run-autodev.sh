#!/usr/bin/env bash

# Configuration
MAX_WALL_TIME=21600        # 6 hours total hard cap
HANG_TIMEOUT=600           # 10 min with no file or LLM activity = hung
POLL_INTERVAL=30           # check every 30 seconds
LOG_FILE=".ralph/watchdog.log"
RALPH_PID_FILE=".ralph/ralph.pid"

mkdir -p .ralph

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

has_project_activity() {
  # Returns the count of any project files created or modified since the
  # last poll cycle. The watchdog.log itself is the time reference — it is
  # touched at the top of every poll loop, so -newer means "changed in the
  # last POLL_INTERVAL seconds".
  #
  # Excluded:
  #   .git/objects  — git object store, changes on every commit but not useful signal
  #   .git/logs     — git reflogs
  #   .ralph/watchdog.log — the reference file itself
  find . \
    -not -path './.git/objects/*' \
    -not -path './.git/logs/*' \
    -not -path './.ralph/watchdog.log' \
    -newer ".ralph/watchdog.log" \
    -type f \
    2>/dev/null | wc -l
}

start_ralph() {
  ralph --prompt-file autodev-prompt.md \
    --agent opencode \
    --tasks \
    --task-promise "READY_FOR_NEXT_TASK" \
    --completion-promise "COMPLETE" \
    --min-iterations 6 \
    --max-iterations 40 \
    --allow-all &

  RALPH_PID=$!
  echo $RALPH_PID > "$RALPH_PID_FILE"
  log "Started ralph (PID: $RALPH_PID)"
}

kill_ralph() {
  if [ -f "$RALPH_PID_FILE" ]; then
    local pid
    pid=$(cat "$RALPH_PID_FILE")
    log "Killing ralph (PID: $pid) and its children"
    pkill -P "$pid" 2>/dev/null
    kill "$pid" 2>/dev/null
    rm -f "$RALPH_PID_FILE"
    sleep 3
  fi
}

# Trap ctrl+c for clean exit
trap 'log "Interrupted by user"; kill_ralph; exit 0' INT TERM

log "=== Watchdog starting ==="
log "Wall time cap: ${MAX_WALL_TIME}s | Hang timeout: ${HANG_TIMEOUT}s | Poll: ${POLL_INTERVAL}s"

# Touch the log file now so find -newer uses it as the reference point
touch ".ralph/watchdog.log"

START_TIME=$SECONDS
LAST_CHANGE_TIME=$SECONDS

start_ralph

while true; do
  sleep $POLL_INTERVAL

  # Hard wall time check
  ELAPSED=$((SECONDS - START_TIME))
  if [ $ELAPSED -ge $MAX_WALL_TIME ]; then
    log "ERROR: Hard wall time of ${MAX_WALL_TIME}s (6h) reached. Stopping."
    kill_ralph
    exit 1
  fi

  # Check if ralph process is still alive
  if [ -f "$RALPH_PID_FILE" ]; then
    RALPH_PID=$(cat "$RALPH_PID_FILE")
    if ! kill -0 "$RALPH_PID" 2>/dev/null; then
      log "Ralph exited cleanly. Done."
      exit 0
    fi
  fi

  # Check for project file activity — any file created or modified counts.
  # IMPORTANT: find runs BEFORE touching watchdog.log so that -newer correctly
  # captures everything written during the sleep window. Touch happens after.
  ACTIVE_FILES=$(has_project_activity)
  touch ".ralph/watchdog.log"

  if [ "$ACTIVE_FILES" -gt 0 ]; then
    LAST_CHANGE_TIME=$SECONDS
    log "Activity detected ($ACTIVE_FILES file(s) changed)"
  else
    HUNG_FOR=$((SECONDS - LAST_CHANGE_TIME))
    log "No activity for ${HUNG_FOR}s / ${HANG_TIMEOUT}s"

    if [ $HUNG_FOR -ge $HANG_TIMEOUT ]; then
      log "HANG DETECTED after ${HUNG_FOR}s — restarting ralph"
      kill_ralph
      sleep 5

      ralph --add-context "The previous iteration hung and was restarted by the watchdog. Read .specify/memory/ for last known state and resume from the last incomplete phase. Do not restart completed phases." 2>/dev/null || true

      start_ralph
      LAST_CHANGE_TIME=$SECONDS
      touch ".ralph/watchdog.log"
    fi
  fi
done
