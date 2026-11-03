-- =============================================================================
-- UNN 2026 renumbering (user-declared, 3 Nov 2026):
--   Inference II               -> STA 122  (was STA 132)
--   Statistical Computing      -> STA 132  (was STA 172)
-- =============================================================================
-- Works from the course TITLE, not the current code, because the database
-- already holds a mix of old and new codes from earlier renumberings. Safe to
-- run more than once. A backup of every row that changes is kept in
-- public.course_code_change_backup_2026_11_03.

create table if not exists public.course_code_change_backup_2026_11_03 (
  source text, row_id text, old_code text, old_title text, department text
);

insert into public.course_code_change_backup_2026_11_03
select 'course_outlines', id::text, course_code, course_title, department
  from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and ((course_title ilike 'Inference II%' and course_code <> 'STA 122')
     or ((course_title ilike 'Statistical Computing%' or course_title ilike 'Laboratory for Inference II%')
         and course_code <> 'STA 132'));

update public.course_outlines
   set course_code = 'STA 122'
 where institution = 'University of Nigeria, Nsukka'
   and course_title ilike 'Inference II%'
   and course_code <> 'STA 122';

update public.course_outlines
   set course_code = 'STA 132'
 where institution = 'University of Nigeria, Nsukka'
   and (course_title ilike 'Statistical Computing%' or course_title ilike 'Laboratory for Inference II%')
   and course_code <> 'STA 132';

-- Remove exact duplicates this may have created (same department, level, code and title).
delete from public.course_outlines a
 using public.course_outlines b
 where a.ctid > b.ctid
   and a.institution = b.institution
   and a.faculty = b.faculty
   and a.department = b.department
   and a.level = b.level
   and a.course_code = b.course_code
   and a.course_title = b.course_title
   and a.course_code in ('STA 122', 'STA 132');

-- Check: STA 122 should be Inference II, STA 132 Statistical Computing.
select course_code, string_agg(distinct course_title, ' | ') as titles, count(*) as rows
  from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and course_code in ('STA 122', 'STA 132', 'STA 172')
 group by 1 order by 1;
