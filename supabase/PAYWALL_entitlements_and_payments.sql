-- =============================================================================
-- Eduvora — CBT paywall: entitlements and payments
-- =============================================================================
-- Adds the two tables behind "pay to unlock a paper / unlock everything this
-- semester". Both are written to only by the paystack-initialize and
-- paystack-verify edge functions (via the service-role key, which bypasses
-- RLS) — a signed-in student can read their own rows here but can never
-- insert or update one directly, so the client cannot grant itself access.
--
-- subject_id = '' means "every subject" (the semester_all plan). A blank
-- string rather than null so the (user_id, plan, subject_id) unique
-- constraint actually dedupes repeat purchases of the same plan — Postgres
-- treats every null as distinct for uniqueness purposes, which null would
-- have silently broken.
-- =============================================================================

-- ---------------------------------------------------------------- cbt_payments
-- One row per checkout attempt, keyed by the Paystack transaction reference.
-- Doubles as the receipt history shown to the student.
create table if not exists public.cbt_payments (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users (id) on delete cascade,
  subject_id   text not null default '',
  subject_name text not null default '',
  plan         text not null check (plan in ('single_paper', 'semester_all')),
  amount_kobo  integer not null,
  reference    text not null unique,
  status       text not null default 'pending'
                 check (status in ('pending', 'success', 'failed')),
  created_at   timestamptz not null default now(),
  verified_at  timestamptz
);

create index if not exists cbt_payments_user_idx on public.cbt_payments (user_id, created_at desc);
create index if not exists cbt_payments_reference_idx on public.cbt_payments (reference);

alter table public.cbt_payments enable row level security;

drop policy if exists "students read their own payments" on public.cbt_payments;
create policy "students read their own payments"
  on public.cbt_payments for select
  to authenticated
  using (auth.uid() = user_id);

-- No insert/update policy for `authenticated` — every write comes from the
-- edge functions using the service-role key. A student's client can read a
-- receipt but can never fabricate a "successful" payment.

-- ------------------------------------------------------------- cbt_entitlements
-- What a student has actually unlocked. Checked by the app before a locked
-- paper is allowed to start.
create table if not exists public.cbt_entitlements (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  subject_id text not null default '',
  plan       text not null check (plan in ('single_paper', 'semester_all')),
  expires_at timestamptz not null,
  payment_id uuid references public.cbt_payments (id) on delete set null,
  created_at timestamptz not null default now(),
  unique (user_id, plan, subject_id)
);

create index if not exists cbt_entitlements_user_idx on public.cbt_entitlements (user_id, expires_at);

alter table public.cbt_entitlements enable row level security;

drop policy if exists "students read their own entitlements" on public.cbt_entitlements;
create policy "students read their own entitlements"
  on public.cbt_entitlements for select
  to authenticated
  using (auth.uid() = user_id);

-- Same rule as cbt_payments: no insert/update policy for `authenticated`.
