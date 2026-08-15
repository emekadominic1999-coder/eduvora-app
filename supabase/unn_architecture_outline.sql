-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Environmental Studies
-- Department of Architecture
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 62 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- The source page titles this the "B.Arch Four-Year Standard Programme", quoted as printed.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Architecture';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('ARC 101', 'Introduction to Architecture 1', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('MAT 111', 'Elementary Mathematics 1', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 104', 'General Physics for Physical Science', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 191', 'Practical Physics', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 111', 'Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 102', 'Introduction to Architecture II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 104', 'Introduction to Applied Arts', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('URP 111', 'Nature of Environmental Science', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 105', 'General Physics for Physical Sciences II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PHY 106', 'General Physics for Physical Sciences III', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAT 112', 'Elementary Mathematics II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 111', 'Use of Library and Study Skills', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 211', 'History of Architecture I', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 221', 'Descriptive Geometry I', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('SVY 201', 'Basic Land Surveying I', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 201', 'Basic Concepts and Theory of Peace', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 207', 'Humanities I', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 233', 'Introduction to Architectural Design', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 212', 'History of Architecture II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 222', 'Descriptive Geometry II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 232', 'Architectural Design II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 262', 'Building Components and Methods II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 264', 'Architectural Structures II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 272', 'Computer Applications in Architecture III', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('SVY 202', 'Basic Land Surveying II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 104', 'Social Science II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 202', 'Issues in Peace and Conflict Resolution Studies', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 208', 'Humanities II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 244', 'Environmental Planning', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 311', 'History of Architecture III', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 321', 'Architectural Presentation Techniques', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 331', 'Architectural Design III', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 4, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 341', 'Building Services I', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 361', 'Building Components and Methods III', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 363', 'Architectural Structures III', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 365', 'Working Drawings / Detailing', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 371', 'Computer Applications in Architecture IV', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('URP 311', 'Rural Development Planning', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('PSY 331', 'Sensory Processes', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 382', 'SIWES Programme', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '300 Level', 'second', 15, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 413', 'Problem Analysis in Architecture', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 411', 'Building Quantities and Costing', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 431', 'Architectural Design IV', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 4, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 441', 'Building Climatology', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 443', 'Building Services II', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 451', 'Human Settlements and Architecture', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 461', 'Building Components and Methods IV', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 463', 'Architectural Structures IV', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 471', 'Computer Applications in Architecture V', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 433', 'Interior Design and Decoration', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 414', 'History of Traditional Architecture in Nigeria', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 412', 'Building Economics', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 416', 'Public and Institutional Buildings', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 432', 'Architectural Design V', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 434', 'Landscape Architecture', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 442', 'Acoustics and Noise Control', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 462', 'Building Components and Methods V', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 464', 'Architectural Structures V', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Development and Management', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ARC 444', 'Natural and Artificial Lighting', 'University of Nigeria, Nsukka', 'Faculty of Environmental Studies', 'Architecture', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false);
