-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Arts
-- Department of Linguistics, Igbo and Other Nigerian Languages
-- =============================================================================
-- Transcribed from the department's own official website (course code, title,
-- credit unit, level and semester for each course). 42 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns (unlike the Faculty of
-- Engineering handbook used elsewhere in this app), so description and
-- topics are left empty here rather than invented -- consistent with how
-- other title-only entries are already stored throughout this app.
--
-- Scope: the core B.A. Linguistics (single-honours, four-year) track. The department also runs combined programmes (Linguistics and Igbo Studies, Linguistics and Ibibio Studies, Linguistics and Hausa Studies) and a three-year direct-entry variant, published on the same page, which are out of scope for this app. This department's own published list also does not include the university-wide GSP ancillary courses that other Faculty of Arts departments list explicitly, so none are added here by guesswork.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Linguistics, Igbo and Other Nigerian Languages';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('LIN 101', 'Introduction to Language and Climate Change I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 121', 'Elements of Linguistics and Publishing I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 141', 'Introduction to Linguistics I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 143', 'Introduction to General Phonetics I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 181', 'History of Linguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 102', 'Introduction to Language and Climate Change II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 122', 'Elements of Linguistics and Publishing II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 142', 'Introduction to Linguistics II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 144', 'Introduction to General Phonetics II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 182', 'Languages of the World', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 211', 'Introduction to Literature and Climate Change I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 241', 'Introduction to Phonology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 243', 'Phonetics of English and Nigerian Languages', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 245', 'Introduction to Morphology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 261', 'Introduction to Translation and Interpreting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 281', 'Writing Systems: Graphic Representations', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 212', 'Literature and Climate Change II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 242', 'Phonemic Analysis', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 246', 'Morphology of African Languages', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 282', 'Orthography Design', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 333', 'Introduction to Editing and Publishing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 341', 'Introduction to Syntax', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 343', 'Generative Phonology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 347', 'Linguistics and the Study of Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 361', 'Survey of Applied Linguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 381', 'Introduction to African Linguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 322', 'Linguistics and Broadcasting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 342', 'Generative Syntax II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 352', 'Introduction to Sociolinguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 360', 'Introduction to Translation and Interpreting', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 362', 'Error/Contrastive Analysis', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 390', 'Field Method and Research Methodology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 441', 'Semantics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 453', 'Dialectology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 457', 'Problems of a Multilingual Nation', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 461', 'Computational and Lexicographic Linguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 481', 'Historical and Comparative Linguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 442', 'Topics in Phonology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 444', 'Topics in Syntax', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 462', 'Theory and Practice of Translation', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 470', 'Psycholinguistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Linguistics, Igbo and Other Nigerian Languages', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false);
