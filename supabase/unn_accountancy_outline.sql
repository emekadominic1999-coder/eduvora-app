-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Business Administration
-- Department of Accountancy
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 65 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- Scope: the B.Sc undergraduate programme (100-400 Level) only. The department also runs PGD, MBA, MSc and PhD programmes, published on the same page, which are out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Accountancy';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('ACC 101', 'Elements of Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 103', 'Business Mathematics I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 101', 'Elements of Business Economics I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 101', 'Introduction to Finance', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PHL 101', 'Introduction to Logic and Philosophy', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PSY 101', 'Introduction to Psychology', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 102', 'Elements of Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 102', 'Elements of Business Economics II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 104', 'Business Mathematics II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 106', 'Introduction to Business', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PHIL 102', 'History and Philosophy of Science', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'The Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 201', 'Introduction to Financial Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 211', 'Cost and Management Accounting', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MKT 201', 'Elements of Marketing', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 201', 'Elements of Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 231', 'Business Statistics I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 241', 'Economics: Microeconomic Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Social Sciences I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 207', 'Humanities I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 202', 'Introduction to Financial Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 222', 'Production Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 232', 'Business Statistics II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 242', 'Business Macroeconomic Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MKT 222', 'Business Communication', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 222', 'Principles of Insurance', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Applications', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Social Sciences II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 208', 'Humanities II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 301', 'Financial Accounting III', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 311', 'Cost Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 331', 'Taxation', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 351', 'Fundamentals of Government Accounting System', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 361', 'Quantitative Techniques in Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 311', 'Monetary Theory and Policy', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 331', 'Financial Management I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 383', 'Public Finance and Taxation I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship Development', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 302', 'Financial Accounting IV', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 312', 'Cost Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 362', 'Quantitative Techniques in Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 372', 'Research Methods', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LAW 212', 'Basic Business Law I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 332', 'Financial Management (Advanced)', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 384', 'Public Finance and Taxation II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 352', 'Government and Business', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 401', 'Advanced Financial Accounting V', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 403', 'International Accounting', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 411', 'Management Accounting I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 421', 'Auditing and Investigation I', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 451', 'Public Sector Accounting', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 405', 'General Business Policy', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BAF 451', 'Capital Markets and Portfolio Theory', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 402', 'Advanced Financial Accounting VI', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 412', 'Management Accounting II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 422', 'Auditing and Investigation II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 432', 'Taxation II', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 442', 'Management Information System', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ACC 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('MAN 432', 'Analyses for Business Decisions', 'University of Nigeria, Nsukka', 'Faculty of Business Administration', 'Accountancy', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false);
