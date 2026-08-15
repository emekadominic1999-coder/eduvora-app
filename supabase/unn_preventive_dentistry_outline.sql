-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Dentistry
-- Department of Preventive Dentistry
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 16 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- SEMESTER: the source page does not specify semester or level for any course -- level here is inferred from each code's leading digit; every row is stored under semester='first' as a neutral placeholder, not a verified fact.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Preventive Dentistry';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('PVD 422', 'Oral Medicine and Therapeutics I', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 424', 'Oral Diagnosis and Dental Radiology I', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 521', 'Oral Medicine and Therapeutics II', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 523', 'Oral Diagnosis and Dental Radiology II', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 525', 'Periodontology I', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 522', 'Oral Medicine and Therapeutics III', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 524', 'Oral Diagnosis and Dental Radiology III', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 526', 'Periodontology II', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 528', 'Community and Preventive Dentistry I', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 621', 'Oral Medicine and Therapeutics IV', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 623', 'Periodontology III', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 625', 'Community and Preventive Dentistry II', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 627', 'Medical/Dental Ethics and Jurisprudence', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 622', 'Oral Medicine and Therapeutics V', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 628', 'Community and Preventive Dentistry III', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PVD 626', 'Research Project', 'University of Nigeria, Nsukka', 'Faculty of Dentistry', 'Preventive Dentistry', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false);
