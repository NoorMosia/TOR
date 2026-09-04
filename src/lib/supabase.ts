import { createClient } from '@supabase/supabase-js';

// Public read-only client (anon key, respects RLS public read policies)
export const supabase = createClient(
  import.meta.env.PUBLIC_SUPABASE_URL,
  import.meta.env.PUBLIC_SUPABASE_ANON_KEY
);
