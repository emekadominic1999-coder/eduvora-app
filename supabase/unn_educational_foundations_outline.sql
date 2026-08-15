-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Educational Foundations
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 53 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- Scope: the 3-Year Standard Degree Programme in Guidance and Counseling. The department also runs a 4-Year programme combining Guidance and Counseling with a second teaching subject (Social Studies, History, Biology, or Igbo), published on the same page, which is out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Educational Foundations';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('ED 101', 'Introduction to Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 102', 'History of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 211', 'Educational Psychology I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 213', 'Principles of Guidance and Counseling', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 215', 'Vocational Development and Adjustment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 221', 'Curriculum Theory and Development', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'Communication in English I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 111', 'The Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Basic Concepts and Theory of Peace', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 201', 'Philosophy of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 205', 'Sociology of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 214', 'Sensitivity Training', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 216', 'Counseling Theories', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 217', 'Group Procedure in Guidance and Counseling', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 219', 'Educational and Occupational Information', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 227', 'Introduction to Special Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 311', 'Educational Psychology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'Use of English', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Peace and Conflicts II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 218', 'Behaviour Modification', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 312', 'Personality Development', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 313', 'Adolescent and Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 324', 'Issues in Primary Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 341', 'Research Method, Statistics and Computer Usage', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HED 232', 'School Health', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 315', 'Psychological Testing and Counseling', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 316', 'Organization and Administration of Guidance', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 317', 'Practicum in Guidance and Counseling I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 318', 'Behaviour Modification II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 321', 'Curriculum Implementation and Instruction', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ED 323', 'Pre-School Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 326', 'Language Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Application', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 327', 'Assessment and Programming for Special Children', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 411', 'Organization and Administration of Guidance Services', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 415', 'Counseling Techniques', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 416', 'Ethical and Professional Responsibility in Counseling', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 417', 'Practicum in Guidance and Counseling II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ED 431', 'Educational Administration and Planning', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 204', 'Environmental Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 412', 'Abnormal Psychology and Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('ED 427', 'Counseling Special Education Pupils', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 429', 'Vocational Education and Rehabilitation of Special Children', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 442', 'Measurement and Evaluation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ED 451', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('ED 433', 'Classroom Organization and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 322', 'School Librarianship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ED 426', 'Adult Education and Community Development', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Educational Foundations', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false);
