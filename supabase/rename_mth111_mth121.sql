-- =============================================================================
-- University of Nigeria, Nsukka -- renumber MTH 111 -> MTH 101 and
-- MTH 121 -> MTH 103 across every table that carries the code.
-- =============================================================================
-- Scope check performed before writing this migration: every 'MTH 111' row
-- across 25 outline files carries a title that is a wording variant of the
-- same course ("Elementary Mathematics I", "General Mathematics I", "General
-- Mathematics"), and every 'MTH 121' row across 15 outline files is likewise
-- a variant of the same course ("Elementary Mathematics II", "Elementary
-- Mathematics III" -- a known handbook sequencing quirk in the Electronic
-- Engineering chapter, documented when that outline was written -- and
-- "General Mathematics II"). No department uses either code for a genuinely
-- different course, so a blanket code rename is safe. Neither 'MTH 101' nor
-- 'MTH 103' was already in use anywhere in the app before this migration.
--
-- course_outlines: only the course_code changes; course_title, description,
-- topics, level, semester and units are left exactly as each department
-- already had them.
--
-- cbt_questions: the MTH 121 practice bank (785 rows, subject_id
-- 'mth-121-calculus') has no course_code column -- the course link lives in
-- subject_id/subject_name, which are updated here. No MTH 111 practice bank
-- exists yet, so there is nothing to update on that side.
--
-- Also updates cbt_attempts, cbt_entitlements and cbt_payments so any
-- existing attempt history, unlocked access, or receipt referencing the old
-- 'mth-121-calculus' subject_id stays correctly linked after the rename,
-- including the jsonb subject_ids array on cbt_payments used for course-pack
-- purchases.
-- =============================================================================

update public.course_outlines
   set course_code = 'MTH 101'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'MTH 111';

update public.course_outlines
   set course_code = 'MTH 103'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'MTH 121';

update public.cbt_questions
   set subject_id = 'mth-103-calculus',
       subject_name = 'MTH 103: Functions, Limits, Differentiation & Integration'
 where subject_id = 'mth-121-calculus';

update public.cbt_attempts
   set subject_id = 'mth-103-calculus',
       subject_name = 'MTH 103: Functions, Limits, Differentiation & Integration'
 where subject_id = 'mth-121-calculus';

update public.cbt_entitlements
   set subject_id = 'mth-103-calculus'
 where subject_id = 'mth-121-calculus';

update public.cbt_payments
   set subject_id = 'mth-103-calculus',
       subject_name = 'MTH 103: Functions, Limits, Differentiation & Integration'
 where subject_id = 'mth-121-calculus';

update public.cbt_payments
   set subject_ids = (
     select jsonb_agg(
              case when elem = '"mth-121-calculus"'::jsonb
                   then '"mth-103-calculus"'::jsonb
                   else elem end)
     from jsonb_array_elements(subject_ids) elem
   )
 where subject_ids @> '["mth-121-calculus"]'::jsonb;
