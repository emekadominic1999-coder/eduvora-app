import { createClient } from 'jsr:@supabase/supabase-js@2';

import { presignR2Url, readR2Config } from '../_shared/r2.ts';

// Called by the signed-in student's device before uploading a study material.
// It hands back a short-lived presigned PUT link into the PRIVATE R2 bucket,
// so the file goes straight to R2 and no storage key ever reaches the app.
// Size and file type are enforced here, never trusted from the client alone.
const MAX_SIZE_BYTES = 60 * 1024 * 1024; // 60 MB
const UPLOAD_LINK_SECONDS = 600; // 10 minutes

const ALLOWED_TYPES: Record<string, string[]> = {
  pdf: ['application/pdf'],
  jpg: ['image/jpeg'],
  jpeg: ['image/jpeg'],
  png: ['image/png'],
  docx: ['application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
  pptx: ['application/vnd.openxmlformats-officedocument.presentationml.presentation'],
  xlsx: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'],
};

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
  const r2 = readR2Config();
  if (!supabaseUrl || !serviceKey || !r2) {
    return json({ error: 'Function is missing its credentials.' }, 500);
  }

  const token = (request.headers.get('Authorization') ?? '').replace('Bearer ', '');
  if (!token) return json({ error: 'Sign in first.' }, 401);

  // The project's own master key (held only by the owner) may upload on the
  // platform's behalf -- used for bulk-loading Eduvora's official materials.
  let uploaderId: string;
  if (token === serviceKey) {
    uploaderId = 'eduvora-shared';
  } else {
    const client = createClient(supabaseUrl, serviceKey);
    const { data: userData, error: userError } = await client.auth.getUser(token);
    if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);
    uploaderId = userData.user.id;
  }

  let body: { fileName?: string; contentType?: string; size?: number };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const fileName = (body.fileName ?? '').trim();
  const contentType = (body.contentType ?? '').trim().toLowerCase();
  const size = Number(body.size);

  if (!fileName) return json({ error: 'fileName is required.' }, 400);
  if (!Number.isFinite(size) || size <= 0) return json({ error: 'size is required.' }, 400);
  if (size > MAX_SIZE_BYTES) {
    return json({ error: 'That file is larger than the 60 MB limit.' }, 413);
  }

  const dot = fileName.lastIndexOf('.');
  const extension = dot === -1 ? '' : fileName.slice(dot + 1).toLowerCase();
  const allowedContentTypes = ALLOWED_TYPES[extension];
  if (!allowedContentTypes || !allowedContentTypes.includes(contentType)) {
    return json({ error: 'Only PDF, JPG, PNG, DOCX, PPTX and XLSX files can be uploaded.' }, 400);
  }

  // Keep the key boring: letters, digits, dot, dash, underscore only.
  const safeName = fileName.replace(/[^A-Za-z0-9._-]+/g, '_').replace(/^\.+/, '').slice(-100);
  const key = `${uploaderId}/${crypto.randomUUID()}-${safeName || `file.${extension}`}`;

  try {
    const uploadUrl = await presignR2Url(r2, {
      method: 'PUT',
      key,
      expiresSeconds: UPLOAD_LINK_SECONDS,
      signedContentType: contentType,
    });
    return json({ key, uploadUrl });
  } catch (_error) {
    console.error('material-upload-url: could not sign the upload link');
    return json({ error: 'Could not prepare the upload.' }, 500);
  }
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
