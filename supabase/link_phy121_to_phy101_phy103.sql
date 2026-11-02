-- Old PHY 121 (Fundamentals of Physics I) = new PHY 101 + new PHY 103
-- =============================================================================
-- Confirmed by the user: the old PHY 121 course has split into
--   PHY 101  Mechanics (units and dimensions through static equilibrium)
--   PHY 103  Properties of Matter (elasticity, fluids, surface tension,
--            viscosity, ideal gas laws and kinetic theory)
-- RUN ORDER: (1) unn_phy101_ca_cbt_questions.sql  (2) this file.
--
-- A. CBT: the mechanics subject keeps its id 'phy-121-mechanics' (so existing
--    attempts and unlocks are not orphaned) and is displayed as PHY 101. The
--    properties-of-matter questions move to a new subject, 'phy-103-properties-of-matter'.
--    Questions are moved by topic.
-- B. Course outlines: ADDITIVE ONLY. New PHY 101 and PHY 103 rows are added for
--    every department that has a PHY 121 row. The PHY 121 rows are kept.
--    Credit units are set to 0 (unknown) rather than guessed; please confirm.
-- =============================================================================

-- A1. Display name of the mechanics bank
update public.cbt_questions
   set subject_name = 'PHY 101: Fundamentals of Physics I (Mechanics)'
 where subject_id = 'phy-121-mechanics';

-- A2. Move the properties-of-matter questions to PHY 103
update public.cbt_questions
   set subject_id = 'phy-103-properties-of-matter',
       subject_name = 'PHY 103: Properties of Matter, Fluids and Kinetic Theory'
 where subject_id = 'phy-121-mechanics'
   and replace(topic, ' [VERIFY]', '') in (
     'Hooke''s Law',
     'Elastic Potential Energy',
     'Young''s Modulus',
     'Hooke''s Law (Stress-Strain)',
     'Ductile and Brittle Materials',
     'Torsional Strain and Shear Modulus',
     'Bulk Modulus of Elasticity',
     'Compressibility',
     'Pressure in Liquids',
     'Characteristics of Liquid Pressure',
     'Mercury Barometer',
     'Hydraulic Press',
     'Hydraulic Press Principle',
     'Siphon',
     'Density of Mixtures',
     'Relative Density',
     'Archimedes'' Principle',
     'Archimedes'' Principle (Tension)',
     'Principle of Flotation',
     'Hydrometers',
     'Surface Tension',
     'Reduction of Surface Tension',
     'Capillary Rise',
     'Capillarity (Tube Diameter)',
     'Excess Pressure in a Liquid Drop',
     'Excess Pressure in a Soap Bubble',
     'Equation of Continuity',
     'Bernoulli''s Equation',
     'Bernoulli''s Principle',
     'Torricelli''s Theorem',
     'Bernoulli''s Equation (Lift)',
     'Venturi Flow Meter',
     'Fluid Viscosity',
     'Viscosity (Viscometer)',
     'Poiseuille''s Equation',
     'Stokes'' Law',
     'Terminal Velocity',
     'Reynolds Number',
     'Compressibility of Water',
     'Flow Speed from Flow Rate',
     'Continuity Equation with Reduced Diameter',
     'Reynolds Number and Kinematic Viscosity',
     'Boyle''s Law',
     'Charles'' Law',
     'Ideal Gas Equation',
     'Ideal Gas Equation (Moles Used)',
     'Kinetic Theory Assumptions',
     'Kinetic Theory Pressure Equation',
     'Kinetic Theory and Temperature',
     'Root Mean Square Speed',
     'R.M.S. Speed and Molecular Mass',
     'Graham''s Law of Diffusion',
     'Dalton''s Law of Partial Pressures',
     'Avogadro''s Law',
     'Average Kinetic Energy of Gas Molecules',
     'Avogadro''s Number',
     'Elastic properties of solids',
     'Surface tension and viscosity',
     'Fluid mechanics and hydrodynamics',
     'Ideal gas laws and kinetic theory of gases'
   );

-- A3. Check: both counts should be above zero
select subject_id, subject_name, count(*) as questions
  from public.cbt_questions
 where subject_id in ('phy-121-mechanics', 'phy-103-properties-of-matter')
 group by 1, 2 order by 1;

-- B1. PHY 101 outline rows (from each PHY 121 row)
insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level, semester,
   credit_units, description, topics, contributor_name, is_elective)
select 'PHY 101', 'Mechanics (Fundamentals of Physics I)', o.institution, o.faculty, o.department,
       o.level, o.semester, 0,
       'Units and dimensions. Vector algebra. Kinematics and dynamics of a mass point; laws of mechanics and gravitation, Kepler''s Laws. Motion of rigid bodies, moment of inertia; angular momentum - conservation laws. Static equilibrium of rigid bodies. Circular and simple harmonic motion.',
       '["Units and dimensions", "Vector algebra", "Kinematics and dynamics of a mass point", "Laws of mechanics and gravitation, Kepler''s Laws", "Motion of rigid bodies, moment of inertia", "Angular momentum - conservation laws", "Static equilibrium of rigid bodies", "Circular and simple harmonic motion"]'::jsonb,
       'Department of Physics and Astronomy handbook (split from PHY 121)', false
  from public.course_outlines o
 where o.course_code = 'PHY 121'
   and o.institution = 'University of Nigeria, Nsukka'
   and not exists (select 1 from public.course_outlines x
                    where x.course_code = 'PHY 101' and x.institution = o.institution
                      and x.department = o.department and x.faculty = o.faculty);

-- B2. PHY 103 outline rows (from each PHY 121 row)
insert into public.course_outlines
  (course_code, course_title, institution, faculty, department, level, semester,
   credit_units, description, topics, contributor_name, is_elective)
select 'PHY 103', 'Properties of Matter (Fundamentals of Physics I)', o.institution, o.faculty, o.department,
       o.level, o.semester, 0,
       'Elastic properties of solids, moduli of elasticity. Surface tension, viscosity. Fluid mechanics and hydrodynamics. Ideal gas laws. Kinetic theory of gases.',
       '["Elastic properties of solids, moduli of elasticity", "Surface tension, viscosity", "Fluid mechanics and hydrodynamics", "Ideal gas laws", "Kinetic theory of gases"]'::jsonb,
       'Department of Physics and Astronomy handbook (split from PHY 121)', false
  from public.course_outlines o
 where o.course_code = 'PHY 121'
   and o.institution = 'University of Nigeria, Nsukka'
   and not exists (select 1 from public.course_outlines x
                    where x.course_code = 'PHY 103' and x.institution = o.institution
                      and x.department = o.department and x.faculty = o.faculty);

-- B3. Check: new rows per department
select course_code, faculty, department, credit_units
  from public.course_outlines
 where course_code in ('PHY 101', 'PHY 103')
   and contributor_name like '%split from PHY 121%'
 order by faculty, department, course_code;
