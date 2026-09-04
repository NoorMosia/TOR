import { defineMiddleware } from 'astro:middleware';
import { getUser } from './lib/auth';

// Pages that don't require authentication
const PUBLIC_PATHS = ['/login', '/api/send-otp', '/api/verify-otp', '/auth/callback'];

export const onRequest = defineMiddleware(async (context, next) => {
  const { pathname } = context.url;

  const isPublic = PUBLIC_PATHS.some(p => pathname === p || pathname.startsWith(p));

  if (!isPublic) {
    const accessToken  = context.cookies.get('sb-access-token')?.value;
    const refreshToken = context.cookies.get('sb-refresh-token')?.value;

    if (!accessToken || !refreshToken) {
      return context.redirect('/login');
    }

    // Attach user info to locals for use in layouts/pages
    const user = await getUser(context.cookies);
    (context.locals as any).user = user ?? { email: '' };
  }

  return next();
});
