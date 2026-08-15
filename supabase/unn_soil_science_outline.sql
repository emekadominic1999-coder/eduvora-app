-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Agriculture
-- Department of Soil Science
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 12 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- SCOPE: the department's own course-modules page publishes only First Year, First Semester (the four SSL/CAB/AEX/AFC/ANS courses are the major electives; students choose among them alongside the required ancillary and General Studies courses) -- no later years or semesters are published on the page at all.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Soil Science';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('SSL 101', 'Introduction to Land and Soil Resources', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CAB 161', 'Introduction to Agro-Biotechnology', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AEX 101', 'Philosophy and Principles of Agricultural Extension', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AFC 101', 'Introduction to Agricultural Economics I', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ANS 101', 'Introduction to Animal Science and Animal Genetics', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('AGR 101', 'Biomathematics', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CHEM 101', 'Basic Principles of Chemistry I', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CHEM 171', 'Basic Practical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 151', 'General Biology I', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MTH 111', 'Elementary Mathematics I', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Social Sciences', 'University of Nigeria, Nsukka', 'Faculty of Agriculture', 'Soil Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false);
