import { createClient } from 'jsr:@supabase/supabase-js@2';

import { CORS_HEADERS, json, priceSession } from '../_shared/tutors.ts';

// Prices an accepted session and opens a Paystack checkout for it.
//
// The price is computed here from the tutor's own listed rate and the
// session's duration -- the client sends only a session id, so it cannot
// talk Eduvora into charging less (or paying a tutor more) than the listing
// says. The split between Eduvora's commission and the tutor's earnings is
// written at the same time, so a later payout can never be recomputed
// against a rate the tutor changed in the meantime.

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

  let body: { sessionId?: string };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const sessionId = (body.sessionId ?? '').trim();
  if (!sessionId) return json({ error: 'No session to pay for.' }, 400);

  const { data: session } = await client
    .from('tutor_sessions')
    .select('*')
    .eq('id', sessionId)
    .maybeSingle();
  if (!session) return json({ error: 'Unknown session.' }, 404);
  if (session.student_id !== user.id) {
    return json({ error: 'That session is not yours.' }, 403);
  }
  if (session.status === 'paid' || session.status === 'completed') {
    return json({ error: 'This session is already paid for.' }, 409);
  }
  if (session.status !== 'accepted') {
    return json({ error: 'The tutor has not accepted this session yet.' }, 409);
  }

  // Price from the tutor's current listing for this exact subject.
  const { data: listing } = await client
    .from('tutor_courses')
    .select('hourly_rate_kobo')
    .eq('tutor_id', session.tutor_id)
    .eq('subject_id', session.subject_id)
    .maybeSingle();
  if (!listing) {
    return json({ error: 'This tutor no longer teaches that course.' }, 409);
  }

  const pricing = priceSession(listing.hourly_rate_kobo, session.duration_minutes);
  const reference = `edut_${crypto.randomUUID().replace(/-/g, '')}`;

  const { error: updateError } = await client
    .from('tutor_sessions')
    .update({
      amount_kobo: pricing.amountKobo,
      platform_fee_kobo: pricing.platformFeeKobo,
      tutor_earnings_kobo: pricing.tutorEarningsKobo,
      reference,
    })
    .eq('id', sessionId);
  if (updateError) {
    console.error('session pricing update failed', updateError);
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
      amount: pricing.amountKobo,
      currency: 'NGN',
      reference,
      channels: ['bank_transfer', 'ussd', 'card', 'mobile_money'],
      metadata: {
        kind: 'tutor_session',
        session_id: sessionId,
        tutor_id: session.tutor_id,
        subject_id: session.subject_id,
      },
    }),
  });
  const paystackData = await paystackResponse.json();

  if (!paystackResponse.ok || !paystackData.status) {
    console.error('paystack initialize failed', paystackData);
    return json(
      { error: paystackData.message ?? 'Paystack could not start this payment.' },
      502,
    );
  }

  return json({
    authorizationUrl: paystackData.data.authorization_url,
    reference,
    amountKobo: pricing.amountKobo,
  });
});
