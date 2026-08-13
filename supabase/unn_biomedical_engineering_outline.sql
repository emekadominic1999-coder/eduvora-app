-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Engineering
-- Department of Biomedical Engineering
-- Five-Year Standard Undergraduate B.Eng Degree Programme
-- =============================================================================
-- Transcribed from Chapter Four, programme A (book pages 65-68) of the Faculty of Engineering handbook.
-- 74 rows covering all ten semesters of the programme.
--
-- VERIFICATION: the handbook prints a "Total Credit Hours" for every semester.
-- Each semester's unit values were re-summed and compared against the printed
-- figure -- 24, None, 24, None, 23, 15, 17, 14 -- and every one reconciles.
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
-- YEAR LABELS vs LEVELS: this chapter labels its tables FIRST..FOURTH YEAR but
-- fills them with 200/300/400/500-level course codes, because the programme's
-- opening year is the faculty-wide common engineering year and is not
-- reprinted here. The labels are therefore mapped FIRST->200 Level,
-- SECOND->300, THIRD->400, FOURTH->500 -- which is exactly what the course
-- codes in each table say. A handful of 100-level-coded courses (EGR 101,
-- GSP 101, GSP 111) are scheduled inside these tables by the department and
-- are recorded against the year they are actually taken in.
--
-- TWO PHOTOGRAPHS ARE CROPPED: the second semester of 200 Level and the second
-- semester of 300 Level both run off the bottom edge of the page photograph.
-- Their printed "TOTAL" lines, and any rows below the last visible one, are not
-- in the source image. Those two semesters therefore carry only the rows that
-- are actually legible and could NOT be checksummed; nothing was extrapolated
-- to fill the gap. Every other semester was checksummed and reconciles.
--
-- FINAL-YEAR ELECTIVES: the handbook prints four elective options and says
-- "Any one (2) courses from the list below not exceeding 4 units should be
-- chosen" -- the source itself is contradictory about whether that is one
-- course or two. All four options are stored with is_elective = true and are
-- excluded from the printed 14-unit total, which reconciles against the five
-- major courses alone.
--
-- A SECOND PROGRAMME EXISTS: this chapter also prints a separate "B. 4-YEAR
-- STANDARD UNDERGRADUATE DEGREE PROGRAMME IN BIOMEDICAL ENGINEERING" on the
-- following pages. Only programme A (the five-year one) is loaded here; the
-- four-year variant is a distinct programme and is not merged into these rows.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Biomedical Engineering';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('BME 203', 'Introduction to Biomedical Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EGR 201', 'Material Science', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 207', 'Advance Mathematics VII', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, 'Elements of linear algebra. Calculus: Elementary differentiation and relevant theorems. Differential equations: Exact equations, methods of solution of second-order ordinary differential equations, partial differential equations, with applications.', '["Elements of linear algebra", "Calculus: Elementary differentiation and relevant theorems", "Differential equations: Exact equations, methods of solution of second-order ordinary differential equations, partial differential equations, with applications"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EGR 101', 'Introduction to Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, 'An overview of engineering as a profession. Historical perspective, Discipline, Rationalization, professional affiliations, professional journey, successful studentship, creativity, roles of science and Technology; Engineering and Society: The role of engineers in nation building, professional impacts of Engineering practice and mitigation measures, professional challenges in Nigeria, historical and professional roles; Basic information on Agricultural and Bioresources Engineering, Professional practice, Sustainable Agricultural production in Nigeria; Introduction to Biomedical Engineering, Scope of biomedical engineering practice: A science perspective of Civil Engineering, corporate personality of Civil Engineering; Civil Engineering professional practice; Basic information on Electrical Engineering, Scope of Electrical Engineering professional practice; Electric power generation in Nigeria; Evolution to Electronic Engineering, Scope of Electronic Engineering Professional practice, practice of Electronic Engineering in Nigeria; Basic information on Mechanical Engineering, Scope of Mechanical Engineering professional practice, practice of Mechanical Engineering in Nigeria; Introduction to Mechatronics Engineering, Scope of Mechatronics engineering practice; Basic information on Metallurgical and Materials Engineering, Scope of Metallurgical and Materials Engineering professional practice, practice of Metallurgical and Materials Engineering.', '["An overview of engineering as a profession. Historical perspective, Discipline, Rationalization, professional affiliations, professional journey, successful studentship, creativity, roles of science and Technology", "Engineering and Society: The role of engineers in nation building, professional impacts of Engineering practice and mitigation measures, professional challenges in Nigeria", "Basic information on Agricultural and Bioresources Engineering; Introduction to Biomedical Engineering", "A science perspective of Civil Engineering, corporate personality and professional practice of Civil Engineering", "Basic information on Electrical Engineering; Electric power generation in Nigeria; Evolution to Electronic Engineering", "Basic information on Mechanical Engineering, Scope and practice of Mechanical Engineering in Nigeria", "Introduction to Mechatronics Engineering; Basic information on Metallurgical and Materials Engineering"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 201', 'Human Physiology I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BCH 201', 'General Biochemistry I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EEE 211', 'Basic Electrical Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EGR 213', 'Material Science Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MEC 211', 'Engineering Drawing I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MEC 261', 'Thermodynamics I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 101', 'Study Skills and Basic Research Methods', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 202', 'Human Physiology II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 206', 'Advanced Mathematics VI', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, 'The programme table prints "Advanced Mathematics VII" against both MTH 206 and MTH 207; quoted as printed. Complex analysis - Elements of the algebra of complex variables, trigonometric, exponential and logarithmic functions. The number system, sequences and series. Vector differentiation and integration.', '["Complex analysis - Elements of the algebra of complex variables, trigonometric, exponential and logarithmic functions", "The number system, sequences and series", "Vector differentiation and integration"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MTH 208', 'Advanced Mathematics VIII', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, 'Elective. Numerical analysis: Linear equations, non-linear equations; finite difference operators. Introduction to linear programming.', '["Numerical analysis: Linear equations, non-linear equations", "Finite difference operators", "Introduction to linear programming"]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BCH 202', 'General Biochemistry II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ECE 272', 'Engineering Computer Programming', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('ECE 262', 'Engineering Computer Programming Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EEE 252', 'Basic Electrical Engineering Laboratory Practice', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('MEC 212', 'Workshop Technology I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 262', 'Biomedical Engineering Laboratory Practice', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 102', 'Basic Grammar and Varieties of Writing', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 202', 'Issues in Peace and Conflict Resolution', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '200 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 301', 'Clinical Deformities and Rehabilitation Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 313', 'Biomedical Instrumentation I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 321', 'Human Biomechanics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 311', 'Biomedical Electronics I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 331', 'Bioengineering Materials I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 305', 'Introductory Genetics for Biomedical Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 307', 'Introduction to Bio-fluid Mechanics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 361', 'Cell and Biomaterial Engineering Laboratory II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 303', 'Statistics for Healthcare Professionals', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 111', 'The Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 201', 'Basic Concepts and Theories of Peace and Conflicts', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 302', 'Introduction to Bionics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 312', 'Biomedical Electronics II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 314', 'Biomedical Instrumentation II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 316', 'Biomedical Radiation Technology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 332', 'Bioengineering Material II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 304', 'Design Thinking and Innovation', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 362', 'Biomechanics Laboratory', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 1, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 306', 'Technical Report Writing', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EGR 302', 'Engineering Analysis', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '300 Level', 'second', 4, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 411', 'Mechanisms of Biomedical Devices', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 421', 'Health Management Information Systems', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 413', 'Biomedical Equipment Design', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 441', 'Medical Imaging I', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 443', 'Computational Bio-Modeling and Visualization', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 423', 'Micro-electronics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 445', 'Engineering Models in Physiology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 401', 'Applied Nanoscience and Nanotechnology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EGR 401', 'Computational Methods', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('GSP 207', 'Logic, Philosophy and Human Existence', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 482', 'Seminar', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 484', 'Special Topics in Biomedical Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'second', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('EGR 402', 'Students Industrial Work Experience Scheme (SIWES)', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '400 Level', 'second', 10, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 501', 'Biomaterial Host Interactions in Regenerative Medicine', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 511', 'Biomedical Devices Development and 3D Manufacturing Processes', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 541', 'Biomedical Signals and Systems', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 513', 'Biomedical Telemetry', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 543', 'Biomedical Informatics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 533', 'Biological Transport and Drug Delivery', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 531', 'Genetic and Tissue Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 3, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 535', 'Precision Medicine for Biomedical Engineers', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'first', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 522', 'Cardiovascular Mechanics', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 542', 'Medical Imaging II', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 532', 'Stem Cell Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 524', 'Dental Material Science', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 592', 'Project', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 6, '', '[]'::jsonb, 'Faculty of Engineering handbook', false),
  ('BME 514', 'Surgery for Engineers', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('BME 512', 'Equipment Reliability and Safety Technology', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('BME 526', 'Advanced/Additive Manufacturing Engineering', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', true),
  ('BME 544', 'Computer-Aided Design of Biomedical Equipment', 'University of Nigeria, Nsukka', 'Faculty of Engineering', 'Biomedical Engineering', '500 Level', 'second', 2, '', '[]'::jsonb, 'Faculty of Engineering handbook', true);
