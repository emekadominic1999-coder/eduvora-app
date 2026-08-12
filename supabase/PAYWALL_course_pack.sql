-- =============================================================================
-- Eduvora — replace the faculty-wide bundle with a student-picked course pack
-- =============================================================================
-- The ₦1,200 plan no longer blanket-unlocks a whole faculty. Instead the
-- student picks their department, level and semester, sees only the papers
-- that actually exist for that combination, and selects up to a 23-unit
-- load (the real course-registration cap) to unlock -- still one flat
-- ₦1,200 regardless of how many papers that ends up being.
--
-- Every entitlement this produces is back to being subject-specific (one
-- row per paper), same shape as a single_paper purchase, just labelled
-- 'course_pack' so the two remain distinguishable in the data.
-- =============================================================================

-- ------------------------------------------------------------- cbt_questions
-- semester/units are per-subject facts (every row of a given subject_id
-- shares them), sourced from course_outlines for the papers that exist.
alter table public.cbt_questions add column if not exists semester text not null default '';
alter table public.cbt_questions add column if not exists units integer not null default 0;

update public.cbt_questions set semester = 'first', units = 3 where subject_id = 'mth-121-calculus';
update public.cbt_questions set semester = 'second', units = 3 where subject_id = 'mth-122-vectors-geometry-dynamics';
update public.cbt_questions set semester = 'first', units = 3 where subject_id = 'cos-101-intro-computing';

-- -------------------------------------------------------------- cbt_payments
alter table public.cbt_payments add column if not exists subject_ids jsonb not null default '[]'::jsonb;
alter table public.cbt_payments add column if not exists department text not null default '';
alter table public.cbt_payments add column if not exists level text not null default '';
alter table public.cbt_payments add column if not exists semester text not null default '';

alter table public.cbt_payments drop constraint if exists cbt_payments_plan_check;
alter table public.cbt_payments add constraint cbt_payments_plan_check
  check (plan in ('single_paper', 'semester_all', 'course_pack'));

-- ---------------------------------------------------------- cbt_entitlements
alter table public.cbt_entitlements drop constraint if exists cbt_entitlements_plan_check;
alter table public.cbt_entitlements add constraint cbt_entitlements_plan_check
  check (plan in ('single_paper', 'semester_all', 'course_pack'));
