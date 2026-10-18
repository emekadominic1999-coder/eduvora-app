import { createClient } from 'jsr:@supabase/supabase-js@2';

import {
  COURSE_PACK_ACCESS_DAYS,
  COURSE_PACK_KOBO,
  MAX_COURSE_PACK_UNITS,
  SINGLE_PAPER_ACCESS_DAYS,
  SINGLE_PAPER_KOBO,
} from '../_shared/guest.ts';

// Starts a Paystack checkout for a visitor who is NOT signed in. Price and the
// 23-unit cap are worked out here from the database, never from the browser.
const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};
const SITE = 'https://eduvoraapp.com.ng';

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: CORS_HEADERS });
  if (request.method !== 'POST') return json({ error: 'POST only.' }, 405);

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  const paystackSecret = Deno.env.get('PAYSTACK_SECRET_KEY');
  if (!supabaseUrl || !serviceKey || !paystackSecret) {
    return json({ error: 'Function is missing its credentials.' }, 500);
  }

  let body: { email?: string; subjectIds?: string[] };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const email = (body.email ?? '').trim().toLowerCase();
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email) || email.length > 120) {
    return json({ error: 'Enter a valid email address.' }, 400);
  }
  const subjectIds = Array.from(
    new Set((body.subjectIds ?? []).map((id) => String(id).trim()).filter(Boolean)),
  );
  if (subjectIds.length === 0) return json({ error: 'Pick at least one course.' }, 400);
  if (subjectIds.length > 40) return json({ error: 'Too many courses selected.' }, 400);

  const client = createClient(supabaseUrl, serviceKey);

  const { data: rows, error: lookupError } = await client
    .from('cbt_subject_summaries')
    .select('subject_id, units')
    .in('subject_id', subjectIds);
  if (lookupError) {
    console.error('summary lookup failed', lookupError);
    return json({ error: 'Could not verify the courses you chose.' }, 500);
  }
  const units = new Map<string, number>();
  for (const r of rows ?? []) units.set(r.subject_id, r.units ?? 0);
  const missing = subjectIds.filter((id) => !units.has(id));
  if (missing.length > 0) return json({ error: 'One of the courses you chose is not available.' }, 400);

  const totalUnits = subjectIds.reduce((s, id) => s + (units.get(id) ?? 0), 0);
  if (totalUnits > MAX_COURSE_PACK_UNITS) {
    return json({ error: `That is ${totalUnits} units; a pack cannot exceed ${MAX_COURSE_PACK_UNITS}.` }, 400);
  }

  const plan = subjectIds.length === 1 ? 'single_paper' : 'course_pack';
  const amountKobo = plan === 'single_paper' ? SINGLE_PAPER_KOBO : COURSE_PACK_KOBO;
  const accessDays = plan === 'single_paper' ? SINGLE_PAPER_ACCESS_DAYS : COURSE_PACK_ACCESS_DAYS;
  const reference = `edg_${crypto.randomUUID().replace(/-/g, '')}`;

  const { error: insertError } = await client.from('guest_orders').insert({
    reference,
    email,
    plan,
    subject_ids: subjectIds,
    amount_kobo: amountKobo,
    access_days: accessDays,
    status: 'pending',
  });
  if (insertError) {
    console.error('guest_orders insert failed', insertError);
    return json({ error: 'Could not start checkout.' }, 500);
  }

  const paystackResponse = await fetch('https://api.paystack.co/transaction/initialize', {
    method: 'POST',
    headers: { Authorization: `Bearer ${paystackSecret}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      email,
      amount: amountKobo,
      currency: 'NGN',
      reference,
      callback_url: `${SITE}/buy.html?ref=${reference}`,
      channels: ['bank_transfer', 'ussd', 'card', 'mobile_money'],
      metadata: { guest: true, plan, subject_ids: subjectIds },
    }),
  });
  const paystackData = await paystackResponse.json();
  if (!paystackResponse.ok || !paystackData.status) {
    console.error('paystack initialize failed', paystackData);
    await client.from('guest_orders').update({ status: 'failed' }).eq('reference', reference);
    return json({ error: paystackData.message ?? 'Paystack could not start this payment.' }, 502);
  }

  return json({
    authorizationUrl: paystackData.data.authorization_url,
    reference,
    amountKobo,
    accessDays,
  });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
