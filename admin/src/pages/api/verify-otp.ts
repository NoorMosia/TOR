import type { APIRoute } from 'astro';
import { createClient } from '@supabase/supabase-js';
import { setSessionCookies } from '../../lib/auth';

export const POST: APIRoute = async ({ request, cookies, redirect }) => {
  const form = await request.formData();
  const email = (form.get('email') as string ?? '').trim().toLowerCase();
  const token = (form.get('token') as string ?? '').trim();

  if (!email || !token) {
    return redirect('/login?error=missing_fields');
  }

  const supabase = createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY
  );

  // Try OTP type first, fall back to magiclink
  let result = await supabase.auth.verifyOtp({ email, token, type: 'email' });

  if (result.error) {
    result = await supabase.auth.verifyOtp({ email, token, type: 'magiclink' });
  }

  if (result.error || !result.data.session) {
    const msg = encodeURIComponent(result.error?.message ?? 'Invalid or expired code.');
    return redirect(`/login?step=otp&email=${encodeURIComponent(email)}&error=${msg}`);
  }

  setSessionCookies(cookies, result.data.session);
  return redirect('/dashboard');
};
