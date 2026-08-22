-- =============================================================================
-- University of Nigeria, Nsukka -- renumber GSP 201 -> GST 311,
-- GSP 202 -> GST 312, GSP 207 -> GST 211, GSP 208 -> GST 212.
-- =============================================================================
-- Scope check performed before writing this migration:
--
-- GSP 207 (15 rows) and GSP 208 (18 rows) are wording variants of a single
-- course each ("Logic, Philosophy and Human Existence" / "Humanities I",
-- and "Nigerian Peoples and Culture" / "Humanities II" / "Philosophy and
-- Logic II" respectively) -- safe to rename in full.
--
-- GSP 201 and GSP 202 are NOT uniform: most rows are "Peace and Conflict
-- Resolution I/II" (under many different department-specific titles), but
-- 8 GSP 201 rows and 3 GSP 202 rows (Accountancy, Management, Fine and
-- Applied Arts, Science Education, Arts Education, Soil Science, Computer
-- Science, Mechanical Engineering) are titled "Social Science(s) I/II" --
-- a genuinely different course, almost certainly a pre-existing miscoding
-- that belongs under GSP 103/104 (seen elsewhere in this app as "Social
-- Science I/II") rather than GSP 201/202. This migration renames only the
-- genuine "Peace and Conflict Resolution" rows and leaves the 11 mismatched
-- "Social Science(s)" rows on their original GSP 201/202 code untouched,
-- so as not to relabel unrelated content as GST 311/312. That mismatch is
-- a separate data-quality issue, flagged but not fixed here.
--
-- None of GST 311, GST 312, GST 211, GST 212 was already in use anywhere
-- in the app before this migration. No CBT bank exists for any of the four
-- old codes, so course_outlines is the only table affected.
-- =============================================================================

update public.course_outlines
   set course_code = 'GST 311'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 201'
   and course_title not ilike '%social science%';

update public.course_outlines
   set course_code = 'GST 312'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 202'
   and course_title not ilike '%social science%';

update public.course_outlines
   set course_code = 'GST 211'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 207';

update public.course_outlines
   set course_code = 'GST 212'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'GSP 208';
