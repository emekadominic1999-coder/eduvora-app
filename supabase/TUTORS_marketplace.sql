-- =============================================================================
-- Eduvora — tutor marketplace
-- =============================================================================
-- Students book paid sessions with coursemates who have proved they know the
-- material, and Eduvora takes a commission on each one.
--
-- Two deliberate design decisions run through this schema:
--
--   1. No phone numbers, anywhere. Booking, payment and coordination all
--      happen inside the app. A tutor only earns money and only builds a
--      rating through sessions booked here, so the side being paid has a
--      real reason not to move the arrangement to WhatsApp.
--
--   2. Every money column is written only by the edge functions using the
--      service-role key. A student's client can read their own sessions and
--      any approved tutor's public profile, but can never mark a session
--      paid, set its price, or credit a tutor's balance.
--
-- Tutors are verified against the CBT bank the app already has: to list a
-- course, a tutor must have sat that paper and scored at or above
-- TUTOR_MIN_SCORE (75%). The score is re-derived from cbt_attempts
-- server-side, never taken from the client.
-- =============================================================================

-- -------------------------------------------------------------------- tutors
-- One row per student who has applied to tutor. `status` gates visibility:
-- only 'approved' tutors are discoverable.
create table if not exists public.tutors (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid not null unique references auth.users (id) on delete cascade,
  headline           text not null default '',
  bio                text not null default '',
  status             text not null default 'pending'
                       check (status in ('pending', 'approved', 'suspended')),
  -- Denormalised running totals, maintained by the edge functions so the
  -- directory can sort and display without aggregating on every read.
  rating_sum         integer not null default 0,
  rating_count       integer not null default 0,
  sessions_completed integer not null default 0,
  -- Kobo. Credited when a session completes, debited when a payout is made.
  balance_kobo       integer not null default 0,
  lifetime_earned_kobo integer not null default 0,
  created_at         timestamptz not null default now()
);

create index if not exists tutors_status_idx on public.tutors (status);

alter table public.tutors enable row level security;

drop policy if exists "approved tutors are readable" on public.tutors;
create policy "approved tutors are readable"
  on public.tutors for select
  to authenticated
  using (status = 'approved' or auth.uid() = user_id);

drop policy if exists "students create their own tutor profile" on public.tutors;
create policy "students create their own tutor profile"
  on public.tutors for insert
  to authenticated
  with check (auth.uid() = user_id and status = 'pending');

-- A tutor may edit their own copy, but never their status or any money
-- column -- those are checked by a trigger below, since RLS alone cannot
-- restrict which columns an update touches.
drop policy if exists "tutors edit their own profile" on public.tutors;
create policy "tutors edit their own profile"
  on public.tutors for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create or replace function public.tutors_guard_privileged_columns()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- The service role bypasses RLS entirely and so never reaches this check;
  -- this only constrains updates coming from a signed-in student's client.
  if auth.uid() is not null then
    if new.status is distinct from old.status
       or new.rating_sum is distinct from old.rating_sum
       or new.rating_count is distinct from old.rating_count
       or new.sessions_completed is distinct from old.sessions_completed
       or new.balance_kobo is distinct from old.balance_kobo
       or new.lifetime_earned_kobo is distinct from old.lifetime_earned_kobo then
      raise exception 'Those fields are managed by Eduvora, not by the app.';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists tutors_guard_privileged_columns on public.tutors;
create trigger tutors_guard_privileged_columns
  before update on public.tutors
  for each row execute function public.tutors_guard_privileged_columns();

-- ------------------------------------------------------------- tutor_courses
-- Which papers a tutor is cleared to teach, with the CBT score that earned
-- them the listing. Inserted only by the tutor-apply edge function, which
-- verifies the score first.
create table if not exists public.tutor_courses (
  id              uuid primary key default gen_random_uuid(),
  tutor_id        uuid not null references public.tutors (id) on delete cascade,
  subject_id      text not null,
  subject_name    text not null default '',
  -- The verified percentage from cbt_attempts at the time of approval.
  cbt_score       integer not null,
  hourly_rate_kobo integer not null check (hourly_rate_kobo > 0),
  created_at      timestamptz not null default now(),
  unique (tutor_id, subject_id)
);

create index if not exists tutor_courses_subject_idx on public.tutor_courses (subject_id);

alter table public.tutor_courses enable row level security;

drop policy if exists "tutor courses are readable" on public.tutor_courses;
create policy "tutor courses are readable"
  on public.tutor_courses for select
  to authenticated
  using (true);

-- A tutor may adjust their own rate or withdraw a course; adding one has to
-- go through tutor-apply so the CBT score is actually checked.
drop policy if exists "tutors manage their own course rates" on public.tutor_courses;
create policy "tutors manage their own course rates"
  on public.tutor_courses for update
  to authenticated
  using (tutor_id in (select id from public.tutors where user_id = auth.uid()))
  with check (tutor_id in (select id from public.tutors where user_id = auth.uid()));

drop policy if exists "tutors remove their own courses" on public.tutor_courses;
create policy "tutors remove their own courses"
  on public.tutor_courses for delete
  to authenticated
  using (tutor_id in (select id from public.tutors where user_id = auth.uid()));

-- ------------------------------------------------------------ tutor_sessions
-- The booking itself, and the money attached to it.
--
--   requested  student asked for a slot
--   accepted   tutor agreed; awaiting payment
--   paid       student paid; the session is confirmed
--   completed  student confirmed it happened -> tutor balance credited
--   cancelled  either side backed out before payment
--   disputed   student says it did not happen; needs a human
create table if not exists public.tutor_sessions (
  id                 uuid primary key default gen_random_uuid(),
  student_id         uuid not null references auth.users (id) on delete cascade,
  tutor_id           uuid not null references public.tutors (id) on delete cascade,
  subject_id         text not null,
  subject_name       text not null default '',
  topic              text not null default '',
  meeting_mode       text not null default 'online'
                       check (meeting_mode in ('online', 'in_person')),
  scheduled_at       timestamptz,
  duration_minutes   integer not null default 60 check (duration_minutes > 0),
  -- Money, all in kobo, all set server-side from the tutor's listed rate.
  amount_kobo        integer not null default 0,
  platform_fee_kobo  integer not null default 0,
  tutor_earnings_kobo integer not null default 0,
  reference          text unique,
  status             text not null default 'requested'
                       check (status in ('requested', 'accepted', 'paid',
                                         'completed', 'cancelled', 'disputed')),
  created_at         timestamptz not null default now(),
  paid_at            timestamptz,
  completed_at       timestamptz
);

create index if not exists tutor_sessions_student_idx on public.tutor_sessions (student_id, created_at desc);
create index if not exists tutor_sessions_tutor_idx on public.tutor_sessions (tutor_id, created_at desc);

alter table public.tutor_sessions enable row level security;

-- Both sides of a booking can see it; nobody else can.
drop policy if exists "both parties read their sessions" on public.tutor_sessions;
create policy "both parties read their sessions"
  on public.tutor_sessions for select
  to authenticated
  using (
    auth.uid() = student_id
    or tutor_id in (select id from public.tutors where user_id = auth.uid())
  );

-- A student may request a session, but only with zero money attached --
-- pricing is filled in server-side when the tutor accepts.
drop policy if exists "students request sessions" on public.tutor_sessions;
create policy "students request sessions"
  on public.tutor_sessions for insert
  to authenticated
  with check (
    auth.uid() = student_id
    and status = 'requested'
    and amount_kobo = 0
    and platform_fee_kobo = 0
    and tutor_earnings_kobo = 0
  );

-- Status moves that involve no money (accept, cancel, mark complete, raise a
-- dispute) are allowed from the client; anything touching an amount, or the
-- 'paid' status, is rejected by the trigger below and must go through an
-- edge function instead.
drop policy if exists "both parties advance their sessions" on public.tutor_sessions;
create policy "both parties advance their sessions"
  on public.tutor_sessions for update
  to authenticated
  using (
    auth.uid() = student_id
    or tutor_id in (select id from public.tutors where user_id = auth.uid())
  )
  with check (
    auth.uid() = student_id
    or tutor_id in (select id from public.tutors where user_id = auth.uid())
  );

create or replace function public.tutor_sessions_guard_money()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is not null then
    if new.amount_kobo is distinct from old.amount_kobo
       or new.platform_fee_kobo is distinct from old.platform_fee_kobo
       or new.tutor_earnings_kobo is distinct from old.tutor_earnings_kobo
       or new.reference is distinct from old.reference
       or new.paid_at is distinct from old.paid_at then
      raise exception 'Session pricing is set by Eduvora, not by the app.';
    end if;
    -- Only a verified payment may mark a session paid.
    if new.status = 'paid' and old.status is distinct from 'paid' then
      raise exception 'A session is marked paid only once payment is confirmed.';
    end if;
    -- Completion credits a tutor's balance, so it runs server-side too.
    if new.status = 'completed' and old.status is distinct from 'completed' then
      raise exception 'Use the confirm-session function to complete a session.';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists tutor_sessions_guard_money on public.tutor_sessions;
create trigger tutor_sessions_guard_money
  before update on public.tutor_sessions
  for each row execute function public.tutor_sessions_guard_money();

-- ------------------------------------------------------------- tutor_reviews
-- One review per completed session, written by the student who booked it.
create table if not exists public.tutor_reviews (
  id         uuid primary key default gen_random_uuid(),
  session_id uuid not null unique references public.tutor_sessions (id) on delete cascade,
  tutor_id   uuid not null references public.tutors (id) on delete cascade,
  student_id uuid not null references auth.users (id) on delete cascade,
  rating     integer not null check (rating between 1 and 5),
  comment    text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists tutor_reviews_tutor_idx on public.tutor_reviews (tutor_id, created_at desc);

alter table public.tutor_reviews enable row level security;

drop policy if exists "reviews are readable" on public.tutor_reviews;
create policy "reviews are readable"
  on public.tutor_reviews for select
  to authenticated
  using (true);

-- Insert goes through the edge function so the tutor's running average is
-- updated in the same breath as the review lands.

-- ------------------------------------------------------------- tutor_payouts
-- The withdrawal ledger. A tutor requests; the Eduvora operator pays by bank
-- transfer and marks it sent. Deliberately manual for now -- automated
-- transfers need a verified business account with the payment provider, and
-- this shape swaps over to that later without a rewrite.
create table if not exists public.tutor_payouts (
  id          uuid primary key default gen_random_uuid(),
  tutor_id    uuid not null references public.tutors (id) on delete cascade,
  amount_kobo integer not null check (amount_kobo > 0),
  status      text not null default 'requested'
                check (status in ('requested', 'paid', 'rejected')),
  -- Where to send it. Collected at request time rather than held on the
  -- profile, so a stale account number can never be paid by accident.
  bank_name      text not null default '',
  account_number text not null default '',
  account_name   text not null default '',
  note        text not null default '',
  requested_at timestamptz not null default now(),
  paid_at     timestamptz
);

create index if not exists tutor_payouts_tutor_idx on public.tutor_payouts (tutor_id, requested_at desc);

alter table public.tutor_payouts enable row level security;

drop policy if exists "tutors read their own payouts" on public.tutor_payouts;
create policy "tutors read their own payouts"
  on public.tutor_payouts for select
  to authenticated
  using (tutor_id in (select id from public.tutors where user_id = auth.uid()));

-- Requesting a payout debits the balance, so it goes through an edge
-- function; there is deliberately no insert policy here.
