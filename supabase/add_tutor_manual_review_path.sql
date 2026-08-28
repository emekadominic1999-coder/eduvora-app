-- =============================================================================
-- A second way to become a tutor: manual review, alongside the existing
-- instant CBT-score path.
-- =============================================================================
-- The CBT-only gate (score >= TUTOR_MIN_SCORE on a real 20+ question
-- sitting) measures whether someone can pass an exam, not whether they'd
-- make a good tutor -- a genuinely strong student who just doesn't want to
-- sit a formal paper for a side gig was locked out entirely. This adds a
-- slower, human-approved path: submit a note instead of a score, and an
-- operator approves or rejects it directly (no in-app admin panel yet --
-- approving means flipping tutors.status to 'approved' by hand).
--
-- The 'pending' status and its RLS policy already existed (a tutor could
-- always read their own non-approved row, and could always insert one with
-- status='pending' directly) -- this just gives that state a real path to
-- reach, via a new edge function (tutor-apply-manual) instead of the client
-- inserting directly, since tutor_courses rows still need to go through a
-- server function (no direct-insert policy exists on that table).
-- =============================================================================

alter table public.tutors
  add column if not exists application_note text not null default '';

alter table public.tutor_courses
  add column if not exists verification_method text not null default 'cbt'
    check (verification_method in ('cbt', 'manual'));

-- cbt_score is meaningless for a manually-reviewed course (no paper was
-- sat) -- 0 paired with verification_method='manual' is the sentinel the
-- client and edge functions use to know not to show a score badge for it.
