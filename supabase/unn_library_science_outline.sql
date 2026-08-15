-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Library Science
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 38 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- SEMESTER: the department's own course-modules page groups courses only by level (100-400) and Core/Elective status; it does not publish a first/second semester breakdown at all. Every row here is stored under semester='first' as a neutral placeholder (the schema requires a value) -- this is NOT a verified fact, only the level column is authoritative for this department.
--
-- Scope: undergraduate courses (100-400 Level) only; the source page also lists a Postgraduate Diploma (PGD) track, out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Library Science';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('LIS 101', 'Libraries and Society', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 102', 'History of Libraries', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 103', 'Library Visits and Orientation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 104', 'Introduction to Library Resources and Services', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 211', 'Collection Development', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 212', 'Organisation of Knowledge I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 213', 'Technical Services in Libraries', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 222', 'Oral Traditions and Cultural Literature', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 232', 'Introduction to Bibliography', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 234', 'Information Users', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 241', 'Introduction to Library Administration', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 242', 'Library Work with Children and Youth', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 243', 'Library and Information Services to Disadvantaged Communities', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 252', 'Computers and Data Processing', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 302', 'School Librarianship (Service Course)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 311', 'Organisation of Knowledge II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 331', 'Introduction to Information Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 352', 'Library Practice and Internship (SIWES)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '300 Level', 'first', 15, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 361', 'Research Methods in Library and Information Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 402', 'Contemporary Technology in Libraries', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 404', 'Publishing and Book Production', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 412', 'Indexing and Abstracting', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 414', 'Preservation and Conservation of Library Materials', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 421', 'Audiovisual Librarianship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 422', 'Government and Serial Publications', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 423', 'Literature of African Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 424', 'Children''s Literature', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 425', 'Literature of Humanities and Social Sciences', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 427', 'Literature of Science and Technology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 431', 'Reference and Information Services', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 441', 'National and Public Libraries', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 442', 'Archives Administration and Records Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 443', 'Academic and Special Libraries', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 444', 'Inter-Library Cooperation and Information Networks', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 445', 'School Libraries and Media Resource Centres', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 446', 'Library and Information Service Policy', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 448', 'Library Marketing and Public Relations', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIS 462', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Library Science', '400 Level', 'first', 4, '', '[]'::jsonb, 'Department official website', false);
