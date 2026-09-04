-- =============================================================================
-- The One Room — Supabase Database Schema
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Events Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  artist TEXT,
  subtitle TEXT,
  description TEXT,
  short_description TEXT,
  date DATE NOT NULL,
  time TIME NOT NULL,
  price TEXT,
  capacity TEXT,
  image_url TEXT,
  image_alt TEXT,
  booking_url TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Vibes Table (What Happens Here section)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS vibes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  caption TEXT NOT NULL,
  sub TEXT,
  image_url TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Videos Table (Video Highlights section)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  category TEXT,
  src TEXT NOT NULL,
  poster TEXT,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- Site Content Table (key/value store for editable copy)
-- Keys: founder_name, founder_role, founder_quote, founder_bio, founder_image,
--       venue_address, venue_email, venue_phone, venue_hours,
--       footer_tagline, hero_label, site_title, site_description
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS site_content (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed default site content
INSERT INTO site_content (key, value) VALUES
  ('founder_name',    'Nomakhosini Dyosopu'),
  ('founder_role',    'Founder'),
  ('founder_quote',   'I wanted a room where the music doesn''t have to explain itself. Where comedy doesn''t have to be safe. Where artists feel like they''re home.'),
  ('founder_bio',     'A decade in Cape Town''s nightlife, from booking acts in backrooms to building The One Room from nothing. Nomakhosini created a space that doesn''t compromise — for artists or for the people who come to listen.'),
  ('founder_image',   '/images/noma.jpg'),
  ('venue_address',   '52 Westbourne Rd, Gqeberha'),
  ('venue_email',     'info@theoneroom.co.za'),
  ('venue_phone',     '+27 (0) 21 555 0199'),
  ('venue_hours',     'Wed — Sun from 7 PM'),
  ('footer_tagline',  'Music. Comedy. Gqeberha.'),
  ('hero_label',      'Next up'),
  ('site_title',      'The One Room | Music & Comedy Club — Gqeberha'),
  ('site_description','Live jazz, soul, hip-hop and stand-up comedy in Gqeberha. The One Room — where artists feel like they''re home.')
ON CONFLICT (key) DO NOTHING;

-- Seed default vibes
INSERT INTO vibes (caption, sub, image_url, sort_order) VALUES
  ('Comedy Night',  'Loyiso Gola',        '/images/comedy1.jpg', 0),
  ('Jazz Sessions', 'Live Brass Fridays', '/images/jazz.jpg',    1),
  ('Open Mic',      'Every Wednesday',    '/images/comedy2.jpg', 2),
  ('Soul Sundays',  'Neo-Soul & R&B',     '/images/comedy3.jpg', 3)
ON CONFLICT DO NOTHING;

-- Seed default videos
INSERT INTO videos (title, category, src, sort_order) VALUES
  ('Zoë Modiga — Live', 'Concert', '/videos/landscape2.mp4', 0),
  ('Late Night Jazz',   'Session', '/videos/portrait2.mp4',  1)
ON CONFLICT DO NOTHING;

-- -----------------------------------------------------------------------------
-- Auto-update triggers for updated_at
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER events_updated_at
  BEFORE UPDATE ON events
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER vibes_updated_at
  BEFORE UPDATE ON vibes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER videos_updated_at
  BEFORE UPDATE ON videos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- site_content has no trigger — key/value, manual update is fine

-- -----------------------------------------------------------------------------
-- Row Level Security (RLS)
-- -----------------------------------------------------------------------------
ALTER TABLE events      ENABLE ROW LEVEL SECURITY;
ALTER TABLE vibes       ENABLE ROW LEVEL SECURITY;
ALTER TABLE videos      ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_content ENABLE ROW LEVEL SECURITY;

-- Public read
CREATE POLICY "Public read access" ON events       FOR SELECT USING (true);
CREATE POLICY "Public read access" ON vibes        FOR SELECT USING (true);
CREATE POLICY "Public read access" ON videos       FOR SELECT USING (true);
CREATE POLICY "Public read access" ON site_content FOR SELECT USING (true);

-- Authenticated write
CREATE POLICY "Authenticated write access" ON events       FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated write access" ON vibes        FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated write access" ON videos       FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated write access" ON site_content FOR ALL USING (auth.role() = 'authenticated');

-- =============================================================================
-- Supabase Storage — event-images bucket
--   Public read, authenticated write, JPEG/PNG/WEBP, max 5MB
-- =============================================================================

-- =============================================================================
-- Supabase Auth — Email OTP enabled, rate limiting on
-- =============================================================================
