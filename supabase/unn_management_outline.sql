-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Business Administration
-- Department of Management
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 65 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- MAN 473 (Advanced Management Theory) prints no unit value on the source page -- stored as 0 (unknown), not guessed.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Management';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('MAN 101', 'Elements of Business Economics I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 103', 'Business Mathematics I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 101', 'Elementary French I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 101', 'Elements of Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 101', 'Introduction to Finance', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PSY 101', 'Introduction to Psychology I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SOC 101', 'Introduction to Sociology I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 102', 'Elements of Business Economics II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 104', 'Business Mathematics II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 106', 'Introduction to Business', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 102', 'Elementary French II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 102', 'Elements of Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'The Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PSY 102', 'Introduction to Psychology II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SOC 102', 'Introduction to Sociology II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 201', 'Elements of Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 231', 'Business Statistics I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 241', 'Business Microeconomic Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 201', 'Introduction to Financial Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MKT 201', 'Elements of Marketing', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 211', 'Introduction to Cost and Management Accounting', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Social Science I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 207', 'Humanities', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 222', 'Production Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 232', 'Business Statistics II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 242', 'Business Macroeconomic Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 244', 'Labour Economics', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 202', 'Introduction to Financial Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Applications', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Social Science II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 208', 'Humanities', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 311', 'Human Resource Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 331', 'Quantitative Methods for Business', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 361', 'Principles of Small Business Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 371', 'Management Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LAW 211', 'Basic Business Law', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 311', 'Cost Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 311', 'Monetary Theory and Practice', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 331', 'Financial Management I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MKT 351', 'Consumer Behaviour Analysis', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 312', 'Organisational Behaviour', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 352', 'Government and Business', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 354', 'International Business Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 372', 'Business Ethics and Social Responsibilities', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 382', 'Research Methodology', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 312', 'Cost Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 332', 'Financial Management II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 411', 'Industrial Relations', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 461', 'Business Policy', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 463', 'Entrepreneurial Development', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 471', 'Comparative Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 473', 'Advanced Management Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 0, '', '[]'::jsonb, 'Department official website', false),
  ('MKT 401', 'Marketing Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 411', 'Management Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 451', 'Capital Market and Portfolio Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 412', 'Comparative Industrial Relations', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 432', 'Analysis for Business Decisions', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 462', 'Business Policy II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 472', 'Corporate Planning and Strategic Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 492', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'second', 6, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 412', 'Management Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Management', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false);
