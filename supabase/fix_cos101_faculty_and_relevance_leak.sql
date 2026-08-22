-- =============================================================================
-- Fix: Electrical Engineering (and every other faculty) seeing CBT papers
-- with no connection to their course outline, e.g. COS 101, in the normal
-- "Papers for you" list.
-- =============================================================================
-- Root cause was in app code, not data: cbt_home_screen.dart's relevance
-- filter was `isRelevantTo(faculty) || paywall.hasAccess(subject, ...)`, and
-- `PaywallRepository.hasAccess` currently honours a testing-only "unlock
-- everything" override (`testingUnlockAll = true`). While that override is
-- on, hasAccess() returns true for every paper, which made the OR always
-- true -- so every faculty saw every paper as "for you", not just the ones
-- that actually match their course outline. Fixed by checking the real
-- entitlement list directly in that screen instead of going through
-- hasAccess(), so the testing override only affects whether a locked paper
-- can be started for free, not which papers are shown as relevant.
--
-- Separately, while investigating, found a genuine data gap: COS 101 is
-- required by English & Literary Studies, Fine and Applied Arts, and Mass
-- Communication (Faculty of Arts) per their own course_outlines rows, but
-- the CBT bank's faculty tag never included Faculty of Arts. Fixed here.
-- =============================================================================

update public.cbt_questions
   set faculty = 'Faculty of Physical Sciences, Faculty of Agriculture, Faculty of Biological Sciences, Faculty of Social Sciences, Faculty of Arts'
 where subject_id = 'cos-101-intro-computing';
