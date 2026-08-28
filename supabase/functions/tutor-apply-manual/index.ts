import { createClient } from 'jsr:@supabase/supabase-js@2';

import {
  CORS_HEADERS,
  json,
  MAX_HOURLY_RATE_KOBO,
  MIN_HOURLY_RATE_KOBO,
} from '../_shared/tutors.ts';

// The second way to become a tutor: no CBT score required, just a note an
// operator reads and approves or rejects by hand. Unlike tutor-apply, this
// never sets status to 'approved' itself -- it only ever creates or updates
// a 'pending' profile, since there is nothing here for the server to verify
// automatically. Approving one is a manual status flip in the database.
//
// Deliberately for first-time applicants only: someone who already has an
// approved, CBT-verified profile should add more courses through the
// instant tutor-apply path, not this one -- letting an approved tutor's
// status regress to 'pending' here would hide their already-verified
// courses from the directory the moment they tried to add one more the
// slow way.

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

  let body: { headline?: string; bio?: string; applicationNote?: string; courses?: CourseRequest[] };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }

  const note = (body.applicationNote ?? '').trim();
  if (note.length < 20) {
    return json(
      { error: 'Say a bit more about why you would be a good tutor (at least 20 characters).' },
      400,
    );
  }

  const courses = body.courses ?? [];
  if (courses.length === 0) {
    return json({ error: 'Choose at least one course to teach.' }, 400);
  }

  const prepared: { subjectId: string; subjectName: string; hourlyRateKobo: number }[] = [];
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
    prepared.push({ subjectId, subjectName: (course.subjectName ?? '').trim(), hourlyRateKobo: rate });
  }

  const { data: existing } = await client
    .from('tutors')
    .select('id, status')
    .eq('user_id', user.id)
    .maybeSingle();

  if (existing?.status === 'suspended') {
    return json({ error: 'This tutor profile is suspended. Contact Eduvora.' }, 403);
  }
  if (existing?.status === 'approved') {
    return json(
      {
        error:
          'You already have an approved tutor profile -- add more courses from ' +
          '"Edit my tutoring" instead, which checks your CBT score directly.',
      },
      409,
    );
  }

  let tutorId = existing?.id as string | undefined;

  if (tutorId) {
    await client
      .from('tutors')
      .update({
        headline: (body.headline ?? '').trim(),
        bio: (body.bio ?? '').trim(),
        application_note: note,
        status: 'pending',
      })
      .eq('id', tutorId);
  } else {
    const { data: inserted, error: insertError } = await client
      .from('tutors')
      .insert({
        user_id: user.id,
        headline: (body.headline ?? '').trim(),
        bio: (body.bio ?? '').trim(),
        application_note: note,
        status: 'pending',
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
    prepared.map((course) => ({
      tutor_id: tutorId,
      subject_id: course.subjectId,
      subject_name: course.subjectName,
      cbt_score: 0,
      verification_method: 'manual',
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
    status: 'pending',
    courses: prepared.map((c) => ({ subjectId: c.subjectId })),
  });
});
