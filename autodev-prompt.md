# Autonomous Spec-Driven Development

You are running fully autonomously inside a ralph loop. You have no human to
ask for input. Every decision must be made on your own using best judgement,
the contents of `input-spec.md`, and web research if needed.

---

## CRITICAL: How this loop works

Ralph drives you through exactly 6 phases using `READY_FOR_NEXT_TASK` signals.
Each time you output that signal, ralph restarts you fresh on the next phase.
**You have no memory of previous loops. Your only memory is what was written
to `.specify/memory/` by prior phases.**

**Ralph's task list exists only to track which of the 6 phases is current.**
Ralph does NOT define implementation work. Implementation work is defined
exclusively by spec-kit's `tasks.md` file generated in Phase 4.

Do not derive your own implementation tasks. Do not follow any task list
other than the spec-kit `tasks.md` for implementation. If you find yourself
creating granular implementation tasks (file names, component names, test
paths) in `.ralph/ralph-tasks.md`, stop — those belong in spec-kit's
`tasks.md`, not in the ralph task list.

The ralph task list must contain exactly these 6 entries and nothing else:

```
- [ ] Phase 1: Constitution
- [ ] Phase 2: Specification
- [ ] Phase 3: Technical Plan
- [ ] Phase 4: Task Breakdown
- [ ] Phase 5: Implementation
- [ ] Phase 6: Validation
```

Ralph's loop checks `.ralph/ralph-tasks.md` for incomplete items before
accepting any `READY_FOR_NEXT_TASK` or `COMPLETE` signal. **The current
phase's entry must be marked `[x]` before you output any signal or Ralph
will reject it.** This is separate from `tasks.md` — they are two different
files with different purposes.

All slash commands are defined as markdown files under `.opencode/command/`.
**Always read the command file before executing the command.** The command
file is the authoritative source for what the command does — do not rely on
memory of previous runs or assumptions about what it might do.

---

## ORIENTATION — Do this first, every single loop

**Before reading anything else, before taking any action, run:**

```bash
cat .specify/memory/current-phase.md 2>/dev/null || echo "FILE NOT FOUND — this is Phase 1"
```

This file tells you exactly which phase was just completed and what your
single next action is. If the file does not exist, you are starting Phase 1.

**Do not proceed until you have read `current-phase.md` and confirmed which
phase you are executing.** Never assume based on the ralph task list alone —
always confirm against `current-phase.md`.

**After reading `current-phase.md`, output exactly one line to confirm
orientation before proceeding with any other action:**

```
ORIENTATION: Executing Phase <N> — <phase name> | Feature: <slug or "not yet assigned">
```

If you cannot output this line with correct values populated from
`current-phase.md`, stop — do not proceed until you can.

**Ralph task file guard — run this immediately after orientation:**

```bash
RALPH_TASKS=$(grep -c '^\- \[' .ralph/ralph-tasks.md 2>/dev/null || echo "0")
echo "Ralph task entries found: $RALPH_TASKS"
cat .ralph/ralph-tasks.md 2>/dev/null || echo "FILE MISSING"
```

If the file is missing, empty (0 entries), or does not contain all 6 phase
entries, you must reinitialize it before proceeding:

```bash
mkdir -p .ralph
cat > .ralph/ralph-tasks.md << 'EOF'
- [ ] Phase 1: Constitution
- [ ] Phase 2: Specification
- [ ] Phase 3: Technical Plan
- [ ] Phase 4: Task Breakdown
- [ ] Phase 5: Implementation
- [ ] Phase 6: Validation
EOF
```

Then immediately mark all phases up to and including the **previously
completed** phase as `[x]`. For example, if `current-phase.md` shows
`COMPLETED_PHASE: Phase 4`, mark phases 1 through 4 as `[x]` and leave
phases 5 and 6 as `[ ]`. Use sed for each completed phase:

```bash
sed -i 's/- \[ \] Phase 1: Constitution/- [x] Phase 1: Constitution/' .ralph/ralph-tasks.md
# repeat for each completed phase number up to the previously completed phase
```

Verify the file looks correct before continuing:
```bash
cat .ralph/ralph-tasks.md
```

**Never treat an empty or missing `.ralph/ralph-tasks.md` as "nothing
blocking me." It is always an error state that must be corrected first.**

**If `current-phase.md` shows `COMPLETED_PHASE: Phase 5 — Implementation` but
`impl-progress.md` shows incomplete tasks, you are in a context-reset resume
scenario for Phase 5. Go directly to the Phase 5 Context-Reset Resume section.**

---

## CANONICAL PATHS — always use these, no exceptions

| Artifact | Path |
|---|---|
| **Phase handoff (read first every loop)** | `.specify/memory/current-phase.md` |
| **Ralph phase tracker** | `.ralph/ralph-tasks.md` |
| **Implementation progress (Phase 5 live tracker)** | `.specify/memory/impl-progress.md` |
| Command definitions | `.opencode/command/` |
| Memory / phase summaries | `.specify/memory/` |
| Feature spec folder | `specs/###-feature-slug/` (project root) |
| spec.md | `specs/###-feature-slug/spec.md` |
| plan.md | `specs/###-feature-slug/plan.md` |
| research.md | `specs/###-feature-slug/research.md` |
| data-model.md | `specs/###-feature-slug/data-model.md` |
| contracts/ | `specs/###-feature-slug/contracts/` |
| quickstart.md | `specs/###-feature-slug/quickstart.md` |
| tasks.md | `specs/###-feature-slug/tasks.md` |
| Agent context | `AGENTS.md` (project root) |
| Workflow scripts | `.specify/scripts/bash/` |

The feature folder name (`###-feature-slug`) is assigned during Phase 2 and
recorded in `current-phase.md`. Never invent this name. Always read it from
`current-phase.md`.

Extract the slug with:
```bash
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md | cut -d' ' -f2
```
Do not proceed if this returns empty or "not yet assigned" in any phase after Phase 1.

The `specs/` folder always lives at the project root, never inside `.specify/`.
If any command creates it elsewhere, move it immediately and update references.

---

## THE PHASE HANDOFF FORMAT

At the end of every phase you must overwrite `.specify/memory/current-phase.md`
with the following structure, filled in precisely:

```
COMPLETED_PHASE: <number and name, e.g. "Phase 1 — Constitution">
FEATURE_SLUG: <###-feature-slug, or "not yet assigned" if Phase 1>
NEXT_PHASE: <number and name, e.g. "Phase 2 — Specification">
NEXT_ACTION: <one sentence: the exact first thing the next loop must do>

COMPLETED_ARTIFACTS:
- <path to every file/folder created or modified this phase>
- ...

PHASE_NOTES:
<Any decisions, assumptions, or warnings the next phase needs to know.
Be specific. The next loop has no other memory of what happened here.>
```

This file is overwritten (not appended) at the end of each phase. It always
describes the phase that just finished and points forward to what comes next.

**After writing `current-phase.md`, always verify it with:**
```bash
cat .specify/memory/current-phase.md
```
Confirm the output contains the correct `COMPLETED_PHASE`, `NEXT_PHASE`,
`NEXT_ACTION`, and `FEATURE_SLUG` values. If any field is wrong or missing,
rewrite the file before proceeding.

---

## PRE-SIGNAL CHECKLIST — run before every `READY_FOR_NEXT_TASK` or `COMPLETE`

**This checklist is mandatory before outputting any terminal signal. There
are no exceptions. Run each command and observe its output before ticking
it off.**

```bash
echo "=== Pre-signal exit check ==="
ls -la .specify/memory/phaseN-summary.md && echo "[OK] summary exists" || echo "[MISSING] summary — do not proceed"
grep "^COMPLETED_PHASE:" .specify/memory/current-phase.md && echo "[OK] handoff written" || echo "[MISSING] handoff — do not proceed"
grep "^NEXT_PHASE:" .specify/memory/current-phase.md
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md
grep "Phase N: <name>" .ralph/ralph-tasks.md | grep "\[x\]" && echo "[OK] ralph task marked [x]" || echo "[FAIL] ralph task not marked [x] — do not proceed"
git log --oneline -1
```

Replace `phaseN` with the actual phase number (e.g. `phase3`) and
`Phase N: <name>` with the current phase entry (e.g. `Phase 3: Technical Plan`).
The ralph task grep must return a line containing `[x]`, not `[ ]`.

- [ ] `phaseN-summary.md` exists and is non-empty
- [ ] `current-phase.md` contains correct `COMPLETED_PHASE`, `NEXT_PHASE`, `NEXT_ACTION`, and `FEATURE_SLUG`
- [ ] All paths listed in `COMPLETED_ARTIFACTS` actually exist on disk
- [ ] `.ralph/ralph-tasks.md` shows `[x]` for the current phase (not `[ ]`)
- [ ] `git commit` for this phase appears in `git log --oneline -1`

**Only if ALL five items above are confirmed: output the signal.**

If any item is missing or shows `[FAIL]`, fix it now. Do not output the
signal until every item resolves to `[OK]`.

---

## PHASE 1 — Constitution

### 1-A: Orientation

**Orientation check:** `current-phase.md` does not exist or shows no completed
phase. Confirm this is correct before proceeding.

Output orientation line:
```
ORIENTATION: Executing Phase 1 — Constitution | Feature: not yet assigned
```

Run the ralph task file guard from the ORIENTATION section. Since this is
Phase 1, the file should either not exist or contain all 6 entries as `[ ]`.
If the file is missing or empty, initialize it now. Do not back-fill any
`[x]` entries — all phases start unchecked at Phase 1.

### 1-B: Execute

Read `.opencode/command/speckit.constitution.md` and follow its instructions
to invoke `/speckit.constitution` with the following principle instruction:

> Create principles for code quality, thorough test coverage, clear error
> handling, and performance. All features must have automated tests before
> they are considered complete. Prefer simplicity over over-engineering.

After the command completes, verify `.specify/memory/constitution.md` exists
and is populated:
```bash
ls -la .specify/memory/constitution.md && wc -l .specify/memory/constitution.md
```
If the file is missing or empty, re-run the command before continuing.

### 1-C: Wrap-Up (execute in order, do not skip any step)

**Step 1 — Write the phase summary.**
Write `.specify/memory/phase1-summary.md` containing a one-paragraph summary
of the principles established by the constitution command.
Verify:
```bash
ls -la .specify/memory/phase1-summary.md && cat .specify/memory/phase1-summary.md
```

**Step 2 — Write the phase handoff.**
Overwrite `.specify/memory/current-phase.md` with exactly:

```
COMPLETED_PHASE: Phase 1 — Constitution
FEATURE_SLUG: not yet assigned
NEXT_PHASE: Phase 2 — Specification
NEXT_ACTION: Read input-spec.md in full, then read
  .opencode/command/speckit.specify.md and invoke /speckit.specify.

COMPLETED_ARTIFACTS:
- .specify/memory/constitution.md
- .specify/memory/phase1-summary.md

PHASE_NOTES:
Constitution established. No feature branch exists yet.
```

Verify the write:
```bash
cat .specify/memory/current-phase.md
```
Confirm all fields are present and correct before continuing.

**Step 3 — Mark the Phase 1 ralph task complete.**
```bash
sed -i 's/- \[ \] Phase 1: Constitution/- [x] Phase 1: Constitution/' .ralph/ralph-tasks.md
grep "Phase 1: Constitution" .ralph/ralph-tasks.md
```
The grep output must show `[x]`. If it still shows `[ ]`, edit the file
manually before continuing.

**Step 4 — Commit.**
```bash
git add -A && git commit -m "phase1: constitution"
git log --oneline -1
```

**Step 5 — Run the Pre-Signal Checklist** (replacing `phaseN` with `phase1`,
`Phase N: <name>` with `Phase 1: Constitution`).
All five items must be `[OK]`.

**Step 6 — Output the signal.**
`<promise>READY_FOR_NEXT_TASK</promise>`

---

## PHASE 2 — Specification

### 2-A: Orientation

Read `.specify/memory/current-phase.md`. Confirm it shows
`COMPLETED_PHASE: Phase 1` and `NEXT_PHASE: Phase 2`. If it does not, stop
and re-read the file — do not proceed until orientation is confirmed.

Extract the feature slug (will be assigned this phase):
```bash
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md
```

Output orientation line:
```
ORIENTATION: Executing Phase 2 — Specification | Feature: not yet assigned
```

Run the ralph task file guard from the ORIENTATION section. Verify
`Phase 1: Constitution` shows `[x]` and `Phase 2: Specification` shows `[ ]`.

Read `.specify/memory/phase1-summary.md` to load constitution context.

### 2-B: Execute

Read `input-spec.md` in full. This is the **only phase** that reads
`input-spec.md` — everything it defines must be fully captured in `spec.md`
before this phase ends. No later phase will consult `input-spec.md`.

Read `.opencode/command/speckit.specify.md` and follow its instructions to
invoke `/speckit.specify`, passing the complete product description from
`input-spec.md`.

After the command completes:
- Confirm you are on a feature branch named `###-feature-slug`.
- Confirm `specs/###-feature-slug/spec.md` exists at the project root.
- If `spec.md` was created anywhere else, move it to the correct path and
  commit the move before continuing.
- Record the exact feature slug — you will need it in every subsequent phase.
- Read `spec.md` in full and resolve every gap or ambiguity: first from
  `input-spec.md`, then via web research. Write resolutions directly into
  `spec.md`. Do not leave any section marked unclear or TBD.
- Verify `spec.md` captures **everything** from `input-spec.md`: all
  features, constraints, tech stack preferences, startup scripts, server
  ports, and any other requirements. `spec.md` must be a complete and
  self-sufficient specification — no detail should remain only in
  `input-spec.md` after this phase.

### 2-C: Wrap-Up (execute in order, do not skip any step)

**Step 1 — Write the phase summary.**
Write `.specify/memory/phase2-summary.md` containing: the feature slug, a
summary of every user story and acceptance criterion, every assumption
resolved, the tech stack preferences found in `input-spec.md` (if any), and
whether `input-spec.md` defined a startup script or server ports (record the
exact details if so — this informs Phase 4 and Phase 6).
Verify:
```bash
ls -la .specify/memory/phase2-summary.md && cat .specify/memory/phase2-summary.md
```

**Step 2 — Write the phase handoff.**
Overwrite `.specify/memory/current-phase.md` with exactly:

```
COMPLETED_PHASE: Phase 2 — Specification
FEATURE_SLUG: ###-feature-slug
NEXT_PHASE: Phase 3 — Technical Plan
NEXT_ACTION: Read .opencode/command/speckit.plan.md, then read
  phase2-summary.md for stack preferences and invoke /speckit.plan with the chosen stack.

COMPLETED_ARTIFACTS:
- specs/###-feature-slug/spec.md
- .specify/memory/phase2-summary.md

PHASE_NOTES:
Feature branch: ###-feature-slug
User stories: <count> stories defined in spec.md.
Assumptions resolved: <brief list>
Tech stack preference: <stack from input-spec.md, or "none stated">
Runnable application: <yes/no — if yes, list startup script name and all server ports>
```

Verify the write:
```bash
cat .specify/memory/current-phase.md
```
Confirm `FEATURE_SLUG` contains the actual slug (not the placeholder `###-feature-slug`).

**Step 3 — Mark the Phase 2 ralph task complete.**
```bash
sed -i 's/- \[ \] Phase 2: Specification/- [x] Phase 2: Specification/' .ralph/ralph-tasks.md
grep "Phase 2: Specification" .ralph/ralph-tasks.md
```
The grep output must show `[x]`. If it still shows `[ ]`, edit the file
manually before continuing.

**Step 4 — Commit.**
```bash
git add -A && git commit -m "phase2: specification complete"
git log --oneline -1
```

**Step 5 — Run the Pre-Signal Checklist** (replacing `phaseN` with `phase2`,
`Phase N: <name>` with `Phase 2: Specification`).
All five items must be `[OK]`.

**Step 6 — Output the signal.**
`<promise>READY_FOR_NEXT_TASK</promise>`

---

## PHASE 3 — Technical Plan

### 3-A: Orientation

Read `.specify/memory/current-phase.md`. Confirm it shows
`COMPLETED_PHASE: Phase 2` and `NEXT_PHASE: Phase 3`. If it does not, stop
and re-read the file — do not proceed until orientation is confirmed.

Extract the feature slug:
```bash
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md | cut -d' ' -f2
```
Use this exact value for all paths this phase. Do not proceed if it returns
empty.

Output orientation line:
```
ORIENTATION: Executing Phase 3 — Technical Plan | Feature: <slug>
```

Run the ralph task file guard from the ORIENTATION section. Verify
`Phase 2: Specification` shows `[x]` and `Phase 3: Technical Plan` shows `[ ]`.

Read `.specify/memory/phase2-summary.md` to load spec context.

### 3-B: Execute

Read `.opencode/command/speckit.plan.md` and follow its instructions to
invoke `/speckit.plan`, passing your chosen stack and architecture. Read
`phase2-summary.md` for any stated tech stack preferences. If none are
stated, choose a minimal, standard stack — favour fewer dependencies and
well-established libraries.

After the command completes, verify all expected artifacts exist under
`specs/###-feature-slug/` at the project root. If any were created
elsewhere, move them and commit before continuing. Review `plan.md` for
over-engineering — remove any components not required by `spec.md`.

### 3-C: Wrap-Up (execute in order, do not skip any step)

**Step 1 — Write the phase summary.**
Write `.specify/memory/phase3-summary.md` containing: the tech stack chosen,
key architecture decisions, any over-engineering removed, and the list of
contract files generated.
Verify:
```bash
ls -la .specify/memory/phase3-summary.md && cat .specify/memory/phase3-summary.md
```

**Step 2 — Write the phase handoff.**
Overwrite `.specify/memory/current-phase.md` with exactly:

```
COMPLETED_PHASE: Phase 3 — Technical Plan
FEATURE_SLUG: ###-feature-slug
NEXT_PHASE: Phase 4 — Task Breakdown
NEXT_ACTION: Read .opencode/command/speckit.tasks.md and invoke /speckit.tasks.

COMPLETED_ARTIFACTS:
- specs/###-feature-slug/plan.md
- specs/###-feature-slug/research.md
- specs/###-feature-slug/data-model.md
- specs/###-feature-slug/contracts/<list each file>
- specs/###-feature-slug/quickstart.md
- AGENTS.md (updated)
- .specify/memory/phase3-summary.md

PHASE_NOTES:
Stack: <language, framework, db, test framework — one line>
Architecture: <one sentence summary>
Over-engineering removed: <list or "none">
```

Verify the write:
```bash
cat .specify/memory/current-phase.md
```
Confirm all fields are present and the `FEATURE_SLUG` matches the actual slug.

**Step 3 — Mark the Phase 3 ralph task complete.**
```bash
sed -i 's/- \[ \] Phase 3: Technical Plan/- [x] Phase 3: Technical Plan/' .ralph/ralph-tasks.md
grep "Phase 3: Technical Plan" .ralph/ralph-tasks.md
```
The grep output must show `[x]`. If it still shows `[ ]`, edit the file
manually before continuing.

**Step 4 — Commit.**
```bash
git add -A && git commit -m "phase3: technical plan complete"
git log --oneline -1
```

**Step 5 — Run the Pre-Signal Checklist** (replacing `phaseN` with `phase3`,
`Phase N: <name>` with `Phase 3: Technical Plan`).
All five items must be `[OK]`.

**Step 6 — Output the signal.**
`<promise>READY_FOR_NEXT_TASK</promise>`

---

## PHASE 4 — Task Breakdown

### 4-A: Orientation

Read `.specify/memory/current-phase.md`. Confirm it shows
`COMPLETED_PHASE: Phase 3` and `NEXT_PHASE: Phase 4`. If it does not, stop
and re-read the file — do not proceed until orientation is confirmed.

Extract the feature slug:
```bash
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md | cut -d' ' -f2
```
Use this exact value for all paths this phase. Do not proceed if it returns
empty.

Output orientation line:
```
ORIENTATION: Executing Phase 4 — Task Breakdown | Feature: <slug>
```

Run the ralph task file guard from the ORIENTATION section. Verify
`Phase 3: Technical Plan` shows `[x]` and `Phase 4: Task Breakdown` shows `[ ]`.

Read `.specify/memory/phase2-summary.md` and `.specify/memory/phase3-summary.md`
to load full spec and plan context.

### 4-B: Execute

Read `.opencode/command/speckit.tasks.md` and follow its instructions to
invoke `/speckit.tasks`.

After the command completes, verify `specs/###-feature-slug/tasks.md` exists
at the project root. If it was created elsewhere, move it before proceeding.

Cross-check `tasks.md` against `spec.md` and `plan.md`:
- Every user story in `spec.md` must be covered by at least one task.
- Tasks must be in valid dependency order.
- If gaps exist, add the missing tasks using the same `[TaskID]` format,
  continuing sequential numbering.

**Startup and smoke task check:** If `spec.md` (or `phase2-summary.md`) defines a startup
script (e.g. `start.sh`), server ports, or a runnable application, `tasks.md`
must include the following tasks in its final Polish phase. If they are
absent, add them before proceeding:
- A task to create and end-to-end test the startup script (install deps,
  run migrations, start all servers without error).
- A task to perform a smoke test of every running service: use `curl` or
  equivalent to confirm each expected URL returns a non-error HTTP status
  and record the results. A clean build that cannot be reached over HTTP
  is not a passing smoke test.

### 4-C: Wrap-Up (execute in order, do not skip any step)

**Step 1 — Write the phase summary.**
Write `.specify/memory/phase4-summary.md` containing: the total task count
and breakdown per user story phase, the ID of the first incomplete task, and
any dependency constraints the implementation phase must respect.
Verify:
```bash
ls -la .specify/memory/phase4-summary.md && cat .specify/memory/phase4-summary.md
```

**Step 2 — Write the phase handoff.**
Overwrite `.specify/memory/current-phase.md` with exactly:

```
COMPLETED_PHASE: Phase 4 — Task Breakdown
FEATURE_SLUG: ###-feature-slug
NEXT_PHASE: Phase 5 — Implementation
NEXT_ACTION: Read phase1 through phase4 summaries to restore context, then
  read .opencode/command/speckit.implement.md and invoke /speckit.implement.

COMPLETED_ARTIFACTS:
- specs/###-feature-slug/tasks.md
- .specify/memory/phase4-summary.md

PHASE_NOTES:
Total tasks: <count> across <count> phases in tasks.md
First task to execute: T001 (all tasks are unchecked [ ])
User stories covered: <list each US label and its task ID range>
Stack reminder: <repeat the one-line stack from phase3-summary>
Next phase must NOT add tasks to ralph-tasks.md. All work is driven by tasks.md only.
```

Verify the write:
```bash
cat .specify/memory/current-phase.md
```
Confirm all fields are present and the `FEATURE_SLUG` matches the actual slug.

**Step 3 — Mark the Phase 4 ralph task complete.**
```bash
sed -i 's/- \[ \] Phase 4: Task Breakdown/- [x] Phase 4: Task Breakdown/' .ralph/ralph-tasks.md
grep "Phase 4: Task Breakdown" .ralph/ralph-tasks.md
```
The grep output must show `[x]`. If it still shows `[ ]`, edit the file
manually before continuing.

**Step 4 — Commit.**
```bash
git add -A && git commit -m "phase4: task breakdown complete"
git log --oneline -1
```

**Step 5 — Run the Pre-Signal Checklist** (replacing `phaseN` with `phase4`,
`Phase N: <name>` with `Phase 4: Task Breakdown`).
All five items must be `[OK]`.

**Step 6 — Output the signal.**
`<promise>READY_FOR_NEXT_TASK</promise>`

---

## PHASE 5 — Implementation

### 5-A: Orientation and Resume Check

Read `.specify/memory/current-phase.md`. Confirm it shows
`COMPLETED_PHASE: Phase 4` and `NEXT_PHASE: Phase 5`. If it does not, stop
and re-read the file — do not proceed until orientation is confirmed.

Extract the feature slug:
```bash
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md | cut -d' ' -f2
```
Use this exact value for all paths this phase. Do not proceed if it returns
empty.

Output orientation line:
```
ORIENTATION: Executing Phase 5 — Implementation | Feature: <slug>
```

Run the ralph task file guard from the ORIENTATION section. Verify
`Phase 4: Task Breakdown` shows `[x]` and `Phase 5: Implementation` shows `[ ]`.

**Before doing anything else, check for an in-progress resume state:**

```bash
cat .specify/memory/impl-progress.md 2>/dev/null || echo "NO_PROGRESS_FILE"
```

- **NO_PROGRESS_FILE → fresh start:** Proceed to section 5-B.
- **File exists → context-reset resume:** Proceed to section 5-C.

---

### 5-B: Full Start (first entry into Phase 5)

Read ALL phase summaries to restore full context before touching any code:
- `.specify/memory/phase1-summary.md` — constitution principles
- `.specify/memory/phase2-summary.md` — user stories and assumptions
- `.specify/memory/phase3-summary.md` — stack and architecture
- `.specify/memory/phase4-summary.md` — task count and starting task ID

**Initialise the progress tracker.** Create `.specify/memory/impl-progress.md`:

```
STATUS: IN_PROGRESS
FEATURE_SLUG: ###-feature-slug
TASKS_FILE: specs/###-feature-slug/tasks.md
LAST_COMPLETED_TASK: none
LAST_COMPLETED_TASK_ID: T000
REMAINING_UNCHECKED: <total task count from tasks.md>
TEST_COMMAND: <to be filled in when discovered>
BUILD_COMMAND: <to be filled in when discovered>
CONTEXT_RESETS: 0

NOTES:
Phase 5 started fresh. Executing tasks sequentially from T001.
```

Read `.opencode/command/speckit.implement.md` and follow its instructions to
invoke `/speckit.implement`. Apply the task execution rules in section 5-D.

---

### 5-C: Context-Reset Resume

Read `.specify/memory/impl-progress.md` in full to determine:
- `LAST_COMPLETED_TASK_ID` — the last task successfully marked `[x]`
- `REMAINING_UNCHECKED` — how many tasks still need completing
- `TEST_COMMAND` and `BUILD_COMMAND` — the exact commands to use

Read all phase summaries (phase1 through phase4) to restore context.

Open `specs/###-feature-slug/tasks.md` and find the first task still marked
`[ ]` — this is your resume point. Do not re-execute any task already marked
`[x]`. Increment `CONTEXT_RESETS` in `impl-progress.md` by 1.

Read `.opencode/command/speckit.implement.md` and continue executing
remaining tasks, applying the task execution rules in section 5-D.

---

### 5-D: Task Execution Rules (applies to both 5-B and 5-C)

**Do not create your own task list. Do not add tasks to `.ralph/ralph-tasks.md`.
The only task list that drives implementation is `tasks.md`.**

For every task executed:

1. Implement the task as described.
2. Immediately update its checkbox in `tasks.md` from `[ ]` to `[x]`.
   **Never batch-update. One task done → one checkbox marked → next task.**
3. Immediately update `.specify/memory/impl-progress.md`:
   - Set `LAST_COMPLETED_TASK` to the task description
   - Set `LAST_COMPLETED_TASK_ID` to the task ID (e.g. T007)
   - Decrement `REMAINING_UNCHECKED` by 1
   - Update `TEST_COMMAND` and `BUILD_COMMAND` as soon as they are known
4. Commit: `git add -A && git commit -m "impl: T00N description"`

After each full user story phase within `tasks.md` completes:
- Run the build command and the test command.
- Fix any failures immediately. Do not accumulate known failures.
- If a task fails after 3 attempts with the same approach, switch strategies.

If a task fails after 3 attempts with a completely different strategy,
document it in `impl-progress.md` under a `BLOCKED:` entry and move to the
next task. Return to blocked tasks after all others are complete.

---

### 5-E: Completion Gate

**This gate must be passed before writing the Phase 5 handoff or outputting
`READY_FOR_NEXT_TASK`. There are no exceptions.**

```bash
grep -c '^\- \[ \]' specs/###-feature-slug/tasks.md
```

**Count > 0:** Uncompleted tasks remain. Return to section 5-D.

**Count = 0:** All tasks complete. Run the full test suite one final time.
If tests fail, fix them now. Then run the runtime gate below.

**Runtime gate (if `spec.md` defines a runnable application):** Execute
the startup script and confirm every expected process starts and responds to
HTTP requests. A passing test suite against a non-starting application does
not satisfy this gate. If no runnable application is defined, skip this step.

Only once count = 0 AND tests pass AND runtime gate passed (or not
applicable), proceed to section 5-F.

---

### 5-F: Phase 5 Wrap-Up (only reached after Completion Gate passes)

**Step 1 — Write the phase summary.**
Write `.specify/memory/phase5-summary.md` containing: total tasks completed,
every source file created or modified, the exact test and build commands, and
any known issues or blocked tasks deferred.
Verify:
```bash
ls -la .specify/memory/phase5-summary.md && cat .specify/memory/phase5-summary.md
```

**Step 2 — Update the progress tracker.**
Update `.specify/memory/impl-progress.md`:

```
STATUS: COMPLETE
LAST_COMPLETED_TASK: <final task description>
LAST_COMPLETED_TASK_ID: <final task ID>
REMAINING_UNCHECKED: 0
```

Verify:
```bash
grep "^STATUS:" .specify/memory/impl-progress.md
grep "^REMAINING_UNCHECKED:" .specify/memory/impl-progress.md
```
Both must show `COMPLETE` and `0` respectively before continuing.

**Step 3 — Write the phase handoff.**
Overwrite `.specify/memory/current-phase.md` with exactly:

```
COMPLETED_PHASE: Phase 5 — Implementation
FEATURE_SLUG: ###-feature-slug
NEXT_PHASE: Phase 6 — Validation
NEXT_ACTION: Run the full test suite and document every failure in
  .specify/memory/validation-log.md before attempting any fixes.

COMPLETED_ARTIFACTS:
- specs/###-feature-slug/tasks.md (ALL tasks marked [x])
- .specify/memory/phase5-summary.md
- .specify/memory/impl-progress.md (STATUS: COMPLETE)
- <list key source directories and files created>

PHASE_NOTES:
Tasks completed: <count>/<count> — verified by grep returning 0 unchecked tasks
Test command: <exact command>
Build command: <exact command>
Context resets during implementation: <count from impl-progress.md>
Known issues going into validation: <list or "none">
Next phase must fix ALL failures before outputting COMPLETE.
```

Verify the write:
```bash
cat .specify/memory/current-phase.md
```
Confirm all fields are present and `COMPLETED_PHASE` reads `Phase 5 — Implementation`.

**Step 4 — Mark the Phase 5 ralph task complete.**
```bash
sed -i 's/- \[ \] Phase 5: Implementation/- [x] Phase 5: Implementation/' .ralph/ralph-tasks.md
grep "Phase 5: Implementation" .ralph/ralph-tasks.md
```
The grep output must show `[x]`. If it still shows `[ ]`, edit the file
manually before continuing.

**Step 5 — Commit.**
```bash
git add -A && git commit -m "phase5: implementation complete — all tasks done"
git log --oneline -1
```

**Step 6 — Run the Pre-Signal Checklist** (replacing `phaseN` with `phase5`,
`Phase N: <name>` with `Phase 5: Implementation`).
All five items must be `[OK]`.

**Step 7 — Output the signal.**
`<promise>READY_FOR_NEXT_TASK</promise>`

---

## PHASE 6 — Validation & Bug Fix Loop

### 6-A: Orientation

Read `.specify/memory/current-phase.md`. Confirm it shows
`COMPLETED_PHASE: Phase 5` and `NEXT_PHASE: Phase 6`. If it does not, stop
and re-read the file — do not proceed until orientation is confirmed.

Extract the feature slug:
```bash
grep "^FEATURE_SLUG:" .specify/memory/current-phase.md | cut -d' ' -f2
```
Use this exact value for all paths this phase. Do not proceed if it returns
empty.

Extract the test and build commands from `PHASE_NOTES` in `current-phase.md`.

Output orientation line:
```
ORIENTATION: Executing Phase 6 — Validation | Feature: <slug>
```

Run the ralph task file guard from the ORIENTATION section. Verify
`Phase 5: Implementation` shows `[x]` and `Phase 6: Validation` shows `[ ]`.

**Verify Phase 5 actually completed:**

```bash
grep -c '^\- \[ \]' specs/###-feature-slug/tasks.md
```

If this returns anything other than 0, Phase 5 did not complete properly.
Do not run validation. Instead, treat this as a Phase 5 resume (section 5-C)
and finish the remaining tasks before returning to Phase 6.

Read ALL files in `.specify/memory/` to restore full context:
- `phase1-summary.md` through `phase5-summary.md`
- Note any known issues listed in `phase5-summary.md` — address these first

### 6-B: Execute

Run the full test suite using the exact test command from `current-phase.md`.
If no formal tests exist, perform a full build and verify every core user
flow from `spec.md`.

**Skipped tests are failures.** If a required test tool is unavailable
(e.g. Playwright not installed), install it — do not skip. If installation
genuinely fails, document it in `validation-log.md` as `[FAIL]`, not
`[PASS]` or `[SKIP]`, and treat it the same as any other failure: fix it,
or document it as `BLOCKED` with exact error evidence before proceeding.
A test that did not run has not passed.

Document every failure in `.specify/memory/validation-log.md` using this format:

```
## Run <N> — <attempt number>
FAILURES:
- [FAIL] <test name or flow>: <error summary>
RESOLVED_THIS_RUN:
- [PASS] <test name> — fixed by: <one line description>
REMAINING: <count>
```

Fix ALL failures. Do not defer or skip any. After each round of fixes,
re-run the full test suite and append a new run entry to `validation-log.md`,
marking newly resolved issues.

If a fix requires reopening a previously completed task, mark it `[ ]` again
in `tasks.md` until re-verified, then mark it `[x]` once passing.

Repeat until ALL three conditions are true:
- Zero test failures
- Clean build with no errors or warnings
- Every user story from `spec.md` verified working end-to-end

**Liveness trigger check — run this exact command first:**

```bash
grep -qiE '(start\.sh|localhost|port\s*[0-9]{4})' specs/###-feature-slug/spec.md \
  && echo "LIVENESS_REQUIRED" || echo "LIVENESS_SKIP"
```

Do not evaluate this yourself — the grep output is the decision. If the
output is `LIVENESS_SKIP`, skip the liveness block entirely. If the output
is `LIVENESS_REQUIRED`, the full liveness check below is mandatory.

**Liveness check (only reached if trigger returned `LIVENESS_REQUIRED`):**

1. Execute the startup script from a clean state — do not assume servers
   are already running:
   ```bash
   bash start.sh 2>&1 | tee /tmp/startup.log
   ```
2. For every server or service defined in the spec, confirm it responds:
   ```bash
   curl -sf http://localhost:<port> -o /dev/null && echo "UP" || echo "DOWN"
   ```
   Repeat for each expected port/endpoint. Every service must return `UP`.
3. Document confirmed URLs and HTTP response codes in `validation-log.md`:
   ```
   LIVENESS:
   - http://localhost:3001 → HTTP 200 OK
   - http://localhost:5173 → HTTP 200 OK
   ```
4. If any service returns `DOWN`, treat it as a validation failure: debug,
   fix, and re-run the full liveness check before proceeding.
5. The liveness check is only passed when every expected service is confirmed
   reachable and the `LIVENESS:` block is written to `validation-log.md`.

**If liveness check cannot be executed (blocked escape hatch):**
The escape hatch only applies if `start.sh` itself fails to run. You must
first attempt:
```bash
bash start.sh 2>&1 | head -50
```
Paste the exact output into `Evidence:` below. If `start.sh` does not
exist, that is a task failure — create it before invoking the escape hatch.
If `start.sh` runs without error, the escape hatch does not apply regardless
of what happens next — proceed with the curl checks.

If `start.sh` genuinely fails, document it in `validation-log.md`:
```
LIVENESS_BLOCKED:
Reason: <one sentence — specific technical reason, not vague>
Evidence: <exact output of `bash start.sh 2>&1 | head -50` — no paraphrasing>
Attempted: <list every approach tried before concluding it is blocked>
```

Before accepting the escape hatch as valid, run this reconciliation check:
```bash
grep -iE '(start\.sh|localhost|port\s*[0-9]{4})' specs/###-feature-slug/spec.md
```
If this returns any matches, your `Reason:` must directly address each
match — explaining specifically why each defined entry could not be reached.
A reason of "no runnable application defined in spec" is invalid if this
grep returns results. Rewrite the reason or fix the liveness issue.

Once the `LIVENESS_BLOCKED:` entry is written and reconciled:
- Confirm all automated tests (unit, integration, e2e) pass fully.
- Perform a static verification pass: confirm `start.sh` exists, is
  executable, references the correct ports, and all expected processes are
  defined and wired correctly in code.
- Only then proceed to wrap-up, appending a note to the commit:
  `git commit -m "phase6: validated — liveness blocked: <one-line reason>"`

This escape hatch exists for genuine environment constraints only. It is
not a shortcut for skipping a check that would take effort to run.

### 6-C: Wrap-Up (execute in order, do not skip any step)

Only reached when all conditions are met: zero test failures + clean build +
all user stories verified + liveness check passed or blocked with documented
evidence.

**Step 1 — Write the phase summary.**
Write `.specify/memory/phase6-summary.md` containing: total validation runs,
all failures resolved and how, final liveness check result (`PASSED` /
`SKIPPED — liveness trigger returned LIVENESS_SKIP` /
`BLOCKED — <reason>`), and confirmation that every user story from `spec.md`
is verified working.
Verify:
```bash
ls -la .specify/memory/phase6-summary.md && cat .specify/memory/phase6-summary.md
```

**Step 2 — Write the final phase handoff.**
Overwrite `.specify/memory/current-phase.md` with exactly:

```
COMPLETED_PHASE: Phase 6 — Validation
FEATURE_SLUG: ###-feature-slug
NEXT_PHASE: none — project complete
NEXT_ACTION: none

COMPLETED_ARTIFACTS:
- .specify/memory/validation-log.md
- .specify/memory/phase6-summary.md

PHASE_NOTES:
Validation runs: <count>
All tests: PASSING
Liveness: <PASSED — all services UP / SKIPPED — liveness trigger returned LIVENESS_SKIP / BLOCKED — <one-line reason>>
User stories verified: all <count> from spec.md confirmed end-to-end
```

Verify the write:
```bash
cat .specify/memory/current-phase.md
```
Confirm `COMPLETED_PHASE` reads `Phase 6 — Validation`.

**Step 3 — Mark the Phase 6 ralph task complete.**
```bash
sed -i 's/- \[ \] Phase 6: Validation/- [x] Phase 6: Validation/' .ralph/ralph-tasks.md
grep "Phase 6: Validation" .ralph/ralph-tasks.md
```
The grep output must show `[x]`. If it still shows `[ ]`, edit the file
manually before continuing.

Verify the full ralph task list now shows all 6 entries as `[x]`:
```bash
cat .ralph/ralph-tasks.md
```
Every line must read `- [x]`. If any line still shows `[ ]`, fix it before
proceeding.

**Step 4 — Commit.**
```bash
git add -A && git commit -m "phase6: validated, all tests passing"
git log --oneline -1
```

**Step 5 — Final pre-signal check.**
Run the following and confirm every item resolves `[OK]` before outputting
the signal:

```bash
echo "=== Phase 6 final exit check ==="
ls -la .specify/memory/phase6-summary.md && echo "[OK] summary exists" || echo "[MISSING] summary — do not proceed"
grep "^COMPLETED_PHASE: Phase 6" .specify/memory/current-phase.md && echo "[OK] handoff written" || echo "[MISSING] handoff — do not proceed"
grep -c '^\- \[ \]' specs/###-feature-slug/tasks.md | grep -q '^0$' && echo "[OK] zero unchecked tasks" || echo "[FAIL] unchecked tasks remain — do not proceed"
grep "Phase 6: Validation" .ralph/ralph-tasks.md | grep "\[x\]" && echo "[OK] ralph task marked [x]" || echo "[FAIL] ralph task not marked [x] — do not proceed"
git log --oneline -1
```

- [ ] `phase6-summary.md` exists and is non-empty
- [ ] `current-phase.md` shows `COMPLETED_PHASE: Phase 6 — Validation`
- [ ] `grep -c '^\- \[ \]' tasks.md` returns `0`
- [ ] `Phase 6: Validation` entry in `.ralph/ralph-tasks.md` shows `[x]`
- [ ] Phase 6 commit appears in `git log --oneline -1`

**Step 6 — Output the signal.**
`<promise>COMPLETE</promise>`

---

## Non-Negotiable Rules

- **`input-spec.md` is read exclusively in Phase 2.** All subsequent phases
  derive their context from `spec.md`, `plan.md`, the phase summaries in
  `.specify/memory/`, and `tasks.md`. Never re-read `input-spec.md` after
  Phase 2 completes.
- **Read `current-phase.md` first, every loop, before any other action.**
  It tells you which phase you are in and what to do next.
- **Output the `ORIENTATION:` line after reading `current-phase.md`, before
  any other action.** If you cannot populate it correctly, stop.
- **Run the ralph task file guard immediately after orientation, every loop.**
  An empty or missing `.ralph/ralph-tasks.md` is always an error state —
  never treat it as "nothing blocking me." Reinitialize and back-fill `[x]`
  entries for all completed phases before doing any phase work.
- **Always read the command file before executing the command.** The file
  under `.opencode/command/` is the authoritative source — never rely on
  memory of what a command did in a previous run.
- **Phase 5 may span multiple context resets.** A new loop finding
  `impl-progress.md` with `STATUS: IN_PROGRESS` must resume, not restart.
- **The completion gate in section 5-E is mandatory and non-bypassable.**
  `READY_FOR_NEXT_TASK` cannot be output from Phase 5 unless grep confirms
  zero unchecked tasks AND the final test run is clean.
- **The Pre-Signal Checklist is mandatory before every `READY_FOR_NEXT_TASK`
  or `COMPLETE` signal.** All five checklist items must be `[OK]`. No signal
  may be output if any item is `[MISSING]` or `[FAIL]`.
- **Mark the current phase `[x]` in `.ralph/ralph-tasks.md` during Wrap-Up,
  before committing and before outputting any signal.** Ralph validates this
  file independently of `tasks.md`. A phase whose ralph entry is still `[ ]`
  will have its signal rejected regardless of any other checks passing.
- Write the phase handoff to `current-phase.md` before every
  `READY_FOR_NEXT_TASK` signal. Never output that signal without updating it.
  Always verify the write with `cat .specify/memory/current-phase.md`.
- Write the phase summary to `phaseN-summary.md` before every
  `READY_FOR_NEXT_TASK` signal. Never output that signal without it.
  Always verify the write with `ls -la` and `cat`.
- The `FEATURE_SLUG` in `current-phase.md` is the authoritative source for
  the feature folder name. Never invent or hard-code it. Always extract it
  with `grep "^FEATURE_SLUG:" .specify/memory/current-phase.md | cut -d' ' -f2`.
- The ralph task list contains exactly 6 phase entries. Nothing else.
- Implementation tasks live exclusively in `tasks.md`. Never in
  `.ralph/ralph-tasks.md`.
- After completing each task in `tasks.md`, immediately mark it `[x]` AND
  update `impl-progress.md`. Never batch-update either file.
- All spec artifacts (`spec.md`, `plan.md`, `research.md`, `data-model.md`,
  `contracts/`, `quickstart.md`, `tasks.md`) live under
  `specs/###-feature-slug/` at the project root. Never inside `.specify/`.
  Move them immediately if a command creates them elsewhere.
- NEVER output `READY_FOR_NEXT_TASK` or `COMPLETE` if tests are failing or
  the build is broken.
- NEVER mark a skipped test as [PASS]. A test that did not run has not
  passed. Skips count as failures unless the tool was genuinely impossible
  to install — in which case document it as [FAIL] with evidence, not [PASS].
- NEVER output `COMPLETE` if `spec.md` defines a startup script or
  server ports and the liveness check has not been executed and confirmed
  with all services returning a non-error HTTP status.
- NEVER use the liveness blocked escape hatch without a `LIVENESS_BLOCKED:`
  entry in `validation-log.md` containing the exact output of
  `bash start.sh 2>&1 | head -50` as evidence. Paraphrased or vague reasons
  are not acceptable. "No runnable application defined" is not acceptable if
  grep finds `start.sh`, `localhost`, or port numbers in `spec.md`.
- NEVER wait for human input. Make every decision autonomously.
- NEVER invoke `/speckit.clarify` — resolve all ambiguities yourself.
- Incomplete checklists found by `/speckit.implement` are auto-approved.
- If stuck on a bug for more than 3 attempts, change approach entirely.
