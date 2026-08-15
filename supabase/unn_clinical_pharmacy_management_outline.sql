-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Pharmaceutical Sciences
-- Department of Clinical Pharmacy and Pharmacy Management
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 23 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- SCOPE AND VERIFICATION: two courses appear on the source page with no course code at all ("Basic Anatomy for Pharmacy Students" and "General Embryology, Teratology and Genetic Anatomy") -- omitted here rather than inventing codes. The page also prints the code CPM 682 twice, for two different titles ("Clinical Pharmacy Clerkship III", 6 units, and "Pharmacotherapeutics III", 3 units) -- a genuine handbook inconsistency, not a transcription error; only the Clerkship III entry is kept here since it is unclear which is the intended code for Pharmacotherapeutics III. SEMESTER: not published on the source page -- every row is stored under semester='first' as a neutral placeholder, not a verified fact. Level is inferred from each code's leading digit.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Clinical Pharmacy and Pharmacy Management';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('CPM 282', 'Neuroanatomy for Pharmacy Students', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 283', 'Histology for Pharmacy Students', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 284', 'Practical Gross Anatomy for Pharmacy Students', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 362', 'Health Psychology and Behavioral Pharmacy', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 461', 'Pharmacy Administration -- Economics', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 462', 'Communication Skills for Pharmacy', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 481', 'Introduction to Clinical Pharmacy', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 483', 'Essentials of Nutrition', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 485', 'Pathophysiology I', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 486', 'Pathophysiology II', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 561', 'Pharmacy Administration -- Management', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 562', 'Introduction to Pharmacoeconomics', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 563', 'Biostatistics', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 564', 'Pharmaceutical Care', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 581', 'Clinical Pharmacokinetics', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 582', 'Clinical Pharmacy Clerkship I', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 583', 'Pharmacotherapeutics I', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 585', 'Pharmacotherapeutics II', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '500 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 651', 'Drug Evaluation and Ethnopharmacology', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '600 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 662', 'Drug Information Services', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '600 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 664', 'Public Health Pharmacy and Pharmacoepidemiology', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '600 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 681', 'Clinical Pharmacy Clerkship II', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '600 Level', 'first', 6, '', '[]'::jsonb, 'Department official website', false),
  ('CPM 682', 'Clinical Pharmacy Clerkship III', 'University of Nigeria, Nsukka', 'Faculty of Pharmaceutical Sciences', 'Clinical Pharmacy and Pharmacy Management', '600 Level', 'first', 6, '', '[]'::jsonb, 'Department official website', false);
