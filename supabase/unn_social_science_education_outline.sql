-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Social Science Education
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 25 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- SEMESTER: the department's own course-modules page lists all 24 courses in a single flat list with only code, title and units -- no year/semester grouping at all. Level here is inferred from each code's leading digit (a reliable, well-established Nigerian course-coding convention); every row is stored under semester='first' as a neutral placeholder, not a verified fact.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Social Science Education';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('SSE 100', 'Elements of Social Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 101', 'The Structure and Characteristics of Man''s Place', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 102', 'Introduction to Nigerian Social Life and Culture', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 103', 'Introduction to Social Studies Education and Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 104', 'Family as the Source of the Structure of the Society', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 106', 'Introduction to Nigerian Cultural Environment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 112', 'Community Life and Social Environment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 201', 'Study of Matters in Space', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 202', 'Social Interaction in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 203', 'Social Studies Education and Patterns of Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 204', 'Nigeria Socio-Political Institutions', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 205', 'The Social-Economic Structure of Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 206', 'Culture and Social Stability', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 301', 'Study of Events in Space', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 302', 'Nationalism and Patriotism in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 303', 'Social Studies Education and Theories of Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 304', 'Politics, Power and Government in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 305', 'Finance and Financial Institutions in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 306', 'Nigeria Cultural Patterns and Historical Origin', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 401', 'Study of Ideas in Space', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 403', 'Social Studies Education, Problems and Prospects of Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 404', 'Social Life and Party Politics in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 411', 'Contemporary World Issues', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 421', 'Africa and Development Nation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 431', 'Contemporary Issues in Social Studies Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Social Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false);
