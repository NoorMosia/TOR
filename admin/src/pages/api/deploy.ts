import type { APIRoute } from 'astro';
import { getUser } from '../../lib/auth';

/**
 * POST /api/deploy
 * Triggers a Vercel deploy hook to rebuild the public site.
 * Called after content saves when the user wants changes live immediately.
 */
export const POST: APIRoute = async ({ cookies, request }) => {
  // Auth check — must be logged in
  const user = await getUser(cookies);
  if (!user) {
    return new Response(JSON.stringify({ error: 'Unauthorized' }), {
      status: 401,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const hookUrl = import.meta.env.PUBLIC_DEPLOY_HOOK_URL;
  if (!hookUrl) {
    return new Response(JSON.stringify({ error: 'Deploy hook not configured' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  try {
    const res = await fetch(hookUrl, { method: 'POST' });
    if (!res.ok) {
      throw new Error(`Hook returned ${res.status}`);
    }
    return new Response(JSON.stringify({ ok: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message ?? 'Deploy failed' }), {
      status: 502,
      headers: { 'Content-Type': 'application/json' },
    });
  }
};
