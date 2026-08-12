import { createClient } from 'jsr:@supabase/supabase-js@2';

// Called by the signed-in student's device to start a checkout. Pricing is
// computed here, never trusted from the client — otherwise a tampered
// request could ask Paystack to charge one naira for full access.
const PLAN_PRICING_KOBO: Record<string, number> = {
  single_paper: 30000, // NGN 300
  semester_all: 120000, // NGN 1,200
};

const PLAN_ACCESS_DAYS: Record<string, number> = {
  single_paper: 200,
  semester_all: 130,
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

  let body: { plan?: string; subjectId?: string; subjectName?: string };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const plan = body.plan;
  if (plan !== 'single_paper' && plan !== 'semester_all') {
    return json({ error: 'Unknown plan.' }, 400);
  }

  const subjectId = plan === 'single_paper' ? (body.subjectId ?? '').trim() : '';
  if (plan === 'single_paper' && !subjectId) {
    return json({ error: 'subjectId is required for the single_paper plan.' }, 400);
  }

  const amountKobo = PLAN_PRICING_KOBO[plan];
  const reference = `edu_${crypto.randomUUID().replace(/-/g, '')}`;

  const { error: insertError } = await client.from('cbt_payments').insert({
    user_id: user.id,
    subject_id: subjectId,
    subject_name: body.subjectName ?? '',
    plan,
    amount_kobo: amountKobo,
    reference,
    status: 'pending',
  });
  if (insertError) {
    console.error('cbt_payments insert failed', insertError);
    return json({ error: 'Could not start checkout.' }, 500);
  }

  const paystackResponse = await fetch('https://api.paystack.co/transaction/initialize', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${paystackSecret}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      email: user.email,
      amount: amountKobo,
      currency: 'NGN',
      reference,
      channels: ['bank_transfer', 'ussd', 'card', 'mobile_money'],
      metadata: { user_id: user.id, plan, subject_id: subjectId },
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
    accessDays: PLAN_ACCESS_DAYS[plan],
  });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
