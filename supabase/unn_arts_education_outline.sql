-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Arts Education
-- =============================================================================
-- Transcribed from the department's own official website. 74 rows.
--
-- UNITS AND SEMESTER: this department's course-modules page publishes only
-- course code and title, grouped into "General Studies", "Core/Compulsory
-- Ed." and "Fine & Applied Arts, Music, Theatre Arts" categories -- it does
-- NOT publish credit units or a semester breakdown for any course. Level is
-- inferred from each code's leading digit (a reliable Nigerian course-coding
-- convention); every row's credit_units is stored as 0 (unknown, not a real
-- value) and semester as 'first' (a neutral placeholder). Cross-checking the
-- ED-prefix codes against Educational Foundations' own page (which DOES
-- publish units) found a genuine title mismatch for the same code -- ED 221
-- is "Curriculum Theory and Development" there vs "Curriculum Theory and
-- Planning" here -- so no units were borrowed across departments; that would
-- risk attaching a wrong number to a course that only shares a code number,
-- not necessarily the same content.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Arts Education';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Sciences I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Sciences II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'The Social Sciences', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Issues in Peace and Conflict Resolution Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 102', 'History of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 201', 'Philosophy of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 205', 'Sociology of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 211', 'Educational Psychology I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 221', 'Curriculum Theory and Planning', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 222', 'Special Methods', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 224', 'Educational Technology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 311', 'Educational Psychology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 321', 'Curriculum Implementation and Instruction', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 325', 'Teaching Practice I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 341', 'Research Method and Statistics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 411', 'Educational Psychology III', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 425', 'Teaching Practice II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 433', 'Classroom Organization and Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 441', 'Measurement and Evaluation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ED 451', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 101', 'Introduction to Creative Arts Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 103', 'Introduction to Creative Designs I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 104', 'Introduction to Creative Designs II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 146', 'Three Dimensional Designs in Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 211', 'Festivals in Different Cultures', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 231', 'Music in Ceremonies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 232', 'Composition of Choreographic Dances and Occupational Rhythms', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 242', 'Three Dimensional Representations of Historical Objects', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 272', 'Local Resources in Craft Production', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 332', 'Music in Occupations', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 341', 'Nigerian Folk Arts and Crafts', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 342', 'Nigerian Indigenous Arts', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 361', 'Dramatic Representations in Festival Events', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 364', 'Performance Workshop VI', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 372', 'Crafts and Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 424', 'Theories of Language Teaching', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 441', 'Nigerian Masks', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 442', 'Nigerian Museums', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 447', 'Moral Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 452', 'Teaching Children''s Literature', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('EDA 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 101', 'Introduction to Drama and Theatre', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 102', 'Practice Participation Orientation', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 130', 'Basic Acting Skills', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 221', 'Basic Costume and Make-up Design', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 231', 'Basic Verbal Communication', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 250', 'Fundamentals of Playwriting', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 260', 'Children''s Theatre Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 301', 'Modern African Drama and Theatre', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 304', 'Basic Choreography and Kinaesthetic', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 341', 'Introduction to Directing', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('TFS 411', 'Theories of Dramatic Criticism', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('THA 412', 'Studies in Dramatic Literature', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 141', 'African Music and Society I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 161', 'Primary Instrument Study I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 164', 'Performance Workshop II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 243', 'African Music and Society II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 261', 'Primary Instrument Study II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 264', 'Performance Workshop IV', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 323', 'Composition', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 324', 'Conducting and Performance Management', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 361', 'Primary Instrument Study III', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 461', 'Primary Instrument Study IV', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 464', 'Performance Workshop VIII', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 121', 'Basic English Grammar and Composition', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 131', 'Introduction to Oral Literature', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '100 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 201', 'Still-Life Drawing', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 202', 'Figure Drawing', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 231', 'Painting Composition', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '200 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 301', 'Draughtsmanship I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 302', 'Draughtsmanship II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '300 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 401', 'Advanced Drawing I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('FAA 402', 'Advanced Drawing II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Arts Education', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false);
