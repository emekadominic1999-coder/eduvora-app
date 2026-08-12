import { createClient } from 'jsr:@supabase/supabase-js@2';

// Called by the signed-in student's device to start a checkout. Pricing is
// computed here, never trusted from the client — otherwise a tampered
// request could ask Paystack to charge one naira for full access.
const SINGLE_PAPER_KOBO = 30000; // NGN 300
const COURSE_PACK_KOBO = 120000; // NGN 1,200 flat, regardless of how many papers

const SINGLE_PAPER_ACCESS_DAYS = 200;
const COURSE_PACK_ACCESS_DAYS = 130;

// The real course-registration cap — a course pack can never add up to more
// than a single semester's worth of units, so it stays a genuine "this
// semester" purchase rather than a way to buy the whole catalogue cheaply.
const MAX_COURSE_PACK_UNITS = 23;

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
  const paystackSecret = Deno.env.get('PAYSTACK_SECRET_KEY');
  if (!supabaseUrl || !serviceKey || !paystackSecret) {
    return json({ error: 'Function is missing its credentials.' }, 500);
  }

  const token = (request.headers.get('Authorization') ?? '').replace('Bearer ', '');
  if (!token) return json({ error: 'Sign in first.' }, 401);

  const client = createClient(supabaseUrl, serviceKey);
  const { data: userData, error: userError } = await client.auth.getUser(token);
  if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);
  const user = userData.user;

  let body: {
    plan?: string;
    subjectId?: string;
    subjectName?: string;
    subjectIds?: string[];
    department?: string;
    level?: string;
    semester?: string;
  };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const plan = body.plan;
  if (plan !== 'single_paper' && plan !== 'course_pack') {
    return json({ error: 'Unknown plan.' }, 400);
  }

  const reference = `edu_${crypto.randomUUID().replace(/-/g, '')}`;

  if (plan === 'single_paper') {
    const subjectId = (body.subjectId ?? '').trim();
    if (!subjectId) {
      return json({ error: 'subjectId is required for the single_paper plan.' }, 400);
    }

    const { error: insertError } = await client.from('cbt_payments').insert({
      user_id: user.id,
      subject_id: subjectId,
      subject_name: body.subjectName ?? '',
      plan,
      amount_kobo: SINGLE_PAPER_KOBO,
      reference,
      status: 'pending',
    });
    if (insertError) {
      console.error('cbt_payments insert failed', insertError);
      return json({ error: 'Could not start checkout.' }, 500);
    }

    return startPaystackCheckout({
      paystackSecret,
      client,
      reference,
      amountKobo: SINGLE_PAPER_KOBO,
      email: user.email!,
      metadata: { user_id: user.id, plan, subject_id: subjectId },
      accessDays: SINGLE_PAPER_ACCESS_DAYS,
    });
  }

  // course_pack: the student picked their own set of papers, up to the
  // real course-load cap, from whatever actually exists for their chosen
  // department/level/semester. Every number here is re-derived from the
  // database, never taken from the client's word for it.
  const subjectIds = Array.from(
    new Set((body.subjectIds ?? []).map((id) => id.trim()).filter(Boolean)),
  );
  if (subjectIds.length === 0) {
    return json({ error: 'Pick at least one paper to unlock.' }, 400);
  }

  const { data: chosenSubjects, error: subjectsError } = await client
    .from('cbt_questions')
    .select('subject_id, units')
    .in('subject_id', subjectIds);
  if (subjectsError) {
    console.error('cbt_questions lookup failed', subjectsError);
    return json({ error: 'Could not verify the papers you chose.' }, 500);
  }

  const unitsBySubject = new Map<string, number>();
  for (const row of chosenSubjects ?? []) {
    unitsBySubject.set(row.subject_id, row.units ?? 0);
  }
  const missing = subjectIds.filter((id) => !unitsBySubject.has(id));
  if (missing.length > 0) {
    return json({ error: `Unknown paper(s): ${missing.join(', ')}.` }, 400);
  }

  const totalUnits = subjectIds.reduce((sum, id) => sum + (unitsBySubject.get(id) ?? 0), 0);
  if (totalUnits > MAX_COURSE_PACK_UNITS) {
    return json(
      { error: `That's ${totalUnits} units — a course pack can't exceed ${MAX_COURSE_PACK_UNITS}.` },
      400,
    );
  }

  const { error: insertError } = await client.from('cbt_payments').insert({
    user_id: user.id,
    subject_ids: subjectIds,
    department: (body.department ?? '').trim(),
    level: (body.level ?? '').trim(),
    semester: (body.semester ?? '').trim(),
    plan,
    amount_kobo: COURSE_PACK_KOBO,
    reference,
    status: 'pending',
  });
  if (insertError) {
    console.error('cbt_payments insert failed', insertError);
    return json({ error: 'Could not start checkout.' }, 500);
  }

  return startPaystackCheckout({
    paystackSecret,
    client,
    reference,
    amountKobo: COURSE_PACK_KOBO,
    email: user.email!,
    metadata: { user_id: user.id, plan, subject_ids: subjectIds, total_units: totalUnits },
    accessDays: COURSE_PACK_ACCESS_DAYS,
  });
});

async function startPaystackCheckout(options: {
  paystackSecret: string;
  // deno-lint-ignore no-explicit-any
  client: any;
  reference: string;
  amountKobo: number;
  email: string;
  metadata: Record<string, unknown>;
  accessDays: number;
}): Promise<Response> {
  const { paystackSecret, client, reference, amountKobo, email, metadata, accessDays } = options;

  const paystackResponse = await fetch('https://api.paystack.co/transaction/initialize', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${paystackSecret}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      email,
      amount: amountKobo,
      currency: 'NGN',
      reference,
      channels: ['bank_transfer', 'ussd', 'card', 'mobile_money'],
      metadata,
    }),
  });
  const paystackData = await paystackResponse.json();

  if (!paystackResponse.ok || !paystackData.status) {
    console.error('paystack initialize failed', paystackData);
    await client.from('cbt_payments').update({ status: 'failed' }).eq('reference', reference);
    return json({ error: paystackData.message ?? 'Paystack could not start this payment.' }, 502);
  }

  return json({
    authorizationUrl: paystackData.data.authorization_url,
    reference,
    amountKobo,
    accessDays,
  });
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
