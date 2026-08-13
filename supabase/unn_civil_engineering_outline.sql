-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Engineering
-- Department of Civil Engineering
-- Five-Year Standard Undergraduate B.Eng Degree Programme
-- =============================================================================
-- Transcribed from Chapter Five (book pages 89-93) of the Faculty of Engineering handbook.
-- 83 rows covering the full programme.
--
-- VERIFICATION: the handbook prints a "Total Credit Hours" for every semester.
-- Each semester's unit values were re-summed and compared against the printed
-- figure -- 19, 17, 19, 18, 18, 18, 18, 18, 18, 18 -- and every one of those reconciles.
-- That check is what makes the units column trustworthy: this handbook
-- right-aligns units, so a value can sit visually against the wrong row, and
-- the printed totals are what pin them back down. Where a semester offers an
-- elective group, only the units a student actually takes are counted toward
-- the total, matching how the handbook totals it.
--
-- DESCRIPTIONS: shared ancillary courses reuse the description already held
-- for that same course code elsewhere in this app, rather than getting freshly
-- invented prose -- a shared course must read identically across every
-- department that lists it. Department-specific courses carry an empty
-- description here: their text lives in the handbook's separate detailed
-- course-description section and is a follow-up pass rather than a guess.
--
-- A UNIT VALUE IS MISSING FROM THE SOURCE: in 400 Level first semester,
-- CVE 423 (Water Resources and Environmental Engineering I) is printed with no
-- credit-unit value at all, and the semester's printed total of 18 is exactly
-- the sum of the other eight rows. So the handbook itself omits it rather than
-- the photograph losing it. CVE 423 is stored with credit_units = 0, the
-- sentinel this project already uses for "the source does not state it" --
-- it is NOT a claim that the course is worth zero units, and no plausible
-- value was invented to paper over the gap.
--
-- FIFTH-YEAR OPTIONS: the second semester lists three major courses (14 units)
-- followed by "And any one of the following optional courses" -- six 4-unit
-- options. All six are flagged is_elective and the checksum counts 14 + one
-- 4-unit option = 18, which is how the handbook reaches its printed total.
--
-- SERVICE COURSES: CVE 336, CVE 433, CVE 422 and CVE 552 are taught BY this
-- department FOR Estate Management and the Faculty of Environmental Studies.
-- They are not part of the Civil Engineering degree load, so they are flagged
-- is_elective, carry the target audience in their titles, and are excluded
-- from every semester checksum. Their level comes from the course code; the
-- handbook states no semester for them.
--
-- A FOUR-YEAR ROUTE EXISTS: the second-year table is annotated "(Four-year
-- programme starts here)", i.e. direct-entry students join at 200 Level. The
-- rows here are the full five-year programme; the handbook also notes that
-- GSP 101 and GSP 102 are "for Direct Entry Students only".
--
-- THIS CHAPTER USES ITS OWN CODE SCHEME: Civil writes ENG 101/102/201/301/401
-- where other departments write EGR, EPE where others write EEE, MTH 112/113
-- where others write MTH 121/122, and PHY 107/109/192/105 where others write
-- PHY 121/124/195/116. Two GSP slots are printed as combined codes
-- ("GSP 207/101", "GSP 208/102") and are recorded exactly as printed.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Civil Engineering';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('ENG 101', 'Introduction to Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 111', 'Elementary Mathematics I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 3, 'Elementary set theory, subsets, union, intersection, complements. Venn diagrams, real numbers, integers, rational and irrational numbers, mathematical induction, real sequences and series, theory of quadratic equations, binomial theorem. Circular measure, trigonometric functions of angles of any magnitude, addition and factor formulae. Complex numbers, algebra of complex numbers, the Argand diagram, De Moivre''s theorem, nth roots of unity.', '["Elementary set theory, subsets, union, intersection, complements", "Venn diagrams, real numbers, integers, rational and irrational numbers, mathematical induction, real sequences and series, theory of quadratic equations, binomial theorem", "Circular measure, trigonometric functions of angles of any magnitude, addition and factor formulae", "Complex numbers, algebra of complex numbers, the Argand diagram, De Moivre''s theorem, nth roots of unity"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 112', 'Elementary Mathematics II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CHM 101', 'Basic Principles of Chemistry I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 2, 'Stoichiometry and Atomic Structure: Stoichiometry and mole concept. Introduction to atomic structure, development of electronic configuration of the elements, and valency theories. Periodic Table and Groups: The periodic classification of elements. Brief group study of representative elements, with emphasis on similarities and differences based on periodic position. Nuclear Chemistry: Radioactivity and its practical applications.', '["Stoichiometry and Atomic Structure: Stoichiometry and mole concept. Introduction to atomic structure, development of electronic configuration of the elements, and valency theories", "Periodic Table and Groups: The periodic classification of elements. Brief group study of representative elements, with emphasis on similarities and differences based on periodic position", "Nuclear Chemistry: Radioactivity and its practical applications"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CHM 171', 'Basic Practical of Chemistry', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 2, 'Laboratory operations: theory and practice of simple volumetric and quantitative analysis, simple organic preparations, functional group reactions, and physical chemistry determinations.', '["Laboratory operations: theory and practice of simple volumetric and quantitative analysis, simple organic preparations, functional group reactions, and physical chemistry determinations"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('PHY 107', 'Fundamentals of Physics I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('PHY 192', 'Practical Physics II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 101', 'Use of English', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ENG 102', 'Applied Mechanics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 113', 'Elementary Mathematics III', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CHM 111', 'Basic Principles of Chemistry II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CHM 121', 'Basic Principles of Chemistry III', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('PHY 105', 'General Physics for Physical Sciences II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('PHY 109', 'Fundamentals of Physics III', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 101', 'Use of English (Cont’d)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '100 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 211', 'Strength of Materials I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 212', 'Strength of Materials Laboratory I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ENG 201', 'Materials Science', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ENG 202', 'Material Science Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MEC 221', 'Engineering Drawing', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MEC 261', 'Thermodynamics and Heat Engines', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EPE 211', 'Basic Electrical Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 206', 'Advanced Mathematics VI', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, 'The programme table prints "Advanced Mathematics VII" against both MTH 206 and MTH 207; quoted as printed. Complex analysis - Elements of the algebra of complex variables, trigonometric, exponential and logarithmic functions. The number system, sequences and series. Vector differentiation and integration.', '["Complex analysis - Elements of the algebra of complex variables, trigonometric, exponential and logarithmic functions", "The number system, sequences and series", "Vector differentiation and integration"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 103', 'Social Science I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 207/101', 'Humanities I/Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 221', 'Fluid Mechanics I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 2, 'Elective. The programme table''s left edge is cut off by the book''s binding, printing only "E 221" for this code; CVE 221 (Civil Engineering) is used as the closest plausible match for a Fluid Mechanics elective, but this is not independently confirmed.', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 222', 'Fluid Mechanics Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MEC 211', 'Workshop Technology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ECE 271', 'Engineering Computer Programming', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ECE 281', 'Engineering Computer Programming Lab.', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EPE 251', 'Basic Electrical Engineering Lab./Practice', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 205', 'Advanced Mathematics V', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 207', 'Advanced Mathematics VII', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 2, 'Elements of linear algebra. Calculus: Elementary differentiation and relevant theorems. Differential equations: Exact equations, methods of solution of second-order ordinary differential equations, partial differential equations, with applications.', '["Elements of linear algebra", "Calculus: Elementary differentiation and relevant theorems", "Differential equations: Exact equations, methods of solution of second-order ordinary differential equations, partial differential equations, with applications"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 104', 'Social Science II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 208/102', 'Humanities II/Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 311', 'Strength of Materials II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 321', 'Fluid Mechanics II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 322', 'Water Resources and Environmental Engineering Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 331', 'Civil Engineering Materials', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 351', 'Engineering Surveys I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 332', 'Materials Testing', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 341', 'Engineering Geology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('STA 205', 'Statistics for Physical Science and Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 312', 'Theory of Structures I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 313', 'Strength of Materials Laboratory II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 323', 'Hydrology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 352', 'Engineering Surveys Practice I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 335', 'Civil Engineering Drawing', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 342', 'Soil Mechanics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ENG 301', 'Engineering Analysis', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 411', 'Theory of Structures II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 412', 'Reinforced Concrete Design', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 413', 'Steel and Timber Design', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 414', 'Structural Design Studio I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 423', 'Water Resources and Environmental Engineering I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 0, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 442', 'Soil Mechanics Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 451', 'Engineering Surveys II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 452', 'Transportation Engineering I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ENG 401', 'Computational Methods', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 421', 'Hydraulics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 431', 'Civil Engineering Practice I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 441', 'Foundation Engineering I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 453', 'Engineering Surveys Practice II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ENG 402', 'Students Industrial Work Experience Scheme (SIWES)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'second', 10, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 511', 'Structural Analysis I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 512', 'Structural Design', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 513', 'Structural Design Studio II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 521', 'Water Resources and Environmental Engineering II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 541', 'Foundation Engineering II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 542', 'Foundation Design Studio', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 531', 'Civil Engineering Practice II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 551', 'Transportation Engineering II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 561', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 6, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CVE 514', 'Structural Analysis II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 522', 'Water Resources and Environmental Engineering III', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 532', 'Properties and Behaviour of Concrete', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 533', 'Building Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 543', 'Geotechnical Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 553', 'Transportation Engineering III', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 336', 'Building Construction I (for Estate Management)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '300 Level', 'first', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 433', 'Building Construction II (for Estate Management)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 422', 'Environmental Health Engineering (for Faculty of Environmental Studies)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('CVE 552', 'Highway and Traffic Engineering (for Faculty of Environmental Studies)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Civil Engineering', '500 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', true);
