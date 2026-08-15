-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Pharmaceutical Sciences
-- Department of Pharmaceutical and Medicinal Chemistry
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 15 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- Part of the Pharm.D programme. The source page groups courses only by "First Semester" / "Second Semester" across the whole programme, not by year -- level here is inferred from each code's leading digit to place each course at the right year.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Pharmaceutical and Medicinal Chemistry';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('PCH 231', 'Physical Pharmaceutical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 232', 'Inorganic Pharmaceutical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 234', 'Practical Pharmaceutical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 331', 'Organic Pharmaceutical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 333', 'Practical Organic Pharmaceutical Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 332', 'Pharmaceutical Analysis I', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 334', 'Practical Pharmaceutical Analysis', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '300 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 431', 'Instrumental Methods of Pharmaceutical Analysis', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 433', 'Practical Pharmaceutical Analysis', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 432', 'Medicinal Chemistry I (Drug Design)', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 531', 'Medicinal Chemistry II', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 533', 'Natural Products Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 532', 'Drug Quality Assurance', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '500 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 534', 'Practical Drug Quality Assurance', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '500 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PCH 631', 'Radiopharmacy', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Pharmaceutical and Medicinal Chemistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false);
