-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Science Education
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 71 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- Scope: the 4-Year Integrated Science Education programme. The department also runs Biology Education and Chemistry Education programmes (each with 4-year and 3-year variants), published on the same page, which are out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Science Education';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('EDU 103', 'History of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SED 101', 'Foundation of Science Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 131', 'Introduction to Integrated Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 133', 'Fundamental Concept of Matter and Energy', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MTH 111', 'Elementary Mathematics I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 111', 'General Physics for Life Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CHM 101', 'Basic Principles of Inorganic Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 151', 'General Biology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 111', 'Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 202', 'Philosophy of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SED 102', 'Introduction to Science Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 132', 'Transformation of Matter', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 134', 'Life Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CHM 112', 'Basic Principles of Physical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 152', 'General Biology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MCB 102', 'Introduction to Microbiology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'The Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 211', 'Educational Psychology I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 221', 'Curriculum Theory and Planning', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SED 201', 'Basic Mathematics for Science Education Students', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 231', 'Science and Society', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 233', 'The Physics of Chemical Systems I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 103', 'General Physics for Engineering and Physical Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MTH 113', 'General Mathematics II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 191', 'Practical Physics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'The Social Sciences', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SED 232', 'Integrated Science Education Special Methods', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 224', 'Educational Technology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 232', 'The Chemistry of Biological Systems I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SED 206', 'Environmental Issues in Science and Technology Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MTH 114', 'General Mathematics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 112', 'Fundamentals of Physics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CHM 122', 'Basic Principles of Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Issues in Peace and Conflict Resolution', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 311', 'Educational Psychology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 325', 'Teaching Practice I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 341', 'Research Methods, Statistics and Computer Usage', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 331', 'Introduction to Biogeography', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 337', 'Space Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SED 301', 'Computer Based Instruction, Simulation and Animation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CHM 201', 'General Inorganic Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 351', 'General Genetics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 207', 'Humanities I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 206', 'Sociology of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 322', 'Curriculum Implementation and Instruction', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 324', 'Pre-School Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SED 302', 'Science Education for Special Needs Learners', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 332', 'Introduction to Biophysics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 334', 'The Chemistry of Biological Systems II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GEO 104', 'Applied Geology for Environmental and Physical Sciences', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Applications', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 208', 'Humanities II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 411', 'Educational Psychology III', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 425', 'Teaching Practice II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 431', 'Classroom Organisation and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 431', 'Energy Sources and Transformation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 437', 'Workshop Practice', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 433', 'Environmental Pollution', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ZEB 303', 'Laboratory Techniques', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ZEB 351', 'Climate Change and Animal Biodiversity', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 432', 'Educational Administration', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 442', 'Measurement and Evaluation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 432', 'Industrial Processes', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 434', 'Analytical Processes', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ITS 436', 'Our Natural Environment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 490', 'Research Project', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('CHM 392', 'Chemical Industry and the Environment', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Science Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false);
