-- =============================================================================
-- The One Room — Supabase Database Schema
-- =============================================================================
-- This file defines the events table, RLS policies, and supporting functions
-- for The One Room venue website.
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
-- Auto-update trigger for updated_at
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
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- -----------------------------------------------------------------------------
-- Row Level Security (RLS)
-- -----------------------------------------------------------------------------
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Public read access: anyone can SELECT events
CREATE POLICY "Public read access"
  ON events
  FOR SELECT
  USING (true);

-- Authenticated write access: only logged-in users can INSERT, UPDATE, DELETE
CREATE POLICY "Authenticated write access"
  ON events
  FOR ALL
  USING (auth.role() = 'authenticated');

-- =============================================================================
-- Supabase Storage Configuration (applied via Supabase Dashboard or CLI)
-- =============================================================================
-- Bucket: event-images
--   - Public read access (images served without auth)
--   - Authenticated write access (upload/delete requires auth)
--   - Accepted MIME types: image/jpeg, image/png, image/webp
--   - Max file size: 5MB (5242880 bytes)
-- =============================================================================

-- =============================================================================
-- Supabase Auth Configuration (applied via Supabase Dashboard or CLI)
-- =============================================================================
-- Provider: Email/Password (enabled)
-- Rate limiting: Enabled (Supabase built-in rate limiting on auth endpoints)
-- =============================================================================
