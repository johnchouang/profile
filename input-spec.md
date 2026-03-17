Build me a complete, single-file professional profile website in HTML/CSS/JS (no frameworks, no external dependencies except Google Fonts and optionally GSAP via CDN).

---

## DESIGN DIRECTION

Go for a dark-mode editorial aesthetic — think premium tech portfolio meets design studio. The vibe is: confident, modern, and sophisticated. Not loud, but impossible to ignore.

**Palette:**
- Background: deep near-black (#0a0a0f)
- Surface: subtle dark panels (#12121a)
- Primary accent: electric cyan (#00f0ff) or a bold amber (#f5a623) — pick whichever feels more editorial and commit to it
- Text: off-white (#e8e8f0) with muted secondary text (#6b6b80)

**Typography:**
- Display/headings: "Syne" (Google Fonts) — geometric, modern, distinctive
- Body: "DM Sans" or "Instrument Sans" — clean, readable, not generic
- Monospace accents (for tags/skills): "JetBrains Mono"

**Motion & Effects:**
- Smooth scroll behavior
- Staggered fade-up reveal animations on scroll (use IntersectionObserver)
- Subtle parallax on the hero background
- Magnetic hover effect on the CTA button
- Cursor: custom dot + ring cursor that reacts to hover states
- Glassmorphism cards with subtle border glow on hover
- Animated gradient mesh or noise texture on the hero background

---

## SECTIONS TO BUILD

### 1. NAVIGATION
- Fixed top nav, blurs/darkens on scroll
- Logo/name on the left (monogram or full name)
- Nav links: About, Skills, Projects, Resume, Contact
- Smooth scroll to each section
- Mobile: hamburger menu with a full-screen slide-in overlay (animated)
- Active section highlighting as user scrolls

### 2. HERO / PROFILE
- Full viewport height
- Large display name with a subtle character-by-character reveal animation on load
- Animated typewriter effect for role/title (cycle through 2–3 roles like "Software Engineer", "Open Source Builder", "Full-Stack Developer")
- Short 1–2 line tagline beneath
- Two CTAs: "View My Work" (scrolls to Projects) and "Contact Me" (scrolls to Contact)
- Profile photo placeholder (circular, with glowing border animation) OR a stylized abstract avatar graphic
- Animated background: subtle moving gradient mesh or SVG particle field

### 3. ABOUT
- Two-column layout: left has a secondary photo or geometric graphic, right has bio text
- 3–4 sentences of placeholder bio text with clear [PLACEHOLDER] markers for easy replacement
- Quick stat cards below: e.g., "X Years Experience", "Y Projects Shipped", "Z Technologies" — with animated count-up on scroll
- Include a subtle decorative large background word (e.g., "ABOUT") at low opacity behind the section heading

### 4. SKILLS
- Section heading with decorative accent line
- Skills displayed as an animated tag cloud OR categorized grid (Technical / Tools / Soft Skills)
- Each skill chip/tag has a subtle hover lift + glow
- Skill categories: Languages, Frameworks, Tools & DevOps, Other
- Include placeholder skills with [REPLACE] markers
- Progress bars or proficiency indicators are optional — if included, animate them filling on scroll

### 5. PROJECTS
- 3-column card grid (collapses to 1 on mobile)
- Each card includes:
  - Project thumbnail placeholder (stylized gradient panel with icon)
  - Project name
  - Short description (1–2 lines)
  - Tech stack tags
  - Two icon buttons: GitHub link + Live Demo link
- Cards lift and glow on hover
- Optional: a "Featured Project" spotlight above the grid (full-width with more detail)
- Include 4–6 placeholder project cards with [REPLACE] markers

### 6. RESUME
- Two sub-sections: Experience & Education, side by side on desktop, stacked on mobile
- Vertical timeline design with animated line draw on scroll
- Each entry: Role/Degree, Company/Institution, Date range, 2–3 bullet points
- "Download Resume" button (links to a placeholder PDF path) with a download icon
- Include 2–3 placeholder experience entries and 1–2 education entries with [REPLACE] markers

### 7. CONTACT
- Clean, minimal form layout
- Fields: Full Name, Email Address, Message (textarea)
- Stylized inputs with animated underline-focus effect (not boring boxes)
- Submit button with a loading/spinner animation state
- Form is client-side only (no backend) — on submit, show a success message overlay
- Below the form: social icon links (GitHub, LinkedIn, Twitter/X, Email) with hover animations
- Include your location/timezone as a placeholder line

### 8. FOOTER
- Minimal one-line footer
- Copyright + name + year (auto-updated via JS)
- "Built with ☕ and code" or similar personal touch
- Back-to-top button (smooth scroll, appears after user scrolls down)

---

## TECHNICAL REQUIREMENTS

- Single HTML file — all CSS in <style> tags, all JS in <script> tags
- No build tools, no npm, no React — pure HTML/CSS/JS
- Google Fonts loaded via @import in CSS
- GSAP can be loaded via CDN (https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js) for complex animations if needed; otherwise use CSS keyframes + IntersectionObserver
- Fully responsive: mobile-first, tested breakpoints at 480px, 768px, 1024px, 1280px
- Semantic HTML5 elements throughout (nav, main, section, article, footer)
- Accessible: proper aria-labels, focus states, keyboard navigation
- CSS custom properties (variables) for all colors, fonts, and spacing
- All placeholder content clearly marked with [REPLACE: description] so I can find and update it easily

---

## QUALITY BAR

This should look like it cost $5,000 to design. Every section transition, hover state, and spacing choice should feel intentional. The site should be able to stand alongside portfolio sites from senior engineers at top-tier companies. Do not produce a generic template — make it feel genuinely crafted and distinctive.

Output the full, complete, working HTML file with no truncation.
