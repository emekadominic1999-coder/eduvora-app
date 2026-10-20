import { createClient } from 'jsr:@supabase/supabase-js@2';

import { broadcastEmail, OWNER_EMAILS, sendEmail, welcomeEmail } from '../_shared/email.ts';

// Called from the app. Two jobs:
//   { type: 'welcome' }
//       Any signed-in student. Sends the welcome email to THEIR OWN address,
//       once. Calling it again does nothing.
//   { type: 'broadcast', subject, message, audience, preview? }
//       Owner only. Sends a message the owner wrote to a group of students.
//       audience: 'all' | 'paid' | 'unpaid'. With preview: true nothing is
//       sent; the reply says how many people it would reach.

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

// One call never sends more than this, so a slip cannot mail everyone twice
// over or burn through the provider's daily limit.
const MAX_RECIPIENTS = 500;

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: CORS_HEADERS });
  if (request.method !== 'POST') return json({ error: 'POST only.' }, 405);

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!supabaseUrl || !serviceKey) return json({ error: 'Function is missing its credentials.' }, 500);

  const token = (request.headers.get('Authorization') ?? '').replace('Bearer ', '');
  if (!token) return json({ error: 'Sign in first.' }, 401);
  const client = createClient(supabaseUrl, serviceKey);
  const { data: userData, error: userError } = await client.auth.getUser(token);
  if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);
  const user = userData.user;
  const email = (user.email ?? '').toLowerCase();

  let body: { type?: string; subject?: string; message?: string; audience?: string; preview?: boolean };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  if (body.type === 'welcome') {
    if (!email) return json({ sent: false, reason: 'no email' });
    const { data: profile } = await client.from('profiles').select('full_name').eq('id', user.id).maybeSingle();
    const mail = welcomeEmail(profile?.full_name ?? user.user_metadata?.full_name ?? '');
    const result = await sendEmail(client, { to: email, kind: 'welcome', ref: user.id, userId: user.id, ...mail });
    return json(result);
  }

  if (body.type === 'broadcast') {
    if (!OWNER_EMAILS.includes(email)) return json({ error: 'Only the owner can send messages.' }, 403);
    const subject = (body.subject ?? '').trim();
    const message = (body.message ?? '').trim();
    const audience = body.audience ?? 'all';
    if (!['me', 'all', 'paid', 'unpaid'].includes(audience)) return json({ error: 'Unknown audience.' }, 400);
    if (!body.preview && (subject.length < 3 || message.length < 10)) {
      return json({ error: 'Write a subject and a message first.' }, 400);
    }

    const recipients = audience === 'me'
      ? [{ id: user.id, email }]
      : await audienceEmails(client, audience);
    if (body.preview) return json({ preview: true, count: recipients.length });
    if (recipients.length > MAX_RECIPIENTS) {
      return json({ error: `That audience is ${recipients.length} people. One send is limited to ${MAX_RECIPIENTS}.` }, 400);
    }

    const batchId = crypto.randomUUID();
    let sent = 0;
    let skipped = 0;
    let failed = 0;
    for (let i = 0; i < recipients.length; i += 10) {
      const chunk = recipients.slice(i, i + 10);
      const results = await Promise.all(chunk.map(async (r) => {
        const mail = await broadcastEmail({ subject, message, to: r.email });
        return sendEmail(client, {
          to: r.email, kind: 'broadcast', ref: `${batchId}:${r.email}`, userId: r.id, marketing: true, ...mail,
        });
      }));
      for (const r of results) {
        if (r.sent) sent++;
        else if (r.reason === 'unsubscribed' || r.reason === 'already sent') skipped++;
        else failed++;
      }
    }
    return json({ sent, skipped, failed, total: recipients.length });
  }

  return json({ error: 'Unknown type.' }, 400);
});

/// Everyone with an email address, or only those with (or without) a paid
/// paper that has not expired.
async function audienceEmails(
  // deno-lint-ignore no-explicit-any
  client: any,
  audience: string,
): Promise<{ id: string; email: string }[]> {
  const people = new Map<string, string>();
  for (let page = 1; page <= 50; page++) {
    const { data, error } = await client.auth.admin.listUsers({ page, perPage: 200 });
    if (error || !data?.users?.length) break;
    for (const u of data.users) if (u.email) people.set(u.id, u.email.toLowerCase());
    if (data.users.length < 200) break;
  }
  if (audience === 'all') return [...people].map(([id, email]) => ({ id, email }));

  const { data: ents } = await client
    .from('cbt_entitlements')
    .select('user_id')
    .gt('expires_at', new Date().toISOString())
    .limit(10000);
  const paid = new Set<string>((ents ?? []).map((e: { user_id: string }) => e.user_id));
  return [...people]
    .filter(([id]) => (audience === 'paid' ? paid.has(id) : !paid.has(id)))
    .map(([id, email]) => ({ id, email }));
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
