# Contract: Professional Profile Website

## Overview

This document defines the interface contracts for the professional profile website. Since this is a single-file static site with no backend, contracts primarily define internal component interfaces and DOM-level APIs.

---

## 1. DOM Structure Contract

### Container Elements

All interactive elements must be descendants of these containers:

| Element | ID/Class | Purpose | Required Children |
|---------|----------|---------|-------------------|
| `<nav>` | `#main-nav` | Fixed navigation bar | `.nav-list`, `.hamburger-menu` |
| `<main>` | `#main-content` | Main page content | All section elements |
| `<footer>` | `#main-footer` | Footer with copyright | Copyright text, back-to-top button |

### Section Structure

Each section must follow this structure:

```html
<section id="[SECTION_ID]" class="section">
  <h2 class="section-title">[Title]</h2>
  <div class="section-content">
    [Content]
  </div>
</section>
```

**Required section IDs**: `hero`, `about`, `skills`, `projects`, `resume`, `contact`

---

## 2. CSS Class Contract

### Utility Classes

| Class | Purpose | Applied To | Description |
|-------|---------|------------|-------------|
| `.hidden` | Visibility | Any | Hides element with `display: none` |
| `.fade-in` | Animation trigger | Any | Triggers fade-in animation on intersection |
| `.slide-up` | Animation trigger | Any | Triggers slide-up animation on intersection |
| `.text-reveal` | Animation trigger | Text elements | Character-by-character reveal |
| `.count-up` | Animation trigger | Numbers | Count-up animation on intersection |
| `.magnetic` | Hover effect | Buttons/links | Magnetic hover effect |
| `.glow` | Hover effect | Cards | Glow effect on hover |

### Component Classes

| Class | Purpose | Applied To | Description |
|-------|---------|------------|-------------|
| `.nav-link` | Navigation | Links in nav | Active state highlighting |
| `.skill-tag` | Skills | Skill items | Hover lift/glow effect |
| `.project-card` | Projects | Project cards | Lift and glow on hover |
| `.timeline-item` | Resume | Timeline entries | Animated line draw |
| `.form-field` | Forms | Input fields | Animated focus underline |
| `.form-submit` | Forms | Submit button | Loading state animation |

---

## 3. JavaScript API Contract

### IntersectionObserver Setup

```javascript
/**
 * Initialize IntersectionObserver for scroll-triggered animations
 * @param {Function} callback - Called when element enters viewport
 * @param {Object} options - Observer options (threshold, rootMargin)
 */
function initIntersectionObserver(callback, options = { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }) {
  // Creates observer with callback
  // Returns observer instance
}
```

**Parameters**:
- `callback`: Function receives array of intersection entries
- `options.threshold`: Ratio of visibility trigger (0.0-1.0)
- `options.rootMargin`: Margin around root for intersection calculation

**Returns**: IntersectionObserver instance

**Errors**: Throws if browser lacks IntersectionObserver support (should fallback to CSS animations)

---

### Typewriter Effect

```javascript
/**
 * Create typewriter effect for text element
 * @param {HTMLElement} element - Target element
 * @param {string[]} phrases - Array of phrases to cycle through
 * @param {Object} options - Typewriter options
 */
function createTypewriter(element, phrases, options = { speed: 100, delay: 2000 }) {
  // Writes phrases character-by-character
  // Loops through phrases indefinitely
}
```

**Parameters**:
- `element`: DOM element to animate
- `phrases`: Array of strings to cycle through
- `options.speed`: Character typing speed (ms)
- `options.delay`: Delay between phrases (ms)

**Returns**: Object with `start()`, `stop()`, `reset()` methods

---

### Smooth Scroll

```javascript
/**
 * Smooth scroll to element
 * @param {string|HTMLElement} target - Target element ID or element
 * @param {Object} options - Scroll options
 */
function smoothScrollTo(target, options = { duration: 800, easing: 'easeInOutCubic' }) {
  // Smoothly scrolls to target
}
```

**Parameters**:
- `target`: Element ID string or HTMLElement reference
- `options.duration`: Scroll duration in ms
- `options.easing`: Easing function name

**Returns**: Promise that resolves when scroll completes

---

### Form Validation

```javascript
/**
 * Validate contact form
 * @param {HTMLFormElement} form - Form element
 * @returns {Object} Validation result
 */
function validateContactForm(form) {
  // Validates form fields
  // Returns: { isValid: boolean, errors: object }
}
```

**Parameters**:
- `form`: HTMLFormElement to validate

**Returns**:
```javascript
{
  isValid: boolean,
  errors: {
    name: string | null,
    email: string | null,
    message: string | null
  }
}
```

---

## 4. Event Contract

### Navigation Events

| Event | Target | Description | Data |
|-------|--------|-------------|------|
| `nav:link-click` | `.nav-link` | User clicked nav link | `{ targetId: string }` |
| `nav:active-change` | `#main-nav` | Active link changed | `{ activeId: string }` |
| `menu:toggle` | `.hamburger-menu` | Mobile menu opened/closed | `{ isOpen: boolean }` |

### Scroll Events

| Event | Target | Description | Data |
|-------|--------|-------------|------|
| `scroll:viewport-enter` | `.fade-in`, `.slide-up` | Element entered viewport | `{ elementId: string }` |
| `scroll:phase-change` | `window` | User scrolled to new section | `{ sectionId: string }` |

### Form Events

| Event | Target | Description | Data |
|-------|--------|-------------|------|
| `form:submit` | `#contact-form` | Form submission initiated | `{ formData: object }` |
| `form:success` | `#contact-form` | Form submission successful | `{ message: string }` |
| `form:validation-error` | `#contact-form` | Form validation failed | `{ errors: object }` |

---

## 5. Custom Cursor Contract

### Cursor Elements

| Element | ID/Class | Purpose |
|---------|----------|---------|
| `.cursor-dot` | `#cursor-dot` | Main cursor follower |
| `.cursor-ring` | `#cursor-ring` | Hover-reactive ring |

### Cursor Events

| Event | Target | Description | Data |
|-------|--------|-------------|------|
| `cursor:movement` | `window` | Cursor position changed | `{ x: number, y: number }` |
| `cursor:hover-start` | Interactive elements | Element hovered | `{ elementId: string, rect: object }` |
| `cursor:hover-end` | Interactive elements | Element unhovered | `{ elementId: string }` |

---

## 6. Animation Contract

### Animation Classes

| Class | Duration | Easing | Trigger |
|-------|----------|--------|---------|
| `.fade-in` | 800ms | ease-out | Intersection |
| `.slide-up` | 600ms | ease-out | Intersection |
| `.text-reveal` | variable | linear | Intersection |
| `.count-up` | 1500ms | ease-out | Intersection |
| `.glow` | 300ms | ease-in-out | Hover |
| `.lift` | 200ms | ease-in-out | Hover |

### Animation Properties

All animations use GPU-accelerated properties:

- `transform: translate3d(x, y, z)` - Move elements
- `transform: scale(n)` - Scale elements
- `opacity: n` - Fade elements
- `filter: blur(n)` - Blur effects

---

## 7. Accessibility Contract

### ARIA Attributes

| Element | Attribute | Value | Purpose |
|---------|-----------|-------|---------|
| `<nav>` | `aria-label` | "Main navigation" | Identify nav region |
| `.nav-link` | `aria-current` | "page" | Active link indicator |
| `.hamburger-menu` | `aria-expanded` | "true/false" | Menu state |
| `.hamburger-menu` | `aria-controls` | "mobile-menu" | Target element |
| `.nav-list` | `role` | "menubar" | Menu role |
| `.nav-link` | `role` | "menuitem" | Link role |
| `.section` | `aria-label` | Section title | Section identification |
| `.project-card` | `aria-label` | Project title + description | Card description |
| `.form-field` | `aria-describedby` | Field error ID | Error association |

### Keyboard Navigation

| Element | Keys | Action |
|---------|------|--------|
| `.nav-link` | Enter, Space | Click link |
| `.hamburger-menu` | Enter, Space | Toggle menu |
| `.skill-tag` | Enter | Focus skill details |
| `.project-card` | Enter, Space | Open project link |
| `.form-field` | Tab | Move to next field |
| `#back-to-top` | Enter, Space | Scroll to top |

---

## 8. Responsive Breakpoints

| Breakpoint | Max Width | Layout Changes |
|------------|-----------|----------------|
| Mobile | 480px | Single column, stacked elements |
| Tablet | 768px | Two-column grids, reduced padding |
| Desktop | 1024px | Three-column grids, full navigation |
| Large | 1280px | Maximum width, expanded content |

---

## 9. Error Contract

### Error Types

| Code | Type | Description | Recovery |
|------|------|-------------|----------|
| `ERR_ANIMATION_UNSUPPORTED` | Fatal | Browser lacks animation support | Fallback to CSS |
| `ERR_OBSERVER_UNSUPPORTED` | Fatal | Browser lacks IntersectionObserver | Fallback to scroll events |
| `ERR_FONT_LOAD_FAILED` | Warning | Google Fonts fail to load | System font fallback |
| `ERR_GSAP_LOAD_FAILED` | Warning | GSAP fails to load | CSS animation fallback |
| `ERR_FORM_SUBMIT_FAILED` | Warning | Form submission fails | Show error message |

### Error Events

| Event | Target | Description | Data |
|-------|--------|-------------|------|
| `error:animation` | `window` | Animation error | `{ type: string, message: string }` |
| `error:resource` | `window` | Resource loading error | `{ url: string, type: string }` |

---

## 10. Performance Contract

### Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| First Contentful Paint | < 1s | Lighthouse |
| Time to Interactive | < 2s | Lighthouse |
| Animation Frame Rate | 60 FPS | Performance API |
| Scroll Performance | < 16ms per frame | Performance API |
| Memory Usage | < 50MB | Performance API |

### Performance Events

| Event | Target | Description |
|-------|--------|-------------|
| `performance:frameskip` | `window` | Frame rate dropped below 60 FPS |
| `performance:high-memory` | `window` | Memory usage exceeded threshold |

---

## Conclusion

All contracts are satisfied by the single-file architecture. No external API contracts are needed since this is a purely client-side site.
