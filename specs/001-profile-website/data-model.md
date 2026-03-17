# Data Model: Professional Profile Website

## Overview

This document describes the data entities and their relationships for the professional profile website. Since this is a single-file static site with no backend or database, all data is embedded in the HTML file and loaded at runtime.

---

## Core Entities

### Profile

**Purpose**: Store the primary profile information displayed in the hero section and header

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Full name displayed in hero section |
| `role` | string | Yes | Primary role/position (e.g., "Full Stack Developer") |
| `tagline` | string | No | Brief tagline or summary |
| `bio` | string | Yes | Detailed biography for About section |
| `avatarUrl` | string | Yes | URL to profile photo (or CDN placeholder) |
| `email` | string | Yes | Contact email address |
| `location` | string | No | City, State/Country |
| `socialLinks` | array | Yes | Array of social media links |

**Validation Rules**:
- `name` must be non-empty string
- `role` must be non-empty string
- `bio` must be non-empty string
- `email` must be valid email format (basic regex validation)
- `socialLinks` must contain at least one link

**State Transitions**: N/A (static data)

---

### NavigationItem

**Purpose**: Define navigation links and their target sections

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `label` | string | Yes | Display text for nav link |
| `targetId` | string | Yes | ID of target section element |
| `isActive` | boolean | No | Current active state (set dynamically) |

**Validation Rules**:
- `label` must be non-empty string
- `targetId` must match existing section ID

**State Transitions**: 
- `isActive` toggles based on scroll position

---

### Section

**Purpose**: Define page sections with content

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique section identifier (used as DOM ID) |
| `title` | string | Yes | Section heading |
| `content` | string | Yes | HTML content for section |
| `isVisible` | boolean | Yes | Visibility state (initially true) |
| `animationDelay` | number | No | Delay in milliseconds before animation starts |

**Validation Rules**:
- `id` must be unique and valid HTML ID
- `title` must be non-empty string
- `content` must be valid HTML string

**State Transitions**: 
- `isVisible` changes from false to true when section enters viewport

---

### Skill

**Purpose**: Organize technical skills by category

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique skill identifier |
| `name` | string | Yes | Skill name (e.g., "JavaScript") |
| `category` | string | Yes | One of: "Languages", "Frameworks", "Tools", "Other" |
| `level` | number | No | proficiency indicator (0-100) |
| `isHighlighted` | boolean | No | Whether skill should be emphasized |

**Validation Rules**:
- `name` must be non-empty string
- `category` must be one of allowed values
- `level` must be 0-100 if provided

**State Transitions**: N/A (static data)

---

### Project

**Purpose**: Display portfolio projects with links

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique project identifier |
| `title` | string | Yes | Project title |
| `description` | string | Yes | Brief project description |
| `thumbnailUrl` | string | Yes | URL to project thumbnail |
| `techStack` | array | Yes | Array of skill names used |
| `githubUrl` | string | No | GitHub repository URL |
| `liveDemoUrl` | string | No | Live demo URL |
| `isFeatured` | boolean | No | Whether project is highlighted |

**Validation Rules**:
- `title` must be non-empty string
- `description` must be non-empty string
- At least one of `githubUrl` or `liveDemoUrl` must be provided

**State Transitions**: N/A (static data)

---

### TimelineEntry

**Purpose**: Display experience and education timeline

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique entry identifier |
| `title` | string | Yes | Role or degree title |
| `subtitle` | string | Yes | Company/institution name |
| `dateRange` | string | Yes | Period (e.g., "2020-2024") |
| `description` | string | Yes | Bullet points or description |
| `type` | string | Yes | One of: "experience", "education" |

**Validation Rules**:
- `title` must be non-empty string
- `subtitle` must be non-empty string
- `type` must be one of allowed values

**State Transitions**: N/A (static data)

---

### ContactFormState

**Purpose**: Track form submission state

**Fields**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | User's name |
| `email` | string | Yes | User's email |
| `message` | string | Yes | User's message |
| `isValid` | boolean | Yes | Whether form passes validation |
| `isSubmitting` | boolean | Yes | Whether form is being submitted |
| `isSuccess` | boolean | Yes | Whether submission succeeded |
| `error` | string | No | Error message if validation fails |

**Validation Rules**:
- `name` must be non-empty string (min 2 chars)
- `email` must be valid email format
- `message` must be non-empty string (min 10 chars)

**State Transitions**:
- `isSubmitting`: false → true on submit
- `isValid`: false → true after validation passes
- `isSuccess`: false → true after successful submission

---

## Data Flow

```
Data Sources (Embedded in HTML)
    ↓
JavaScript Parse & Validation
    ↓
Data Model (in-memory objects)
    ↓
Component Rendering (DOM updates)
    ↓
User Interface (visible to visitor)
```

---

## Initial Data Structure (Example)

```javascript
const profileData = {
  name: "Ralph Wiggum",
  role: "Professional Developer",
  tagline: "Building modern web applications",
  bio: "Full bio goes here...",
  avatarUrl: "data:image/svg+xml;base64,...",
  email: "ralph@example.com",
  location: "San Francisco, CA",
  socialLinks: [
    { platform: "GitHub", url: "https://github.com/ralphwiggum" },
    { platform: "LinkedIn", url: "https://linkedin.com/in/ralphwiggum" },
    { platform: "Twitter", url: "https://twitter.com/ralphwiggum" }
  ]
};

const skillsData = [
  { id: "js", name: "JavaScript", category: "Languages", level: 95 },
  { id: "html", name: "HTML5", category: "Languages", level: 90 },
  { id: "css", name: "CSS3", category: "Languages", level: 85 },
  { id: "react", name: "React", category: "Frameworks", level: 80 },
  { id: "gsap", name: "GSAP", category: "Tools", level: 90 },
  // ... more skills
];

const projectsData = [
  {
    id: "proj1",
    title: "E-Commerce Platform",
    description: "Full-featured e-commerce site with cart, checkout, and admin dashboard",
    thumbnailUrl: "data:image/svg+xml,...",
    techStack: ["React", "Redux", "Node.js", "PostgreSQL"],
    githubUrl: "https://github.com/ralphwiggum/ecommerce",
    liveDemoUrl: "https://ecommerce.example.com",
    isFeatured: true
  },
  // ... more projects
];

const timelineData = {
  experience: [
    {
      id: "exp1",
      title: "Senior Frontend Developer",
      subtitle: "Tech Corp",
      dateRange: "2022-2024",
      description: "• Developed and maintained large-scale React applications\n• Optimized performance for 60 FPS animations\n• Implemented accessibility features",
      type: "experience"
    }
    // ... more experience
  ],
  education: [
    {
      id: "edu1",
      title: "Computer Science",
      subtitle: "University of Technology",
      dateRange: "2018-2022",
      description: "• Major: Software Engineering\n• Minor: Human-Computer Interaction",
      type: "education"
    }
    // ... more education
  ]
};
```

---

## Data Loading Strategy

1. **Embedded in HTML**: All data is embedded in `<script type="application/json">` tags or as JavaScript objects
2. **Parse on Load**: JavaScript parses data on page load
3. **Validate**: Data is validated against schema
4. **Render**: Components render data to DOM
5. **Update**: Dynamic updates (e.g., active nav link) modify in-memory state

---

## Performance Considerations

- All data loads synchronously (no network requests)
- Minimal memory footprint (static data, no large datasets)
- No data caching required (single-page, no state persistence)

---

## Accessibility Considerations

- All data is available in DOM for screen readers
- No data loading delays that could impact accessibility
- Semantic HTML structure ensures proper data hierarchy
