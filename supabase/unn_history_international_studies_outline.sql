-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Arts
-- Department of History and International Studies
-- =============================================================================
-- Transcribed from the department's own official website (course code, title,
-- credit unit, level and semester for each course). 80 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns (unlike the Faculty of
-- Engineering handbook used elsewhere in this app), so description and
-- topics are left empty here rather than invented -- consistent with how
-- other title-only entries are already stored throughout this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'History and International Studies';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('HIS 101', 'Introduction to History', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 103', 'Introduction to International Studies', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 111', 'Nigeria up to 1900', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 121', 'Africa, 1500 to 1800', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 131', 'Europe to the French Revolution', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ARCHY 101', 'Fundamentals of Archaeology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 103', 'Social Science I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 101', 'Introduction to Political Science I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('M C 101', 'Introduction to Mass Communication I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 102', 'Introduction to Economic History', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 104', 'Evolution of International System since 1915', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 122', 'History of West Africa since 1500', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 124', 'Religion in West Africa', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 126', 'North Africa from Earliest Times to Arab Conquest', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 132', 'Europe from French Revolution to WWII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 144', 'Blacks in Diaspora', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'The Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 104', 'Social Science II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 102', 'Introduction to Political Science II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('M C 102', 'Introduction to Mass Communication II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 213', 'Diplomatic History of Nigeria since 1960', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 221', 'Southern Africa since 1400', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 223', 'East and Central Africa since 1000 AD', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 231', 'Russia, 1800 to 1917', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 233', 'Europe from WWII to Present', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 251', 'South East Asia since 19th Century', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 101', 'Elementary French I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 101', 'Elementary German I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 101', 'Elementary Russian I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Peace and Conflict Resolution Studies I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 205', 'Comparative World Revolutions since 1900', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 231', 'Principles of Public Administration', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 206', 'Political Thought', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 222', 'Africa and European Imperialism (19th-20th C.)', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 224', 'Economic History of West Africa to 20th C.', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 226', 'African Women in History', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 242', 'Latin America since 15th Century', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 244', 'U.S.A., 1607 to 1865', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 102', 'Elementary French II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 102', 'Elementary German II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 102', 'Elementary Russian II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Peace and Conflict Resolution Studies II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 241', 'Fundamentals of Political Economy', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 251', 'Political Ideas', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 301', 'Comparative Industrial Growth (USA, Russia, Japan, China, Britain)', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 311', 'Nigeria, 1900 to 1960', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 321', 'Africa and Wider World in 20th Century', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 343', 'U.S.A. since 1865', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 361', 'Historiography', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 201', 'Intermediate French I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 201', 'Intermediate German I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 201', 'Intermediate Russian I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CEDR 341', 'Entrepreneurial Development and Research', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 302', 'Issues in International Relations I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 322', 'Problems and Prospects of Regional Economic Development in Africa', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 332', 'Russia since 1917', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 352', 'Japan from Tokugawa to Meiji Restoration', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 202', 'Intermediate French II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 202', 'Intermediate German II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 202', 'Intermediate Russian II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CS 304', 'Computer in Sectoral Application', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CEDR 342', 'Entrepreneurial Development and Research', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 321', 'Theories of International Relations', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('POL SC 322', 'Politics of International Economic Relations', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 401', 'Development of Parliamentary/Presidential Systems (Britain, France, India, USA)', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 403', 'History of Science and Technology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 411', 'Nigeria since 1960', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 413', 'Economic History of Nigeria since 1800', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 415', 'Igboland to the Present', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 451', 'Contemporary Middle East', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 402', 'Issues in International Relations II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 404', 'Philosophy of History', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 406', 'Conflict, War and Peace since 1900', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 408', 'International/Continental Organizations (Commonwealth, OAU/AU, Arab League, ASEAN, EU, OAS)', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 422', 'Africa since 1800', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HIS 462', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'History and International Studies', '400 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false);
