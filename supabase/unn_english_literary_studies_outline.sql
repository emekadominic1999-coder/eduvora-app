-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Arts
-- Department of English and Literary Studies
-- =============================================================================
-- Transcribed from the department's own official website (course code, title,
-- credit unit, level and semester for each course). 93 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns (unlike the Faculty of
-- Engineering handbook used elsewhere in this app), so description and
-- topics are left empty here rather than invented -- consistent with how
-- other title-only entries are already stored throughout this app.
--
-- Scope: the Four-Year Standard Programme. The department also runs a Three-Year Standard Programme (direct-entry) and Combined Honours tracks (English/French, English/German, English/History, English/Theatre and Film Studies), published on the same page, which are out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'English and Literary Studies';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('ELS 101', 'Basic Literary Concepts', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 103', 'Introduction to African Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 121', 'Basic Grammar and Composition', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 123', 'Introduction to Phonetics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 131', 'Introduction to Oral Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 141', 'Introduction to General Linguistics I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'The Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Basic Concepts and Theories of Peace and Conflict Resolution', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 101', 'Elementary French I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 101', 'Elementary German I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('IGB 101', 'Elementary Igbo I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POR 111', 'Portuguese Grammar I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 101', 'Elementary Russian I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SPA 111', 'Spanish Grammar I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SWA 111', 'Swahili Grammar I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 102', 'Introduction to Nigerian Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 140', 'Introduction to Drama', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 150', 'Introduction to Poetry', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 160', 'Introduction to Fiction', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('LIN 140', 'Introduction to General Linguistics II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'The Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Issues in Peace and Conflict Resolution', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 102', 'Elementary French II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 102', 'Elementary German II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('IGB 102', 'Elementary Igbo II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POR 112', 'Portuguese Grammar II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 102', 'Elementary Russian II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SPA 112', 'Spanish Grammar II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SWA 112', 'Swahili Grammar II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 211', 'American Literature: Colonial to Romantic Eras', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 213', 'English Literature: The Renaissance Period', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 221', 'Spoken English/Lab Work', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 201', 'Intermediate French I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 201', 'Intermediate German I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('IGB 201', 'Intermediate Igbo I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POR 211', 'Portuguese Grammatical Structures I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 201', 'Intermediate Russian I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SPA 211', 'Spanish Grammatical Structures I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SWA 211', 'Swahili Grammatical Structures I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 212', 'American Literature: 1855 to Early 20th Century', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 214', 'English Literature: Neo-Classical Period', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 222', 'Intermediate English Grammar and Composition', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 240', 'Comedy: Moliere to Soyinka', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Applications', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('FRE 202', 'Intermediate French II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GER 202', 'Intermediate German II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('IGB 202', 'Intermediate Igbo II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('POR 212', 'Portuguese Grammatical Structures II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('RUS 202', 'Intermediate Russian II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('SPA 212', 'Spanish Grammatical Structures II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('SWA 212', 'Swahili Grammatical Structures II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 311', 'English Literature: Romantic Movement', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 321', 'Advanced Prose Composition', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 351', 'African Poetry', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 361', 'African Fiction', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 381', 'Research Methods', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 325', 'Semantics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 331', 'African Traditional Verbal Genres', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 313', 'Greek and Roman Literatures', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 312', 'English Literature: Victorian Period', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 314', 'English Literature: Modern Period', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 340', 'African Drama', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 370', 'History of Criticism', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 322', 'History of English', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 324', 'Phonology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 332', 'The Criticism of Oral Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 334', 'Oral Narratives', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 316', 'Old and Middle English Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 372', 'Theory and Practice of Narrative', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 310', 'Contemporary African Authors', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 411', 'African-American Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 413', 'European Continental Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 425', 'Stylistics', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 461', 'Studies in Fiction', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 421', 'Morphology and Syntax', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 423', 'Comparative Grammar', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 471', 'Modern Literary Theory', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 473', 'Modern Discourse Analysis', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 415', 'World Black Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 431', 'Oral Literature and Modern Literature in Africa', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 440', 'Shakespeare', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 442', 'Studies in Drama', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 452', 'Studies in Poetry', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 6, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 418', 'Caribbean Literature', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 444', 'European Drama since Ibsen', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 422', 'Problems of English in West Africa', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ELS 480', 'Literary Review Writing', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'English and Literary Studies', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false);
