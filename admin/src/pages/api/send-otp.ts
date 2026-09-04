import type { APIRoute } from 'astro';
import { createClient } from '@supabase/supabase-js';

export const POST: APIRoute = async ({ request, redirect }) => {
  const form = await request.formData();
  const email = (form.get('email') as string ?? '').trim().toLowerCase();

  if (!email) {
    return redirect(`/login?error=${encodeURIComponent('Please enter your email address.')}`);
  }

  const supabase = createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY
  );

  const { error } = await supabase.auth.signInWithOtp({
    email,
    options: { shouldCreateUser: false },
  });

  if (error) {
    return redirect(`/login?error=${encodeURIComponent(error.message)}&email=${encodeURIComponent(email)}`);
  }

  return redirect(`/login?step=otp&email=${encodeURIComponent(email)}`);
};
