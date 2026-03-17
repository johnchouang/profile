# Quick Start: Professional Profile Website

## Overview

This quick start guide helps developers quickly understand and modify the profile website. All code is contained in a single HTML file for maximum portability.

---

## File Structure

```
profile.html          # Single HTML file (entire site)
```

**No additional files required.** The site is deployed by copying `profile.html` to any web server or opening it directly in a browser.

---

## Quick Start Steps

### 1. Open the Site

```bash
# Option 1: Open in browser directly
open profile.html

# Option 2: Local web server
npx serve .  # or python -m http.server
```

### 2. View the Site

The site should load in your default browser with:
- Hero section with typewriter effect
- Fixed navigation bar
- All sections visible with scroll animations

---

## Customization Guide

### 1. Update Profile Information

**Location**: `<script type="application/json" id="profile-data">` in HTML

**Fields to update**:
```javascript
{
  "name": "Your Name",
  "role": "Your Role",
  "tagline": "Your tagline",
  "bio": "Your detailed bio",
  "email": "your@email.com",
  "location": "Your Location",
  "socialLinks": [
    { "platform": "GitHub", "url": "https://github.com/yourusername" },
    { "platform": "LinkedIn", "url": "https://linkedin.com/in/yourusername" },
    { "platform": "Twitter", "url": "https://twitter.com/yourusername" }
  ]
}
```

### 2. Update Skills

**Location**: `<script type="application/json" id="skills-data">` in HTML

**Format**:
```javascript
[
  {
    "id": "skill-1",
    "name": "Skill Name",
    "category": "Languages|Frameworks|Tools|Other",
    "level": 85
  }
]
```

### 3. Update Projects

**Location**: `<script type="application/json" id="projects-data">` in HTML

**Format**:
```javascript
[
  {
    "id": "project-1",
    "title": "Project Title",
    "description": "Project description",
    "thumbnailUrl": "data:image/svg+xml,...",
    "techStack": ["Tech 1", "Tech 2"],
    "githubUrl": "https://github.com/...",
    "liveDemoUrl": "https://demo.example.com"
  }
]
```

### 4. Update Timeline

**Location**: `<script type="application/json" id="timeline-data">` in HTML

**Format**:
```javascript
{
  "experience": [
    {
      "id": "exp-1",
      "title": "Role",
      "subtitle": "Company",
      "dateRange": "2020-2024",
      "description": "• Bullet point 1\n• Bullet point 2",
      "type": "experience"
    }
  ],
  "education": [
    {
      "id": "edu-1",
      "title": "Degree",
      "subtitle": "Institution",
      "dateRange": "2016-2020",
      "description": "• Bullet point 1\n• Bullet point 2",
      "type": "education"
    }
  ]
}
```

---

## Theme Customization

### Colors

**Location**: CSS `:root` variables at top of `<style>` tag

```css
:root {
  --bg-primary: #0a0a0f;        /* Main background */
  --bg-secondary: #1a1a24;      /* Secondary background */
  --text-primary: #ffffff;      /* Main text */
  --text-secondary: #a0a0b0;    /* Secondary text */
  --accent-primary: #6366f1;    /* Primary accent */
  --accent-secondary: #8b5cf6;  /* Secondary accent */
  --accent-tertiary: #d946ef;   /* Tertiary accent */
  --success: #10b981;           /* Success color */
  --error: #ef4444;             /* Error color */
}
```

### Fonts

**Location**: CSS `@import` statements at top of `<style>` tag

```css
@import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=DM+Sans:wght@400;500;700&family=JetBrains+Mono:wght@400;500;700&display=swap');
```

**To change fonts**: Update the `family=` parameter with your preferred Google Fonts

---

## Animation Configuration

### Scroll Animation Threshold

**Location**: JavaScript `initIntersectionObserver()` call

```javascript
const observerOptions = {
  threshold: 0.1,              // 10% visibility trigger
  rootMargin: '0px 0px -50px 0px'  // Trigger 50px before visible
};
```

### Typewriter Speed

**Location**: JavaScript `createTypewriter()` call

```javascript
const typewriterOptions = {
  speed: 100,         // ms per character
  delay: 2000         // ms between phrases
};
```

### Smooth Scroll Duration

**Location**: JavaScript `smoothScrollTo()` calls

```javascript
smoothScrollTo(target, {
  duration: 800,      // ms
  easing: 'easeInOutCubic'
});
```

---

## Debugging

### Enable Debug Mode

Add to JavaScript initialization:

```javascript
const DEBUG = true;  // Set to false for production
```

### View Console Logs

- All animations log start/end
- Form validation logs each step
- Error states logged with details

### Check Lighthouse

Run Lighthouse audit for:
- Accessibility (target: 95+)
- Performance (target: 95+)
- Best Practices (target: 95+)

```bash
npx lighthouse profile.html --view
```

---

##常见问题

### Q: Site doesn't load animations
**A**: Check browser console for JavaScript errors. Ensure IntersectionObserver is supported (all modern browsers support it).

### Q: Fonts don't appear correctly
**A**: Check internet connection for Google Fonts CDN. System fonts will be used as fallback.

### Q: Custom cursor not working
**A**: Ensure JavaScript is enabled. Custom cursor is purely visual and doesn't affect functionality.

### Q: Form submission not working
**A**: Form validation works client-side, but actual submission requires backend integration. Success message shows after validation.

---

## Next Steps

1. **Customize content**: Update all `[REPLACE: ...]` placeholders
2. **Test animations**: Verify all scroll-triggered animations work
3. **Check responsiveness**: Test at all breakpoints (480px, 768px, 1024px, 1280px)
4. **Accessibility audit**: Verify keyboard navigation and screen reader support
5. **Lighthouse audit**: Run performance and accessibility checks
6. **Deploy**: Copy `profile.html` to web server or CDN

---

## Support

For issues or questions:
1. Check browser console for errors
2. Verify all data JSON is valid
3. Check CSS custom properties are defined
4. Ensure JavaScript is not blocked

---

## Version History

- **v1.0.0** (2026-03-16): Initial release - Single-file professional profile site
