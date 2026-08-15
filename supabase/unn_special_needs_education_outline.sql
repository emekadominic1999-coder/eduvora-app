-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Special Needs Education
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 70 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- Scope: the B.Ed Special Education/Social Studies combined-subject programme. The department also runs equivalent 4-year programmes combining Special Education with Economics, English, History, or Igbo Studies, published on the same page, which are out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Special Needs Education';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('EDF 103', 'Introduction to Special Education I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 100', 'Elements of Social Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 101', 'Introduction to Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 211', 'Educational Psychology I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 111', 'The Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 106', 'Anatomy and Physiology of Sensory Organs as they Relate to Children with Special Needs', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 118', 'Assessment and Programming for Children with Special Needs', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 120', 'Strategies for Teaching Children with Special Needs', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 101', 'Structural Characteristics of Man''s Place', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 102', 'Introduction to Nigeria Social Life and Culture', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 112', 'Community Life and Development', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'The Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 202', 'Philosophy of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 206', 'Sociology of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 102', 'History of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 227', 'Introduction to Special Education II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 247', 'Educating Children with Emotional Behaviour Disorder', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 245', 'Educating Children with Hearing Impairment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 201', 'Study of Matter and Space', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 202', 'Social Interaction in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 203', 'Social Studies Education and Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Issues in and Theories of Peace and Conflict Resolution I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 207', 'Humanities I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 221', 'Curriculum Theories and Planning', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 224', 'Educational Technology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 218', 'Behaviour Modification I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 244', 'Educating Children with Visual Impairment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 248', 'Educating Children with Intellectual Disability', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 204', 'Nigerian Socio-Political Institutions', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 205', 'Socio-Economic Structure of Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 208', 'Humanities II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Basic Concept and Theories of Peace and Conflict Resolution II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDS 204', 'Environmental Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 327', 'Assessment and Programming for Children with Special Needs', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 325', 'Teaching Practice I (Practicum)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 341', 'Research Methods, Statistics and Computer Usage', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 315', 'Psychological Testing and Counselling', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 335', 'Developing Enrichment Materials for Teaching Gifted, Talented and Creative Children', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 329', 'Special Education Services', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 305', 'Finance and Financial Institutions in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 306', 'Nigerian Cultural Patterns and Historical Origins', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship Development', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 312', 'Educational Psychology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 324', 'Advocacy, Laws and Litigations in Special Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 348', 'Educating Children with Speech, Language, Communication and Hearing Disorder', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 322', 'Curriculum Implementation and Instruction', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 316', 'Creativity and Thinking Skills', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 301', 'Study of Event in Space', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 303', 'Social Studies Education and Theories of Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Application', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 411', 'Educational Psychology III', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 425', 'Teaching Practice II (Practicum)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 433', 'Classroom Organization and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 429', 'Vocational and Rehabilitation for Children with Special Needs', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 433', 'Assistive Technology in Special Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 427', 'Counselling Families of Children with Special Needs', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 401', 'Study of Ideas in Space', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 403', 'Social Studies Education Problems and Prospects of Nation Building', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 442', 'Measurement and Evaluation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 442', 'Educating Children with Learning Disability', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 444', 'Early Childhood Special Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 446', 'Total Communication', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDF 448', 'Braille Writing', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SSE 411', 'Contemporary World Issues', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Special Needs Education', '400 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false);
