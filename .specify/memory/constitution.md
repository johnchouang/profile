<!--
Sync Impact Report:
- Version change: 1.0.0 (initial)
- Modified principles: none (initial creation)
- Added sections: Core Principles, Quality Standards, Development Workflow, Governance
- Removed sections: none
- Templates requiring updates: ✅ constitution.md created from template
- Follow-up TODOs: none
-->

# Profile Site Constitution

## Core Principles

### I. Single-File Purity
The entire application must be contained in a single HTML file with embedded CSS and JavaScript. No external build tools, no npm dependencies, and no framework overhead. All styling and logic must be self-contained within the HTML document.

**Rules:**
- CSS must be embedded in `<style>` tags within the HTML
- JavaScript must be embedded in `<script>` tags within the HTML
- External resources (Google Fonts, GSAP CDN) are allowed via CDN links only
- No local asset files (images, icons) — use inline SVGs or CSS gradients

**Rationale:** Portability and simplicity. The site should be deployable by copying a single file.

### II. Modern Editorial Design
The visual design must convey sophistication, professionalism, and contemporary aesthetics. This is not a generic template — it must feel custom-crafted and distinctive.

**Rules:**
- Use a dark-mode editorial aesthetic with deep near-black background (#0a0a0f)
- Implement smooth transitions and subtle animations throughout
- Apply glassmorphism effects, staggered reveals, and parallax where appropriate
- Use Google Fonts: Syne for headings, DM Sans or Instrument Sans for body
- Implement custom cursor with dot + ring effects
- Include magnetic hover effects on CTAs and buttons

**Rationale:** The site must stand out as a premium portfolio, not a generic template.

### III. Interactive Motion & Animation (NON-NEGOTIABLE)
Every user-facing element must have purposeful, high-quality animations. Animation is not optional — it's core to the user experience.

**Rules:**
- Implement smooth scroll behavior for all navigation
- Use IntersectionObserver for scroll-triggered animations (fade-up reveals)
- Apply staggered character-by-character text reveal on hero section
- Cycle through multiple roles with typewriter effect
- Animate progress bars, counters, and timeline entries on scroll
- Include hover lift effects with glow on cards and buttons

**Rationale:** Motion enhances perceived quality and engagement. A static site feels incomplete.

### IV. Semantic Accessibility
The site must be fully accessible, following web standards for screen readers, keyboard navigation, and semantic structure.

**Rules:**
- Use proper HTML5 semantic elements (nav, main, section, article, footer)
- Include aria-labels on interactive elements
- Ensure proper focus states on all interactive elements
- Implement keyboard navigation for mobile menu and form fields
- Provide alternative text for all images and icons

**Rationale:** Accessibility is non-negotiable. The site must work for all users regardless of their browser or assistive technology.

### V. Responsive & Cross-Device
The site must work flawlessly across all device sizes, from mobile phones to large desktop displays.

**Rules:**
- Mobile-first approach with breakpoints at 480px, 768px, 1024px, and 1280px
- Grid layouts must collapse cleanly to single columns on mobile
- Touch targets must be at least 44px for all interactive elements
- Font sizes must scale appropriately without breaking layout

**Rationale:** Users access portfolio sites from every device. Inconsistencies are unacceptable.

## Quality Standards

### Code Quality
- All CSS must use custom properties (variables) for colors, fonts, and spacing
- JavaScript must be clean, modular, and well-organized
- No inline styles except for dynamic inline styles (e.g., GSAP animations)
- Use CSS Grid and Flexbox for all layouts
- Implement proper z-index layering to avoid stacking context issues

### Performance
- All animations must use CSS transforms or will-change for GPU acceleration
- Avoid layout thrashing by batching DOM reads/writes
- Lazy-load heavy assets where appropriate (e.g., images if added later)
- Minimize reflows and repaints in animation code

### Maintainability
- Comment complex JavaScript logic
- Organize CSS into logical sections (base, components, utilities)
- Use meaningful class names that describe purpose, not presentation
- Include placeholder markers ([REPLACE: description]) for easy content updates

## Development Workflow

### Implementation Process
1. **Structure First**: Create the complete HTML structure with semantic elements
2. **Styling Second**: Apply CSS with custom properties for easy theme adjustments
3. **Animation Last**: Add JavaScript animations and interactions after base functionality
4. **Accessibility Pass**: Review all interactive elements for keyboard navigation and screen reader support
5. **Responsive Final**: Test all breakpoints and adjust layouts as needed

### Quality Gates
- Every section must be fully functional before moving to the next
- Run lighthouse audit for accessibility, performance, and best practices (target: 95+ for all)
- Test on at least three browsers (Chrome, Firefox, Safari or mobile Safari)
- Verify smooth performance on both high-end and low-end devices

## Governance

This constitution governs all development for the profile website project. Any deviation from these principles must be justified and documented.

**Amendment Process:**
- Constitution amendments require clear rationale
- Changes must be reviewed against existing implementation
- Version numbers follow semantic versioning (MAJOR.MINOR.PATCH)

**Version**: 1.0.0 | **Ratified**: 2026-03-16 | **Last Amended**: 2026-03-16
