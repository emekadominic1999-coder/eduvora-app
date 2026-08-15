-- =============================================================================
-- University of Nigeria, Nsukka -- renumber MTH 122 -> MTH 102,
-- GSP 101 -> GST 111, and GSP 102 -> GST 114 across every table that
-- carries the code.
-- =============================================================================
-- Scope check performed before writing this migration: every 'MTH 122' row
-- (12 outline files) is a wording variant of the same course ("Elementary
-- Mathematics III", "General Mathematics III"). Every 'GSP 101' row (43
-- outline files) and 'GSP 102' row (40 outline files) is a wording variant
-- of the same Use-of-English I/II course. No department uses any of the
-- three codes for a genuinely different course, so a blanket code rename is
-- safe. None of 'MTH 102', 'GST 111', 'GST 114' was already in use anywhere
-- in the app before this migration.
--
-- course_outlines: only course_code changes; course_title, description,
-- topics, level, semester and units are left exactly as each department
-- already had them.
--
-- cbt_questions: the MTH 122 practice bank (subject_id
-- 'mth-122-vectors-geometry-dynamics') has no course_code column -- the
-- course link lives in subject_id/subject_name, updated here, along with
-- cbt_attempts/cbt_entitlements/cbt_payments so existing attempt history or
-- unlocked access stays linked. No GSP 101/GSP 102 CBT bank exists, so
-- nothing to update on that side.
-- =============================================================================

update public.course_outlines
   set course_code = 'MTH 102'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'MTH 122';

update public.course_outlines
   set course_code = 'GST 111'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 101';

update public.course_outlines
   set course_code = 'GST 114'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 102';

update public.cbt_questions
   set subject_id = 'mth-102-vectors-geometry-dynamics',
       subject_name = 'MTH 102: Vectors, Coordinate Geometry & Elementary Dynamics'
 where subject_id = 'mth-122-vectors-geometry-dynamics';

update public.cbt_attempts
   set subject_id = 'mth-102-vectors-geometry-dynamics',
       subject_name = 'MTH 102: Vectors, Coordinate Geometry & Elementary Dynamics'
 where subject_id = 'mth-122-vectors-geometry-dynamics';

update public.cbt_entitlements
   set subject_id = 'mth-102-vectors-geometry-dynamics'
 where subject_id = 'mth-122-vectors-geometry-dynamics';

update public.cbt_payments
   set subject_id = 'mth-102-vectors-geometry-dynamics',
       subject_name = 'MTH 102: Vectors, Coordinate Geometry & Elementary Dynamics'
 where subject_id = 'mth-122-vectors-geometry-dynamics';

update public.cbt_payments
   set subject_ids = (
     select jsonb_agg(
              case when elem = '"mth-122-vectors-geometry-dynamics"'::jsonb
                   then '"mth-102-vectors-geometry-dynamics"'::jsonb
                   else elem end)
     from jsonb_array_elements(subject_ids) elem
   )
 where subject_ids @> '["mth-122-vectors-geometry-dynamics"]'::jsonb;
