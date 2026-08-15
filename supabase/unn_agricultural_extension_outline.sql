-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Agriculture
-- Department of Agricultural Extension
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 8 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- SCOPE: the department's own course-modules page publishes only 8 AEX-coded undergraduate courses (100-400 Level); the rest of the page is postgraduate (500+ level) material, out of scope for this app. No semester breakdown is published -- every row is stored under semester='first' as a neutral placeholder, not a verified fact.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Agricultural Extension';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('AEX 101', 'Philosophy and Principles of Agricultural Extension', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 102', 'Psychology in Extension', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 201', 'Introduction to Agricultural Extension and Extension Teaching Methods', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 301', 'Introduction to Rural Sociology', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 312', 'Agricultural Laws and Reforms', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 421', 'Information Communication Technology and Documentation in Extension', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 422', 'Agricultural Extension Practices', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 482', 'Introduction to Research Methods in Extension', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Agricultural Extension', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false);
