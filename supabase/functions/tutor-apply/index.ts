import { createClient } from 'jsr:@supabase/supabase-js@2';

import {
  bestCbtScore,
  CORS_HEADERS,
  json,
  MAX_HOURLY_RATE_KOBO,
  MIN_HOURLY_RATE_KOBO,
  TUTOR_MIN_SCORE,
} from '../_shared/tutors.ts';

// Turns a student into a listed tutor. The whole point of this function is
// that it re-derives every claim from the database: a tutor may only list a
// course they have actually sat the CBT paper for and scored at or above
// TUTOR_MIN_SCORE on. That check is what makes the "Verified · 84%" badge on
// a profile mean something, so it can never move to the client.
//
// Passing the check approves the tutor outright -- the score *is* the
// review. The operator can still suspend a profile afterwards.

interface CourseRequest {
  subjectId?: string;
  subjectName?: string;
  hourlyRateKobo?: number;
}

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

  let body: { headline?: string; bio?: string; courses?: CourseRequest[] };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const courses = body.courses ?? [];
  if (courses.length === 0) {
    return json({ error: 'Choose at least one course to teach.' }, 400);
  }

  // Verify every course before writing anything, so a part-valid
  // application never leaves a half-built profile behind.
  const verified: {
    subjectId: string;
    subjectName: string;
    score: number;
    hourlyRateKobo: number;
  }[] = [];

  for (const course of courses) {
    const subjectId = (course.subjectId ?? '').trim();
    if (!subjectId) return json({ error: 'A course is missing its subject.' }, 400);

    const rate = Math.round(course.hourlyRateKobo ?? 0);
    if (rate < MIN_HOURLY_RATE_KOBO || rate > MAX_HOURLY_RATE_KOBO) {
      return json(
        {
          error:
            `Set an hourly rate between ₦${MIN_HOURLY_RATE_KOBO / 100} and ` +
            `₦${MAX_HOURLY_RATE_KOBO / 100}.`,
        },
        400,
      );
    }

    const score = await bestCbtScore(client, user.id, subjectId);
    if (score < TUTOR_MIN_SCORE) {
      const name = (course.subjectName ?? '').trim() || subjectId;
      return json(
        {
          error: score === 0
            ? `Sit the ${name} paper first — you need ${TUTOR_MIN_SCORE}% or ` +
              `above to teach it.`
            : `Your best score on ${name} is ${score}%. You need ` +
              `${TUTOR_MIN_SCORE}% or above to teach it.`,
        },
        403,
      );
    }

    verified.push({
      subjectId,
      subjectName: (course.subjectName ?? '').trim(),
      score,
      hourlyRateKobo: rate,
    });
  }

  // Upsert the profile itself. An existing tutor re-applying keeps their
  // rating, balance and completed-session count.
  const { data: existing } = await client
    .from('tutors')
    .select('id, status')
    .eq('user_id', user.id)
    .maybeSingle();

  if (existing?.status === 'suspended') {
    return json({ error: 'This tutor profile is suspended. Contact Eduvora.' }, 403);
  }

  let tutorId = existing?.id as string | undefined;

  if (tutorId) {
    await client
      .from('tutors')
      .update({
        headline: (body.headline ?? '').trim(),
        bio: (body.bio ?? '').trim(),
        status: 'approved',
      })
      .eq('id', tutorId);
  } else {
    const { data: inserted, error: insertError } = await client
      .from('tutors')
      .insert({
        user_id: user.id,
        headline: (body.headline ?? '').trim(),
        bio: (body.bio ?? '').trim(),
        status: 'approved',
      })
      .select('id')
      .single();
    if (insertError || !inserted) {
      console.error('tutor insert failed', insertError);
      return json({ error: 'Could not create your tutor profile.' }, 500);
    }
    tutorId = inserted.id;
  }

  const { error: coursesError } = await client.from('tutor_courses').upsert(
    verified.map((course) => ({
      tutor_id: tutorId,
      subject_id: course.subjectId,
      subject_name: course.subjectName,
      cbt_score: course.score,
      hourly_rate_kobo: course.hourlyRateKobo,
    })),
    { onConflict: 'tutor_id,subject_id' },
  );
  if (coursesError) {
    console.error('tutor_courses upsert failed', coursesError);
    return json({ error: 'Could not save the courses you chose.' }, 500);
  }

  return json({
    tutorId,
    status: 'approved',
    courses: verified.map((c) => ({ subjectId: c.subjectId, score: c.score })),
  });
});
