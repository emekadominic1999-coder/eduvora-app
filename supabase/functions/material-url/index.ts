import { createClient } from 'jsr:@supabase/supabase-js@2';

import { presignR2Url, readR2Config } from '../_shared/r2.ts';

// Called by the signed-in student's device to open a study material. Files in
// the private R2 bucket are stored as `r2://<key>`; for those this returns a
// 5-minute view link (inline, so it is displayed rather than downloaded).
// Older files that still live in Supabase Storage keep their normal URL and
// are returned unchanged.
const VIEW_LINK_SECONDS = 300;

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: CORS_HEADERS });
  if (request.method !== 'POST') return json({ error: 'POST only.' }, 405);

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!supabaseUrl || !serviceKey) {
    return json({ error: 'Function is missing its credentials.' }, 500);
  }

  const token = (request.headers.get('Authorization') ?? '').replace('Bearer ', '');
  if (!token) return json({ error: 'Sign in first.' }, 401);

  const client = createClient(supabaseUrl, serviceKey);
  if (token !== serviceKey) {
    const { data: userData, error: userError } = await client.auth.getUser(token);
    if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);
  }

  let body: { materialId?: string };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }
  const materialId = (body.materialId ?? '').trim();
  if (!materialId) return json({ error: 'materialId is required.' }, 400);

  const { data: material, error: lookupError } = await client
    .from('materials')
    .select('file_url')
    .eq('id', materialId)
    .maybeSingle();
  if (lookupError) {
    console.error('materials lookup failed', lookupError.message);
    return json({ error: 'Could not find that material.' }, 500);
  }
  const fileUrl: string = material?.file_url ?? '';
  if (!fileUrl) return json({ error: 'No file is attached to this material.' }, 404);

  if (!fileUrl.startsWith('r2://')) {
    // Old Supabase Storage file (or any normal web link): pass it straight on.
    return json({ url: fileUrl });
  }

  const r2 = readR2Config();
  if (!r2) return json({ error: 'Function is missing its credentials.' }, 500);

  const key = fileUrl.slice('r2://'.length);
  if (!key || key.includes('..')) return json({ error: 'Invalid file reference.' }, 400);

  try {
    const url = await presignR2Url(r2, {
      method: 'GET',
      key,
      expiresSeconds: VIEW_LINK_SECONDS,
      extraQuery: { 'response-content-disposition': 'inline' },
    });
    return json({ url });
  } catch (_error) {
    console.error('material-url: could not sign the view link');
    return json({ error: 'Could not open this material.' }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
