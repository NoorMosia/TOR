import { createClient } from '@supabase/supabase-js';

// Browser client — uses anon key, respects RLS
export const supabase = createClient(
  import.meta.env.PUBLIC_SUPABASE_URL,
  import.meta.env.PUBLIC_SUPABASE_ANON_KEY
);

// Server client — uses service role, bypasses RLS (server-side only)
export function getServiceClient() {
  return createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.SUPABASE_SERVICE_ROLE_KEY
  );
}
