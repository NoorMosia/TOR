# The One Room — Implementation Tasks

## Completed

- [x] Task 1: Project scaffolding (Astro config, package.json, tsconfig)
- [x] Task 2: Create global styles (CSS reset, variables, typography, animation utilities)
- [x] Task 3: Create Layout component (HTML shell, meta, motion script initialization)
- [x] Task 4: Create Navbar component (fixed, scroll glass effect, mobile menu)
- [x] Task 5: Create Hero section (fullscreen, bg zoom, shimmer text, parallax, dummy data)
- [x] Task 6: Create Genres section (4 expanding columns with image reveals)
- [x] Task 7: Create Video Highlights section (fullscreen player, playlist, auto-pause, swipe)
- [x] Task 8: Create Upcoming Shows section (white bg, event list cards, dummy data)
- [x] Task 9: Create Founder/About section (circular photo, bio, staggered reveal)
- [x] Task 10: Create Footer component (3-column grid, links, venue info)
- [x] Task 11: Assemble index page with all components
- [x] Task 12: Add Emil Kowalski-style animations (spring reveals, stagger, magnetic hover, parallax)
- [x] Task 13: Verify build compiles successfully

## Remaining / Future

- [ ] Task 14: Wire Supabase client for Hero section (fetch featured event)
- [ ] Task 15: Wire Supabase client for Upcoming Shows (fetch events list)
- [ ] Task 16: Add `prefers-reduced-motion` media query support (disable animations)
- [ ] Task 17: Image optimization (Astro Image component or sharp processing)
- [ ] Task 18: Add Open Graph / social meta tags
- [ ] Task 19: Lighthouse audit and performance tuning
- [ ] Task 20: Add structured data (JSON-LD for events)
- [ ] Task 21: Build admin flow for managing events (authenticated Supabase writes)
- [ ] Task 22: Add "View All Shows" page with pagination
- [ ] Task 23: Booking URL integration (link tickets to external provider or in-app flow)

## Notes
- Tasks 14-15 are the immediate next priority when the client is ready to connect the backend
- All sections currently use hardcoded dummy data that mirrors the Supabase schema shape
- The `motion` library is already installed and wired — no additional deps needed for animations
