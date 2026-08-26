-- =============================================================================
-- Fix a mistake in the GSP->GST placeholder mapping from the UNN timetable
-- import (unn_cbt_timetable_placeholder_subjects.sql).
-- =============================================================================
-- The old GSP codes were already fully renamed to GST earlier this
-- session (GSP201->GST311, GSP202->GST312, GSP207->GST211,
-- GSP208->GST212). When building placeholder subjects from the
-- timetable, this got mixed up:
--
--   - "GSP 208" (from the timetable) is the OLD code for GST212, which
--     already has a real, 222-question CBT bank. A duplicate "coming
--     soon" placeholder was wrongly created for it -- deleted.
--   - "GSP 202" (from the timetable) is the OLD code for GST312, which
--     has NO bank at all. It was wrongly skipped on the assumption it
--     was already covered -- added as a proper GST312 placeholder.
--
-- Left "GSP 102" and "GSP 106" (from the timetable) as-is under their
-- GSP labels -- they are plausibly GST111 (Use of English I) and GST114
-- (Use of English II) given the student counts and the fact no other
-- GST code range is unaccounted for, but this was NOT verified against
-- a real source the way the other GSP->GST mappings were, so it was not
-- guessed. Flagged to the user for confirmation.
-- =============================================================================

delete from public.cbt_questions where subject_id = 'gsp-208-coming-soon';

insert into public.cbt_questions
  (subject_id, subject_name, institution, faculty, department, level,
   question, options, correct_index, explanation, topic, is_general,
   semester, units)
values
  ('gst-312-peace-conflict-resolution-2', 'GST312: Peace and Conflict Resolution II',
   'University of Nigeria, Nsukka', '', '', '300 Level',
   'This GST312 practice paper is coming soon. Check back later -- new questions are added regularly.',
   '["OK", "Coming soon", "Check back later", "Not yet available"]'::jsonb, 0,
   'This paper has not been built yet.', 'Coming Soon', true, 'second', 0);

-- Follow-up: removed the two remaining old-code placeholders entirely
-- rather than guess which GST code they became (GSP 102, GSP 106).
delete from public.cbt_questions where subject_id in ('gsp-102-coming-soon', 'gsp-106-coming-soon');
