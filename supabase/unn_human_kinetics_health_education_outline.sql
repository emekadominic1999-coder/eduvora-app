-- =============================================================================
-- University of Nigeria, Nsukka -- Faculty of Education
-- Department of Human Kinetics and Health Education
-- =============================================================================
-- Transcribed from the department's own official website (course code,
-- title, credit unit, level and semester for each course). 71 rows.
--
-- The department's site publishes the course list but not per-course
-- syllabus descriptions or topic breakdowns, so description and topics are
-- left empty here rather than invented.
--
-- Scope: the 4-Year B.Sc Human Kinetics and Sports Studies programme. The department also runs a 3-Year variant and both a 4-Year and 3-Year B.Sc Health Education programme, published on the same page, which are out of scope for this app.
-- =============================================================================

delete from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and department = 'Human Kinetics and Health Education';

insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level,
   semester, credit_units, description, topics, contributor_name, is_elective)
values
  ('HKS 113', 'Skills and Techniques of Track and Field Athletics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 120', 'Philosophical and Historical Foundations of Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 131', 'Weight Training and Physical Fitness', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 142', 'Introduction to Sports Journalism', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 102', 'History of Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 101', 'Introduction to Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 151', 'General Biology I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 101', 'Use of English I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 112', 'Basic Skills of Swimming and Water Safety', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 114', 'Skills and Techniques Development in Team Sports I (Ball Games: Soccer, Volleyball, Handball and Basketball)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 4, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 116', 'Movement Education and Creative Dance', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CHP 174', 'Community Health', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('MAC 112', 'Writing for the Mass Media', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 152', 'General Biology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('BIO 153', 'General Biology III (Practical)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 102', 'Use of English II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '100 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 211', 'Skills and Techniques Development in Team Sports II (Stick Games: Hockey and Cricket)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 231', 'Human Anatomy and Physiology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 223', 'Principles of Recreation, Outdoor Pursuits and Tourism', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 243', 'Curriculum Planning in Human Kinetics and Sports Programmes', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 245', 'Methods and Resources for Conduct of Human Kinetics Programme in Schools', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 211', 'Educational Psychology I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 221', 'Curriculum Theory and Planning', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('COS 101', 'Introduction to Computer Science', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 103', 'Social Science I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 212', 'Skills and Techniques Development in Racquet Games (Badminton, Tennis, Table Tennis and Squash)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 218', 'Gymnastics (Floor Activities and Apparatus Work)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 222', 'Sociological Basis of Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 232', 'Motor Learning and Human Performance', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 234', 'Psychology of Sports', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 236', 'Principles and Methods of Exercise Prescription for Diverse Population', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 244', 'Adapted Physical Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 1, '', '[]'::jsonb, 'Department official website', false),
  ('CHP 262', 'School Health Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 321', 'Curriculum Implementation and Instruction', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 104', 'Social Science II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '200 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 313', 'Practical Sports Coaching, Officiating and Game Analysis (Racquet, Track and Field Athletics)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 331', 'Principles of Athletic and Fitness Conditioning', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 341', 'Research Methods in Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 343', 'Practicum in Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 345', 'Planning and Management of Intramural and Interscholastic Sports Programme', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 224', 'Educational Technology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 311', 'Educational Psychology II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('ZOO 310', 'Basic Physiology', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 4, '', '[]'::jsonb, 'Department official website', false),
  ('CED 341', 'Introduction to Entrepreneurship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 105', 'Natural Science I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 332', 'Physiology of Human Activity and Biomechanics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 334', 'Scientific and Psychological Basis of Sports Coaching', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 336', 'Statistical Application in Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 342', 'Administration of Community Recreation and Tourism', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 344', 'Measurements and Evaluation of Human Performance Efficiency in Human Kinetics and Sports', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 346', 'Common Sports Injuries, First Aid Care and Safety Education', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 325', 'Professional Teaching Practice Experience I', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 3, '', '[]'::jsonb, 'Department official website', false),
  ('COS 304', 'Computer Applications', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('CED 342', 'Business Creation and Growth', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('GSP 106', 'Natural Science II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '300 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 411', 'Practical Sports Coaching, Officiating, Game Analysis II (Team Sports: Ball and Stick Game)', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 413', 'ICT Utilization for Data Organization and Presentation in Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 415', 'Kinesiology of Sports and Human Movement', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 431', 'Nutrition and Ergogenic Aids in Sports', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 445', 'Sports Law and Ethics', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 1, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 447', 'Sports Marketing and Sponsorship', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 451', 'Seminar in Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 411', 'Education Psychology III', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 2, '', '[]'::jsonb, 'Department official website', false),
  ('EDU 425', 'Professional Teaching Practice Experience II', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'first', 3, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 412', 'Human Movement Programme for Special Needs Group', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 417', 'Advanced Skills of Soccer and Tennis', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 424', 'Issues and Problems in Human Kinetics and Sports Studies', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 440', 'Planning and Administration of Competitive Sports', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 442', 'Supervision in Human Kinetic and Sports Programme', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 446', 'Planning, Construction, and Maintenance of Sports Facilities', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false),
  ('HKS 452', 'Project Report', 'University of Nigeria, Nsukka', 'Faculty of Education', 'Human Kinetics and Health Education', '400 Level', 'second', 2, '', '[]'::jsonb, 'Department official website', false);
