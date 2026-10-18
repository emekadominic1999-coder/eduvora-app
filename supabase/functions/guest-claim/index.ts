import { createClient } from 'jsr:@supabase/supabase-js@2';

import { formatCode, settleGuestOrder } from '../_shared/guest.ts';

// The buy page calls this after Paystack sends the visitor back with their
// reference. It re-checks the payment with Paystack itself, then returns the
// one-time access code. Calling it again just returns the same code.
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

  let body: { reference?: string };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }
  const reference = (body.reference ?? '').trim();
  if (!/^edg_[a-f0-9]{32}$/.test(reference)) return json({ error: 'That reference is not valid.' }, 400);

  const client = createClient(supabaseUrl, serviceKey);
  const result = await settleGuestOrder(client, paystackSecret, reference);
  if (!result.found) return json({ error: 'We could not find that payment.' }, 404);
  if (!result.paid || !result.code) return json({ paid: false });
  return json({ paid: true, code: formatCode(result.code) });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}
