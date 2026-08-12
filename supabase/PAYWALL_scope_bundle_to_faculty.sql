-- =============================================================================
-- Eduvora — scope the semester_all bundle to a faculty, locked at purchase
-- =============================================================================
-- The ₦1,200 "all papers" bundle originally unlocked literally every paper in
-- the whole bank, regardless of what the student studies -- a Computer
-- Science student's bundle would also unlock Zoology, Religion, every other
-- department's papers. That is both more than the price is meant to buy and
-- an unintended incentive to switch departments just to browse unrelated
-- papers for free.
--
-- Adds a `faculty` column to both tables: for cbt_payments it is the
-- student's faculty at the moment they paid (read from `profiles` by the
-- paystack-initialize edge function, never trusted from the client); for
-- cbt_entitlements it is copied across by paystack-verify when the
-- entitlement is created. A single_paper purchase leaves it blank -- its
-- subject_id already pins it to exactly one paper, so no separate scope is
-- needed. Locked in at purchase time so editing the profile afterward can
-- neither gain nor lose what was actually paid for, matching how
-- single_paper entitlements already behave.
-- =============================================================================

alter table public.cbt_payments add column if not exists faculty text not null default '';
alter table public.cbt_entitlements add column if not exists faculty text not null default '';
