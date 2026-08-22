-- =============================================================================
-- Follow-up to fix_cos101_faculty_and_relevance_leak.sql: the user asked for
-- the faculty-tag gap to be checked "all around", not just COS101/COS201.
-- Audited every CBT subject's faculty tag against the real course_outlines
-- data (cross-referencing course_code) and found 3 more subjects with
-- departments missing from their tag -- meaning students in those
-- departments couldn't see a paper their own course outline requires.
-- =============================================================================

-- COS101: also required by Business Administration, Environmental Studies,
-- Education, and Veterinary Medicine per course_outlines, not tagged.
update public.cbt_questions
   set faculty = 'Faculty of Physical Sciences, Faculty of Agriculture, Faculty of Biological Sciences, Faculty of Social Sciences, Faculty of Arts, Faculty of Business Administration, Faculty of Environmental Studies, Faculty of Education, Faculty of Veterinary Medicine'
 where subject_id = 'cos-101-intro-computing';

-- COS201: also required by Environmental Studies (Geoinformatics and Surveying).
update public.cbt_questions
   set faculty = 'Faculty of Physical Sciences, Faculty of Agriculture, Faculty of Environmental Studies'
 where subject_id = 'cos-201-java-programming';

-- MTH102: also required by Environmental Studies (Geoinformatics and Surveying).
update public.cbt_questions
   set faculty = 'Faculty of Physical Sciences, Faculty of Engineering, Faculty of Social Sciences, Faculty of Environmental Studies'
 where subject_id = 'mth-102-vectors-geometry-dynamics';

-- MTH103: also required by Environmental Studies (Geoinformatics and Surveying,
-- Urban and Regional Planning).
update public.cbt_questions
   set faculty = 'Faculty of Physical Sciences, Faculty of Engineering, Faculty of Biological Sciences, Faculty of Social Sciences, Faculty of Environmental Studies'
 where subject_id = 'mth-103-calculus';

-- Every other CBT subject (COS/MTH/PHY banks) was audited the same way and
-- already matches course_outlines exactly -- no over- or under-visibility.
