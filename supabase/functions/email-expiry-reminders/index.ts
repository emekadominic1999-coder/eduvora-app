import { createClient } from 'jsr:@supabase/supabase-js@2';

import { expiryEmail, sendEmail } from '../_shared/email.ts';

// Run once a day by a Supabase scheduled job (see supabase/EMAIL.sql notes in
// the README of this change). Finds students whose paid access ends in the
// next 2 to 4 days and sends one reminder each. Running it twice is harmless:
// the same reminder is never sent twice.
//
// Protected by a secret header so the public cannot trigger it:
//   x-cron-secret: <the value of the EMAIL_CRON_SECRET secret>

Deno.serve(async (request: Request) => {
  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  const cronSecret = Deno.env.get('EMAIL_CRON_SECRET');
  if (!supabaseUrl || !serviceKey || !cronSecret) return new Response('Missing credentials', { status: 500 });
  if (request.headers.get('x-cron-secret') !== cronSecret) return new Response('Forbidden', { status: 403 });

  const client = createClient(supabaseUrl, serviceKey);
  const now = Date.now();
  const from = new Date(now + 2 * 86400000).toISOString();
  const to = new Date(now + 4 * 86400000).toISOString();

  const { data: ents, error } = await client
    .from('cbt_entitlements')
    .select('user_id, subject_id, expires_at')
    .gte('expires_at', from)
    .lte('expires_at', to)
    .limit(5000);
  if (error) return new Response(JSON.stringify({ error: error.message }), { status: 500 });

  // One reminder per student, for the earliest date that is ending.
  const byUser = new Map<string, { expiresAt: string; subjects: string[] }>();
  for (const e of ents ?? []) {
    const cur = byUser.get(e.user_id);
    if (!cur) byUser.set(e.user_id, { expiresAt: e.expires_at, subjects: [e.subject_id] });
    else {
      cur.subjects.push(e.subject_id);
      if (e.expires_at < cur.expiresAt) cur.expiresAt = e.expires_at;
    }
  }

  let sent = 0;
  for (const [userId, info] of byUser) {
    const { data: u } = await client.auth.admin.getUserById(userId);
    const email = u?.user?.email;
    if (!email) continue;
    const { data: names } = await client
      .from('cbt_questions')
      .select('subject_id, subject_name')
      .in('subject_id', info.subjects.slice(0, 40))
      .limit(400);
    const nameBySubject = new Map<string, string>();
    for (const n of names ?? []) nameBySubject.set(n.subject_id, n.subject_name);
    const papers = [...new Set(info.subjects.map((s) => nameBySubject.get(s) ?? s))];
    const { data: profile } = await client.from('profiles').select('full_name').eq('id', userId).maybeSingle();
    const mail = expiryEmail({ name: profile?.full_name ?? '', expiresAt: info.expiresAt, papers });
    const result = await sendEmail(client, {
      to: email, kind: 'expiry', ref: `${userId}:${info.expiresAt.slice(0, 10)}`, userId, ...mail,
    });
    if (result.sent) sent++;
  }
  return new Response(JSON.stringify({ students: byUser.size, sent }), {
    headers: { 'Content-Type': 'application/json' },
  });
});
