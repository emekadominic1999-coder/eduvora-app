-- =============================================================================
-- University of Nigeria, Nsukka -- renumber GSP 201 -> GST 311,
-- GSP 202 -> GST 312, GSP 207 -> GST 211, GSP 208 -> GST 212.
-- =============================================================================
-- Confirmed against the official GST course circular (user-supplied
-- "gst.pdf", new CCMAS curriculum): "COURSE CONTENTS AND LEARNING OUTCOMES
-- FOR GST 311 & GST 312: PEACE AND CONFLICT STUDIES I & II" -- matching
-- GSP 201/202's "Peace and Conflict Resolution I/II" content exactly. The
-- same document also references "GST 211 and GST 212" as the paired
-- Humanities-unit lecture/seminar courses, matching GSP 207/208's "Logic,
-- Philosophy and Human Existence" / "Nigerian Peoples and Culture" content.
--
-- Scope check performed before this migration: GSP 201/202 rows carry title
-- wording across two families -- "Peace and Conflict Resolution ..." and
-- "Social Science(s) I/II" -- which initially looked like two different
-- courses sharing one code. The circular's own text places "Objectives of
-- the Social Science Programme" directly as the lead-in to the GST 311/312
-- Peace and Conflict Studies course content, confirming "Social Science
-- I/II" is the same course under its programme-level name, not a different
-- course -- so all GSP 201/202 rows are renamed together, no split needed.
-- GSP 207/208 rows were already consistent (wording variants of the same
-- Logic/Philosophy and Nigerian Peoples/Culture courses respectively).
--
-- None of GST 311, GST 312, GST 211, GST 212 was already in use anywhere in
-- the app before this migration. No CBT bank exists for any of the four old
-- codes, so course_outlines is the only table affected.
-- =============================================================================

update public.course_outlines
   set course_code = 'GST 311'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 201';

update public.course_outlines
   set course_code = 'GST 312'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 202';

update public.course_outlines
   set course_code = 'GST 211'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 207';

update public.course_outlines
   set course_code = 'GST 212'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 208';
