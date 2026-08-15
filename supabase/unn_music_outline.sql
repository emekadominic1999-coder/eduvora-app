-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Arts
-- Department of Music
-- =============================================================================
-- Transcribed from the department's own official website (course code, title,
-- credit unit, level and semester for each course). 76 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns (unlike the Faculty of
-- Engineering handbook used elsewhere in this app), so description and
-- topics are left empty here rather than invented -- consistent with how
-- other title-only entries are already stored throughout this app.
--
-- Note: this department's published course list is entirely MUS-coded major/performance courses; it does not print the university-wide GSP ancillary courses (Use of English, Peace and Conflict Resolution, etc.) that every other Faculty of Arts department lists explicitly, so none are added here by guesswork.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Music';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('MUS 101', 'Music as an Art and Science', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 111', 'Rudiments of Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 121', 'Foundations of Musicianship I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 123', 'Tonal Harmony I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 141', 'African Music: Music and Society I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 143', 'Introduction to Popular Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 161', 'Primary Instrument/Voice I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 163', 'Performance Workshop -- Western Ensembles I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 165', 'Performance Workshop -- African Ensembles I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 167', 'Secondary Instrument I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 122', 'Foundations of Musicianship II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 124', 'Tonal Harmony II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 132', 'Survey of History of Western Music I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 144', 'Popular Music in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 152', 'Basic Keyboard Studies', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 162', 'Primary Instrument II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 164', 'Performance Workshop -- Western Ensembles II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 166', 'Performance Workshop -- African Ensembles II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 168', 'Secondary Instrument II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 201', 'Music Business and Media Practices', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 221', 'Foundations of Musicianship III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 223', 'Tonal Harmony III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 241', 'African Music: Theoretical Studies I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 243', 'African Music: Music and Society II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 251', 'Basic Keyboard Studies II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 261', 'Primary Instrument/Voice III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 263', 'Performance Workshop -- Western Ensembles III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 265', 'Performance Workshop -- African Ensembles III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 267', 'Secondary Instrument III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 202', 'Computer Music Application', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 222', 'Foundations of Musicianship IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 224', 'Tonal Harmony IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 232', 'Western Music before 1750', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 242', 'African Music: Theoretical Studies II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 252', 'Basic Keyboard Studies III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 262', 'Primary Instrument/Voice IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 264', 'Performance Workshop -- Western Ensembles IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 266', 'Performance Workshop -- African Ensembles IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 268', 'Secondary Instrument IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 331', 'Western Music after 1750', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 341', 'African Music: Theoretical Studies III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 343', 'Afro-American Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 351', 'Elementary Keyboard Harmony', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 361', 'Primary Instrument/Voice V', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 363', 'Performance Workshop -- Western Ensembles', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 365', 'Performance Workshop -- African Ensembles V', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 367', 'Secondary Instrument/Voice I', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 381', 'Teaching Methods in Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 302', 'Introduction to Musical Instrument Technology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 322', 'Composition', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 324', 'Conducting and Performance Management', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 326', 'Orchestration', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 342', 'Music of Other Cultures of the World', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 362', 'Primary Instrument/Voice VI', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 364', 'Performance Workshop -- Western Ensembles IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 366', 'Performance Workshop -- African Ensembles IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 368', 'Secondary Instrument/Voice II', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 392', 'Research Method and Preparatory Studies in Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 401', 'Acoustics of Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 421', 'Fugue', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 425', 'Analysis of Tonal Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 427', 'Analysis and Analytical Method for 20th Century Music', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 451', 'Keyboard Harmony and Accompaniment', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 461', 'Primary Instrument/Voice VII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 463', 'Performance Workshop -- Western Ensembles VII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 465', 'Performance Workshop -- African Ensembles VII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 467', 'Secondary Instrument/Voice III', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 471', 'Criticism and Musical Scholarship', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 402', 'Music Technology', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 422', 'Modern Compositional Techniques', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 442', 'African Music: Historiography, Theoretical Issues and Contemporary Development', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 462', 'Primary Instrument/Voice VIII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 464', 'Performance Workshop -- Western Ensembles VIII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 466', 'Performance Workshop -- African Ensembles VIII', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 468', 'Secondary Instrument/Voice IV', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('MUS 490', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Arts', 'Music', '400 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false);
