import { createClient } from 'jsr:@supabase/supabase-js@2';

import { CORS_HEADERS, json } from '../_shared/tutors.ts';

// The student confirms a paid session actually took place. This is the only
// path that credits a tutor's balance, which is deliberate: money moves when
// the person who paid says they got what they paid for, not when a payment
// lands. A no-show therefore never turns into earnings on its own.
//
// A rating may be supplied in the same call. Doing both here keeps the
// tutor's running average in step with the reviews table -- there is no
// window where one has been written and the other has not.

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
  const user = userData.user;

  let body: { sessionId?: string; rating?: number; comment?: string };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const sessionId = (body.sessionId ?? '').trim();
  if (!sessionId) return json({ error: 'No session to confirm.' }, 400);

  const { data: session } = await client
    .from('tutor_sessions')
    .select('*')
    .eq('id', sessionId)
    .maybeSingle();
  if (!session) return json({ error: 'Unknown session.' }, 404);
  if (session.student_id !== user.id) {
    return json({ error: 'That session is not yours to confirm.' }, 403);
  }
  if (session.status === 'completed') {
    return json({ completed: true, alreadyProcessed: true });
  }
  if (session.status !== 'paid') {
    return json({ error: 'Only a paid session can be confirmed.' }, 409);
  }

  const { error: sessionError } = await client
    .from('tutor_sessions')
    .update({ status: 'completed', completed_at: new Date().toISOString() })
    .eq('id', sessionId);
  if (sessionError) {
    console.error('session completion failed', sessionError);
    return json({ error: 'Could not confirm the session.' }, 500);
  }

  const { data: tutor } = await client
    .from('tutors')
    .select('balance_kobo, lifetime_earned_kobo, sessions_completed, rating_sum, rating_count')
    .eq('id', session.tutor_id)
    .maybeSingle();
  if (!tutor) return json({ error: 'Unknown tutor.' }, 404);

  const rating = Math.round(body.rating ?? 0);
  const hasRating = rating >= 1 && rating <= 5;

  if (hasRating) {
    const { error: reviewError } = await client.from('tutor_reviews').upsert(
      {
        session_id: sessionId,
        tutor_id: session.tutor_id,
        student_id: user.id,
        rating,
        comment: (body.comment ?? '').trim(),
      },
      { onConflict: 'session_id' },
    );
    if (reviewError) console.error('review insert failed', reviewError);
  }

  const { error: tutorError } = await client
    .from('tutors')
    .update({
      balance_kobo: tutor.balance_kobo + session.tutor_earnings_kobo,
      lifetime_earned_kobo: tutor.lifetime_earned_kobo + session.tutor_earnings_kobo,
      sessions_completed: tutor.sessions_completed + 1,
      rating_sum: tutor.rating_sum + (hasRating ? rating : 0),
      rating_count: tutor.rating_count + (hasRating ? 1 : 0),
    })
    .eq('id', session.tutor_id);
  if (tutorError) {
    console.error('tutor balance update failed', tutorError);
    return json({ error: 'Session confirmed, but crediting the tutor failed.' }, 500);
  }

  return json({ completed: true, creditedKobo: session.tutor_earnings_kobo });
});
