# The One Room — Design Document

## Architecture

```
┌─────────────────────────────────────────────────┐
│                  Vercel (CDN)                    │
│              Static HTML/CSS/JS                  │
└─────────────────────┬───────────────────────────┘
                      │ deployed from
┌─────────────────────┴───────────────────────────┐
│              Astro (SSG Build)                   │
│                                                  │
│  src/                                            │
│  ├── pages/index.astro          (page assembly)  │
│  ├── layouts/Layout.astro       (shell + meta)   │
│  ├── components/                                 │
│  │   ├── Navbar.astro                            │
│  │   ├── Hero.astro                              │
│  │   ├── Genres.astro                            │
│  │   ├── VideoHighlights.astro                   │
│  │   ├── UpcomingShows.astro                     │
│  │   ├── Founder.astro                           │
│  │   └── Footer.astro                            │
│  └── styles/global.css          (variables/reset)│
└─────────────────────┬───────────────────────────┘
                      │ (future) fetches at build
┌─────────────────────┴───────────────────────────┐
│              Supabase (Backend)                   │
│                                                  │
│  Tables: events                                  │
│  Storage: event-images bucket                    │
│  Auth: email/password for admin                  │
└──────────────────────────────────────────────────┘
```

---

## Component Design

### Layout (`Layout.astro`)
- HTML shell with meta tags, font preloads, favicon links
- Imports global CSS
- Contains the `motion` library animation initialization script
- Handles scroll-reveal observer setup

### Navbar
- Fixed position, z-index 100
- Background transitions: transparent gradient → solid blurred glass on scroll (>80px)
- Mobile: hamburger toggle → 280px slide-in panel from right
- All links use smooth-scroll anchors

### Hero
- Background: full-cover image with slow zoom keyframe (20s)
- Overlay: gradient from transparent top to near-opaque bottom
- Content: badge → h1 (artist) → tagline → event details → CTAs
- Animations: spring-staggered entrance on load, mouse-parallax on bg, shimmer on h1
- Scroll indicator at bottom (pulsing line)

### Genres
- CSS flexbox, 4 columns, each `flex: 1` expanding to `flex: 2.5` on hover
- Each column: solid color bg + hidden image overlay revealed on hover
- Text rotates from vertical to horizontal on expand
- Transition: `cubic-bezier(0.25, 1, 0.5, 1)` (spring feel)

### Video Highlights
- HTML5 `<video>` element, object-fit cover, fullscreen
- Playlist data passed as JSON data attribute
- Controls: big center play button (disappears on play), bottom bar (prev/play/next)
- IntersectionObserver for auto-pause
- Touch swipe detection for mobile navigation

### Upcoming Shows
- White background section for visual contrast
- Card list: date badge | info (title + meta) | action (price + ticket btn)
- Staggered spring entrance on scroll
- Hover: lift + accent border + shadow

### Founder
- Two-column layout (image left, content right)
- Circular image with accent border + glow shadow
- Hover: subtle scale + rotation
- Bio text with staggered reveal

### Footer
- 3-column grid (brand, quick links, visit info)
- Subtle link hover animations (color + translateX)
- Bottom bar with copyright

---

## Animation System

Using the `motion` library (successor to Framer Motion for vanilla JS):

| Effect | Technique | Where |
|--------|-----------|-------|
| Scroll reveal | `inView()` + `animate()` with spring easing | All sections |
| Staggered list | `stagger()` delay function | Shows list, hero content |
| Magnetic hover | mousemove → translate, mouseleave → spring back | All buttons/CTAs |
| Parallax | mousemove → bg translate | Hero background |
| Text shimmer | backgroundPosition animation | Hero h1 |
| Expand columns | CSS transition with spring cubic-bezier | Genres |
| Scale reveal | opacity + scale spring | Founder image |

Spring configurations:
- Reveal: `stiffness: 100, damping: 18, mass: 1`
- Scale: `stiffness: 120, damping: 20, mass: 1.2`
- Lists: `stiffness: 150, damping: 20`
- Magnetic return: `stiffness: 200, damping: 15`

---

## Data Model

### Current: Dummy Data
All content is hardcoded in component frontmatter as JS objects/arrays.

### Future: Supabase Integration
```typescript
// Fetch featured event for hero
const { data: featured } = await supabase
  .from('events')
  .select('*')
  .eq('is_featured', true)
  .single();

// Fetch upcoming shows
const { data: shows } = await supabase
  .from('events')
  .select('*')
  .gte('date', new Date().toISOString().split('T')[0])
  .order('date', { ascending: true })
  .limit(5);
```

---

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Framework | Astro 7.x (SSG) |
| Deployment | Vercel (static adapter) |
| Animations | `motion` (v12.x) |
| Backend (future) | Supabase (Postgres + Auth + Storage) |
| Fonts | Inter (Google Fonts) |
| Language | TypeScript (strict) |
| SEO | @astrojs/sitemap |

---

## File Structure

```
src/
├── components/
│   ├── Navbar.astro
│   ├── Hero.astro
│   ├── Genres.astro
│   ├── VideoHighlights.astro
│   ├── UpcomingShows.astro
│   ├── Founder.astro
│   └── Footer.astro
├── layouts/
│   └── Layout.astro
├── pages/
│   └── index.astro
└── styles/
    └── global.css

public/
├── images/          (static images)
├── videos/          (highlight clips)
├── logos/           (brand assets)
└── fonts/           (if self-hosted)

supabase/
└── schema.sql       (database schema)
```
