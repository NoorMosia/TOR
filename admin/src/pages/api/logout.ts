import type { APIRoute } from 'astro';
import { clearSessionCookies } from '../../lib/auth';

export const GET: APIRoute = ({ cookies, redirect }) => {
  clearSessionCookies(cookies);
  return redirect('/login');
};
