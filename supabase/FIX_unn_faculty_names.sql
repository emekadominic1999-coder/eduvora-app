-- =============================================================================
-- Eduvora — align UNN course outlines with UNN's real faculty names
-- =============================================================================
-- Run in the Supabase SQL Editor. Safe to run more than once.
--
-- The course outlines already loaded for the University of Nigeria, Nsukka
-- were filed under "Faculty of Science", which is the generic name Eduvora
-- used before UNN's own structure was mapped. UNN has no Faculty of Science:
-- it splits the sciences into a Faculty of Physical Sciences (Geology,
-- Mathematics, Physics and Astronomy, Pure and Industrial Chemistry,
-- Statistics, Computer Science) and a Faculty of Biological Sciences.
--
-- Nothing filters on faculty today — outlines are matched by institution,
-- department and level — so this is tidiness rather than a broken feature.
-- It matters for anything that groups by faculty later, and for the outlines
-- reading correctly to a student who knows their own faculty's name.
-- =============================================================================

-- ---------------------------------------------------------- before the change
select faculty, department, count(*) as courses
  from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
 group by faculty, department
 order by faculty, department;

-- ------------------------------------------------------------- physical sciences
update public.course_outlines
   set faculty = 'Faculty of Physical Sciences'
 where institution = 'University of Nigeria, Nsukka'
   and department in (
     'Geology',
     'Mathematics',
     'Physics and Astronomy',
     'Pure and Industrial Chemistry',
     'Statistics',
     'Computer Science'
   );

-- ----------------------------------------------------------- biological sciences
update public.course_outlines
   set faculty = 'Faculty of Biological Sciences'
 where institution = 'University of Nigeria, Nsukka'
   and department in (
     'Biochemistry',
     'Microbiology',
     'Plant Science and Biotechnology',
     'Zoology and Environmental Biology'
   );

-- =============================================================================
-- CHECK IT WORKED
-- =============================================================================
-- No row should still read "Faculty of Science".

select faculty, department, count(*) as courses
  from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
 group by faculty, department
 order by faculty, department;
