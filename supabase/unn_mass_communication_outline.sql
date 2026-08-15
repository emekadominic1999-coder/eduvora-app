-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Arts
-- Department of Mass Communication
-- =============================================================================
-- Transcribed from the department's own official website (course code, title,
-- credit unit, level and semester for each course). 63 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns (unlike the Faculty of
-- Engineering handbook used elsewhere in this app), so description and
-- topics are left empty here rather than invented -- consistent with how
-- other title-only entries are already stored throughout this app.
--
-- Scope: undergraduate B.Sc. programme only (100-400 Level). The department also runs PGD/M.A./Ph.D programmes, published on the same page, which are out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Mass Communication';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('MAC 101', 'Introduction to Mass Communication', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 4, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 103', 'History of the Nigerian Mass Media', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 111', 'Elements of Journalistic Style', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'Communication in English I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 111', 'The Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 207', 'Logic, Philosophy and Human Existence', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PHI 101', 'Introduction to Philosophy I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL 114', 'Nigerian Legal System I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 102', 'African Communication Systems', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 112', 'Writing for the Mass Media', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 132', 'Typesetting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'Communication in English II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 208', 'Nigerian Peoples and Culture', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PHI 102', 'Introduction to Philosophy II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL 115', 'Nigerian Legal System II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 201', 'Theories of Mass Communication', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 203', 'Reporting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 205', 'Graphics of Mass Communication', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 211', 'Critical and Review Writing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 221', 'Announcing and Performance', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 241', 'Principles of Public Relations', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 261', 'Introduction to Film', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Peace and Conflict Resolution I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 202', 'Media and Society', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 204', 'Information and Communication Technologies', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 212', 'News Writing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 222', 'Principles of Broadcasting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 242', 'Principles of Advertising', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 252', 'Media Attachment', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Peace and Conflict Resolution II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 301', 'Development Journalism', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 311', 'Feature and Interpretative Writing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 313', 'Magazine Article Writing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 321', 'Radio/TV Programme Writing and Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 331', 'News Editing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 333', 'Fundamentals of Book Publishing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 361', 'Photojournalism', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 302', 'Specialised Reporting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 312', 'Editorial Writing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 322', 'Broadcast Programming', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 332', 'Newspaper Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 334', 'Magazine Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 352', 'Media Attachment', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 382', 'Introduction to Mass Communication Research', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 384', 'Advertising and Public Relations Research', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Applications', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 401', 'Mass Communication Law and Ethics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 403', 'International Communication', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 421', 'Advanced Radio/TV Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 431', 'Advanced Newspaper Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 433', 'Advanced Magazine Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 435', 'Print Seminar', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 441', 'Advanced Public Relations', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 402', 'Media Management', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 422', 'Broadcast Seminar', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 442', 'Advanced Advertising', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 462', 'Documentary Film Production', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Mass Communication', '400 Level', 'second', 6, '', '[]'::jsonb, 'Department official website', false);
