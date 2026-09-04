import type { AstroCookies } from 'astro';
import { createClient } from '@supabase/supabase-js';

/**
 * Builds a Supabase client that reads/writes the session from Astro cookies.
 * Use this in .astro server frontmatter for auth-protected pages.
 */
export function getSessionClient(cookies: AstroCookies) {
  const supabase = createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY,
    {
      auth: {
        detectSessionInUrl: false,
        persistSession: false,
      },
    }
  );

  const accessToken  = cookies.get('sb-access-token')?.value;
  const refreshToken = cookies.get('sb-refresh-token')?.value;

  if (accessToken && refreshToken) {
    supabase.auth.setSession({ access_token: accessToken, refresh_token: refreshToken });
  }

  return supabase;
}

/**
 * Checks if the current request is authenticated.
 * Returns the user or null.
 */
export async function getUser(cookies: AstroCookies) {
  const client = getSessionClient(cookies);
  const { data } = await client.auth.getUser();
  return data.user ?? null;
}

/**
 * Sets session cookies from a Supabase session object.
 */
export function setSessionCookies(
  cookies: AstroCookies,
  session: { access_token: string; refresh_token: string }
) {
  const isProd = import.meta.env.PROD;
  const opts = {
    path: '/',
    httpOnly: true,
    secure: isProd,   // false on localhost (HTTP), true in production (HTTPS)
    sameSite: 'lax' as const,
    maxAge: 60 * 60 * 24 * 7, // 7 days
  };
  cookies.set('sb-access-token',  session.access_token,  opts);
  cookies.set('sb-refresh-token', session.refresh_token, opts);
}

/**
 * Clears session cookies (logout).
 */
export function clearSessionCookies(cookies: AstroCookies) {
  cookies.delete('sb-access-token',  { path: '/' });
  cookies.delete('sb-refresh-token', { path: '/' });
}
