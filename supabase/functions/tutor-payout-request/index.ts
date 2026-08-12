import { createClient } from 'jsr:@supabase/supabase-js@2';

import { CORS_HEADERS, json, MIN_PAYOUT_KOBO } from '../_shared/tutors.ts';

// A tutor asks to withdraw their balance. The balance is debited here and a
// row lands in tutor_payouts for the Eduvora operator to pay by bank
// transfer and mark sent.
//
// Debiting at request time (rather than when the transfer is actually made)
// is what stops the same naira being requested twice while the first
// withdrawal is still sitting in the queue. If a payout is ever rejected,
// the operator credits the balance back when they mark it so.

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
  const { data: userData, error: userError } = await client.auth.getUser(token);
  if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);

  let body: {
    amountKobo?: number;
    bankName?: string;
    accountNumber?: string;
    accountName?: string;
  };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const bankName = (body.bankName ?? '').trim();
  const accountNumber = (body.accountNumber ?? '').trim();
  const accountName = (body.accountName ?? '').trim();
  if (!bankName || !accountNumber || !accountName) {
    return json({ error: 'Enter the account to pay into.' }, 400);
  }
  if (!/^\d{10}$/.test(accountNumber)) {
    return json({ error: 'A Nigerian account number is 10 digits.' }, 400);
  }

  const { data: tutor } = await client
    .from('tutors')
    .select('id, balance_kobo')
    .eq('user_id', userData.user.id)
    .maybeSingle();
  if (!tutor) return json({ error: 'You do not have a tutor profile.' }, 404);

  const amountKobo = Math.round(body.amountKobo ?? 0);
  if (amountKobo < MIN_PAYOUT_KOBO) {
    return json(
      { error: `The smallest withdrawal is ₦${MIN_PAYOUT_KOBO / 100}.` },
      400,
    );
  }
  if (amountKobo > tutor.balance_kobo) {
    return json(
      { error: `You only have ₦${(tutor.balance_kobo / 100).toFixed(0)} available.` },
      400,
    );
  }

  const { error: payoutError } = await client.from('tutor_payouts').insert({
    tutor_id: tutor.id,
    amount_kobo: amountKobo,
    bank_name: bankName,
    account_number: accountNumber,
    account_name: accountName,
    status: 'requested',
  });
  if (payoutError) {
    console.error('payout insert failed', payoutError);
    return json({ error: 'Could not request the withdrawal.' }, 500);
  }

  const { error: balanceError } = await client
    .from('tutors')
    .update({ balance_kobo: tutor.balance_kobo - amountKobo })
    .eq('id', tutor.id);
  if (balanceError) {
    console.error('balance debit failed', balanceError);
    return json({ error: 'Could not update your balance.' }, 500);
  }

  return json({ requested: true, remainingKobo: tutor.balance_kobo - amountKobo });
});
