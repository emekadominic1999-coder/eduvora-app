import { createClient } from 'jsr:@supabase/supabase-js@2';

// Handles two callers on the same endpoint:
//   1. Paystack's own webhook (charge.success), authenticated by the
//      x-paystack-signature HMAC header — this is the source of truth.
//   2. The student's device, right after the checkout tab closes, asking
//      "did it go through yet" so the UI does not have to sit and wait for
//      the webhook to land. This path still re-checks with Paystack directly
//      rather than trusting the client's word for it.
// Either way, the entitlement is only ever written after Paystack's own
// verify endpoint confirms the charge succeeded for the expected amount.

const PLAN_ACCESS_DAYS: Record<string, number> = {
  single_paper: 200,
  semester_all: 130,
};

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type, x-paystack-signature',
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

  const rawBody = await request.text();
  const signature = request.headers.get('x-paystack-signature');
  const client = createClient(supabaseUrl, serviceKey);

  let reference: string | undefined;

  if (signature) {
    const expected = await hmacSha512Hex(paystackSecret, rawBody);
    if (expected !== signature) return json({ error: 'Bad signature.' }, 401);

    const event = JSON.parse(rawBody);
    if (event.event !== 'charge.success') return json({ received: true });
    reference = event.data?.reference;
  } else {
    const token = (request.headers.get('Authorization') ?? '').replace('Bearer ', '');
    if (!token) return json({ error: 'Sign in first.' }, 401);
    const { data: userData, error: userError } = await client.auth.getUser(token);
    if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);

    let body: { reference?: string };
    try {
      body = JSON.parse(rawBody);
    } catch {
      return json({ error: 'Bad request body.' }, 400);
    }
    reference = body.reference;
    if (!reference) return json({ error: 'No reference to verify.' }, 400);

    const { data: owned } = await client
      .from('cbt_payments')
      .select('user_id')
      .eq('reference', reference)
      .maybeSingle();
    if (!owned || owned.user_id !== userData.user.id) {
      return json({ error: 'That reference does not belong to you.' }, 403);
    }
  }

  if (!reference) return json({ error: 'No reference to verify.' }, 400);

  const { data: payment } = await client
    .from('cbt_payments')
    .select('*')
    .eq('reference', reference)
    .maybeSingle();
  if (!payment) return json({ error: 'Unknown payment reference.' }, 404);

  if (payment.status === 'success') {
    return json({ verified: true, alreadyProcessed: true });
  }

  const verifyResponse = await fetch(
    `https://api.paystack.co/transaction/verify/${encodeURIComponent(reference)}`,
    { headers: { Authorization: `Bearer ${paystackSecret}` } },
  );
  const verifyData = await verifyResponse.json();

  const paidOk =
    verifyResponse.ok &&
    verifyData.status &&
    verifyData.data?.status === 'success' &&
    verifyData.data?.amount === payment.amount_kobo &&
    verifyData.data?.currency === 'NGN';

  if (!paidOk) {
    if (verifyData.data?.status === 'failed') {
      await client.from('cbt_payments').update({ status: 'failed' }).eq('reference', reference);
    }
    return json({ verified: false });
  }

  await client
    .from('cbt_payments')
    .update({ status: 'success', verified_at: new Date().toISOString() })
    .eq('reference', reference);

  const accessDays = PLAN_ACCESS_DAYS[payment.plan] ?? 30;
  const expiresAt = new Date(Date.now() + accessDays * 24 * 60 * 60 * 1000).toISOString();

  const { error: entitlementError } = await client.from('cbt_entitlements').upsert(
    {
      user_id: payment.user_id,
      subject_id: payment.subject_id,
      plan: payment.plan,
      expires_at: expiresAt,
      payment_id: payment.id,
    },
    { onConflict: 'user_id,plan,subject_id' },
  );
  if (entitlementError) console.error('entitlement upsert failed', entitlementError);

  return json({ verified: true, expiresAt });
});

async function hmacSha512Hex(secret: string, body: string): Promise<string> {
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-512' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(body));
  return [...new Uint8Array(signature)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
