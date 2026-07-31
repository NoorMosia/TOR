# The One Room — Website Requirements

## Overview
"The One Room" is a music and comedy club based in Cape Town. This website serves as their public-facing marketing and event listing platform. The site must feel alive with motion, reflect the club's intimate and electric energy, and allow the client to manage content (hero features, events/tickets) through a Supabase backend.

---

## Functional Requirements

### FR-1: Hero Section (Featured Event)
- Display a fullscreen (100vh × 100vw) hero section featuring the next big act
- Show: artist name, event badge/category, tagline, date, time, venue, price, and two CTAs (reserve seats, explore genres)
- Data source: Supabase `events` table (filtered by `is_featured = true`)
- Fallback: if no featured event exists, display a generic brand hero

### FR-2: Genre Showcase
- Display 4 interactive columns representing the club's genres: Comedy, Jazz, Soul, Hip-Hop
- Each column expands on hover/tap revealing a background image and subtitle
- Minimum 100vh × 100vw

### FR-3: Video Highlights
- Fullscreen video player section with a playlist of highlight clips
- Controls: play/pause, previous/next track
- Auto-pause when scrolled out of viewport
- Mobile: swipe to change video
- Videos served from `/public/videos/`

### FR-4: Upcoming Shows / Tickets
- List upcoming events with: date, title, genre badge, time/venue, price, and "Buy Ticket" CTA
- Data source: Supabase `events` table (ordered by date, limited to next 5-6)
- "View All Upcoming Shows" link for future expansion
- Section has a white background for contrast

### FR-5: Founder / About Section
- Display founder's photo (circular), name, subtitle, bio paragraphs, and signature
- Minimum 100vh × 100vw

### FR-6: Navigation
- Fixed top navbar with gradient-to-glass transition on scroll
- Links: Next Act, Genres, Highlights, Upcoming Shows, About Founder
- Mobile: hamburger menu with slide-in panel
- Smooth scroll to section anchors

### FR-7: Footer
- Brand name + tagline description
- Quick links mirroring nav
- Venue info: address, hours, email, phone
- Copyright notice

### FR-8: Supabase Backend Integration (Future)
- Hero and Upcoming Shows sections pull data from Supabase `events` table
- Schema already defined: `id`, `title`, `artist`, `subtitle`, `description`, `date`, `time`, `price`, `capacity`, `image_url`, `booking_url`, `is_featured`, etc.
- Public read access (no auth needed for visitors)
- Authenticated write access for admin management

---

## Non-Functional Requirements

### NFR-1: Performance
- Static site generation (Astro SSG) deployed on Vercel
- Optimized images and lazy-loaded videos
- Lighthouse performance target: 90+

### NFR-2: Animation & Feel
- Emil Kowalski-inspired motion design throughout
- Spring physics on scroll reveals (via `motion` library)
- Staggered entrance animations on lists
- Magnetic hover effects on CTAs
- Mouse-parallax on hero background
- Text shimmer effects on headliner name
- All animations respect `prefers-reduced-motion`

### NFR-3: Responsiveness
- Fully responsive across mobile (< 850px), tablet, and desktop
- Mobile-first interactions (swipe on video, stacked layouts)

### NFR-4: Accessibility
- Semantic HTML structure
- ARIA labels on interactive elements
- Keyboard-navigable
- Sufficient color contrast ratios

### NFR-5: SEO
- Sitemap generation (`@astrojs/sitemap`)
- Meta tags (title, description)
- Structured semantic markup
- Canonical URL: `https://theoneroom.co.za`

### NFR-6: Branding
- Brand: "THE ONE ROOM"
- Primary accent: `#ff0055` (hot pink/red)
- Secondary accent: `#00e5ff` (cyan)
- Dark background: `#0b0b0f`
- Typography: Inter (Google Fonts)
- Logo displayed in navbar and footer

---

## Out of Scope (For Now)
- User authentication / login pages
- Admin dashboard UI
- Payment processing
- Blog / news section
- Newsletter signup
- Social media feeds
