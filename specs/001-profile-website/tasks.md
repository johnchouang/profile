# Tasks: Professional Profile Website

**Input**: Design documents from `/specs/001-profile-website/`  
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

---

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [x] T001 Create project structure with single-file architecture (`profile.html`)
- [ ] T002 [P] Initialize HTML5 boilerplate with semantic structure (`profile.html:1-50`)
- [ ] T003 [P] Setup Google Fonts import and CDN links for GSAP (`profile.html:51-65`)
- [ ] T004 [P] Configure CSS custom properties for colors, fonts, and spacing (`profile.html:66-150`)
- [ ] T005 [P] Create base utility classes (hidden, fade-in, slide-up) (`profile.html:151-180`)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

- [ ] T006 Setup IntersectionObserver for scroll-triggered animations (`profile.html:181-240`)
- [ ] T007 [P] Implement smooth scroll behavior for navigation links (`profile.html:241-300`)
- [ ] T008 [P] Create mobile hamburger menu with overlay animation (`profile.html:301-380`)
- [ ] T009 [P] Setup custom cursor system (dot + ring elements) (`profile.html:381-450`)
- [ ] T010 [P] Initialize typewriter effect for hero roles (`profile.html:451-520`)
- [ ] T011 Setup form validation and success overlay system (`profile.html:521-600`)
- [ ] T012 [P] Implement responsive breakpoints and mobile-first CSS (`profile.html:601-700`)
- [ ] T013 [P] Setup accessibility attributes (ARIA labels, keyboard navigation) (`profile.html:701-750`)

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - View Profile Hero Section (P1) 🎯 MVP

**Goal**: Hero section with typewriter effect and CTAs that convey value proposition

**Independent Test**: Load page, verify hero displays with name, typewriter effect, and functional CTAs

### Implementation for User Story 1

- [ ] T014 [P] [US1] Create hero section HTML structure with name, tagline, and CTAs (`profile.html:751-820`)
- [ ] T015 [US1] Initialize typewriter effect with profile roles array (`profile.html:821-880`)
- [ ] T016 [US1] Implement character-by-character reveal animation for name (`profile.html:881-940`)
- [ ] T017 [US1] Setup CTA button click handlers for smooth scroll (`profile.html:941-1000`)
- [ ] T018 [US1] Add hover effects to CTAs (lift and glow) (`profile.html:1001-1060`)
- [ ] T019 [US1] Configure parallax background effect on hero (`profile.html:1061-1120`)

**Checkpoint**: User Story 1 fully functional and testable independently

---

## Phase 4: User Story 2 - Navigate Full Site (P1)

**Goal**: Fixed navigation with smooth scroll and mobile menu for site-wide access

**Independent Test**: Click nav links, verify smooth scroll to correct sections with active highlighting

### Implementation for User Story 2

- [ ] T020 [P] [US2] Create fixed navigation bar with logo and nav links (`profile.html:1121-1180`)
- [ ] T021 [US2] Implement scroll-based nav blur/darken effect (`profile.html:1181-1240`)
- [ ] T022 [US2] Setup active link highlighting based on scroll position (`profile.html:1241-1300`)
- [ ] T023 [US2] Configure mobile hamburger menu with full-screen overlay (`profile.html:1301-1360`)
- [ ] T024 [US2] Add menu close on mobile link selection (`profile.html:1361-1420`)
- [ ] T025 [US2] Test and verify smooth scroll to all sections (`profile.html:1421-1480`)

**Checkpoint**: User Story 2 fully functional and testable independently

---

## Phase 5: User Story 3 - View About Section (P2)

**Goal**: Bio, stats, and background information with animated reveal

**Independent Test**: Scroll to About, verify bio displays, stat cards animate, background word appears

### Implementation for User Story 3

- [ ] T026 [P] [US3] Create About section HTML with bio and stats container (`profile.html:1481-1540`)
- [ ] T027 [US3] Implement two-column layout (bio left, stats right) (`profile.html:1541-1600`)
- [ ] T028 [US3] Setup count-up animation for stat cards on scroll (`profile.html:1601-1660`)
- [ ] T029 [US3] Add decorative background word with low opacity (`profile.html:1661-1720`)
- [ ] T030 [US3] Configure staggered fade-up reveal for bio content (`profile.html:1721-1780`)

**Checkpoint**: User Story 3 fully functional and testable independently

---

## Phase 6: User Story 4 - View Skills Section (P2)

**Goal**: Categorized skill tags with hover lift/glow effects

**Independent Test**: Scroll to Skills, verify categories display with hover effects

### Implementation for User Story 4

- [ ] T031 [P] [US4] Create Skills section with categorized skill tags (`profile.html:1781-1840`)
- [ ] T032 [US4] Setup skill categories (Languages, Frameworks, Tools, Other) (`profile.html:1841-1900`)
- [ ] T033 [US4] Implement hover lift and glow effects on skill tags (`profile.html:1901-1960`)
- [ ] T034 [US4] Add decorative accent line animation (`profile.html:1961-2020`)
- [ ] T035 [US4] Configure fade-up reveal for skill categories on scroll (`profile.html:2021-2080`)

**Checkpoint**: User Story 4 fully functional and testable independently

---

## Phase 7: User Story 5 - View Projects Gallery (P2)

**Goal**: Portfolio projects with thumbnails, descriptions, and links

**Independent Test**: Scroll to Projects, verify cards display with hover effects and functional links

### Implementation for User Story 5

- [ ] T036 [P] [US5] Create Projects section with 3-column grid layout (`profile.html:2081-2140`)
- [ ] T037 [US5] Setup project card structure (thumbnail, title, description, tech tags, buttons) (`profile.html:2141-2200`)
- [ ] T038 [US5] Implement hover lift and glow effects on project cards (`profile.html:2201-2260`)
- [ ] T039 [US5] Add thumbnail placeholder gradients with fallback text (`profile.html:2261-2320`)
- [ ] T040 [US5] Configure GitHub and Live Demo button click handlers (`profile.html:2321-2380`)
- [ ] T041 [US5] Setup staggered fade-up reveal for project cards on scroll (`profile.html:2381-2440`)

**Checkpoint**: User Story 5 fully functional and testable independently

---

## Phase 8: User Story 6 - View Resume Section (P2)

**Goal**: Experience and education timeline with animated line draw

**Independent Test**: Scroll to Resume, verify timeline displays with animated line draw and entry content

### Implementation for User Story 6

- [ ] T042 [P] [US6] Create Resume section with vertical timeline structure (`profile.html:2441-2500`)
- [ ] T043 [US6] Setup Experience and Education columns with entries (`profile.html:2501-2560`)
- [ ] T044 [US6] Implement animated timeline line draw with IntersectionObserver (`profile.html:2561-2620`)
- [ ] T045 [US6] Configure entry content with role, institution, date, and bullet points (`profile.html:2621-2680`)
- [ ] T046 [US6] Add fade-up reveal animation for timeline entries on scroll (`profile.html:2681-2740`)

**Checkpoint**: User Story 6 fully functional and testable independently

---

## Phase 9: User Story 7 - Contact Form Interaction (P3)

**Goal**: Form validation and success overlay for visitor communication

**Independent Test**: Fill form, submit, verify success message overlay appears

### Implementation for User Story 7

- [ ] T047 [P] [US7] Create Contact section with styled form fields (`profile.html:2741-2800`)
- [ ] T048 [US7] Setup form field animation on focus (underline effect) (`profile.html:2801-2860`)
- [ ] T049 [US7] Implement client-side form validation (name, email, message) (`profile.html:2861-2920`)
- [ ] T050 [US7] Configure form submission with loading state on button (`profile.html:2921-2980`)
- [ ] T051 [US7] Setup success message overlay with close button (`profile.html:2981-3040`)
- [ ] T052 [US7] Add error display for validation failures (`profile.html:3041-3100`)

**Checkpoint**: User Story 7 fully functional and testable independently

---

## Phase 10: User Story 8 - Custom Cursor Experience (P3)

**Goal**: Dot + ring cursor that follows mouse and reacts to hover states

**Independent Test**: Move mouse, verify cursor follows with dot + ring and reacts to hover

### Implementation for User Story 8

- [ ] T053 [P] [US8] Update cursor dot element with smooth position interpolation (`profile.html:3101-3160`)
- [ ] T054 [US8] Configure cursor ring with expand/contract on hover targets (`profile.html:3161-3220`)
- [ ] T055 [US8] Setup hover state detection for interactive elements (`profile.html:3221-3280`)
- [ ] T056 [US8] Add cursor change on hover (ring expands, dot color changes) (`profile.html:3281-3340`)
- [ ] T057 [US8] Configure smooth cursor movement with mouse tracking (`profile.html:3341-3400`)

**Checkpoint**: User Story 8 fully functional and testable independently

---

## Phase 11: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T058 [P] Add footer with copyright, year auto-update, and back-to-top button (`profile.html:3401-3460`)
- [ ] T059 [P] Setup back-to-top button with smooth scroll to top (`profile.html:3461-3520`)
- [ ] T060 [P] Add placeholder data JSON structure for easy customization (`profile.html:3521-3600`)
- [ ] T061 [P] Verify all animations use GPU-accelerated properties (transform, opacity) (`profile.html:3601-3660`)
- [ ] T062 [P] Test and verify responsiveness at all breakpoints (480px, 768px, 1024px, 1280px) (`profile.html:3661-3720`)
- [ ] T063 Run accessibility audit (Lighthouse, keyboard navigation, screen reader) (`profile.html:3721-3780`)
- [ ] T064 [P] Optimize performance (reduce reflows, use requestAnimationFrame) (`profile.html:3781-3840`)
- [ ] T065 [P] Add error handling for font loading failures (system font fallback) (`profile.html:3841-3900`)
- [ ] T066 [P] Add error handling for GSAP loading failures (CSS fallback) (`profile.html:3901-3960`)
- [ ] T067 [P] Verify JavaScript degrades gracefully when disabled (static HTML fallback) (`profile.html:3961-4020`)
- [ ] T068 [P] Add keyboard navigation support for all interactive elements (`profile.html:4021-4080`)
- [ ] T069 [P] Configure focus states for accessibility (visible focus rings) (`profile.html:4081-4140`)
- [ ] T070 Run quickstart.md validation (content updates, theme customization) (`profile.html:4141-4200`)
- [ ] T071 [P] Code cleanup and refactoring (remove debug code, optimize selectors) (`profile.html:4201-4260`)
- [ ] T072 [P] Add inline SVG placeholders for project thumbnails (`profile.html:4261-4320`)
- [ ] T073 [P] Setup year auto-update for copyright footer (`profile.html:4321-4380`)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-10)**: All depend on Foundational phase completion
  - User stories can proceed in priority order (P1 → P2 → P3) or in parallel
- **Polish (Phase 11)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational - May integrate with US1 but independently testable
- **User Story 3 (P2)**: Can start after Foundational - May integrate with US1/US2 but independently testable
- **User Story 4 (P2)**: Can start after Foundational - May integrate with US1/US2/US3 but independently testable
- **User Story 5 (P2)**: Can start after Foundational - May integrate with US1/US2/US3/US4 but independently testable
- **User Story 6 (P2)**: Can start after Foundational - May integrate with US1/US2/US3/US4/US5 but independently testable
- **User Story 7 (P3)**: Can start after Foundational - May integrate with other stories but independently testable
- **User Story 8 (P3)**: Can start after Foundational - May integrate with other stories but independently testable

### Within Each User Story

- HTML structure first
- CSS styling second
- JavaScript functionality last
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel
- Once Foundational phase completes, all user stories can start in parallel
- All polish tasks marked [P] can run in parallel

---

## Summary

**Total Tasks**: 73  
**Tasks per User Story**: US1 (6), US2 (6), US3 (5), US4 (5), US5 (6), US6 (5), US7 (6), US8 (5)  
**Phases Created**: 11 (Setup, Foundational, 8 User Stories, Polish)  
**Key Implementation Areas**: HTML5 structure, CSS3 styling, IntersectionObserver animations, typewriter effects, smooth scroll, custom cursor, form validation, responsive design, accessibility
