-- =============================================================================
-- UNN 2026 renumbering (user-declared, 3 Nov 2026):
--   STA 132 (Inference II)            -> STA 122
--   STA 172 (Statistical Computing)   -> STA 132
-- =============================================================================
-- History: the same renumbering was first requested on 19 Aug 2026, then
-- reversed on 30 Aug 2026 when the Statistics Department's old course-module
-- page showed STA 132 / STA 172 as the current codes. The user now confirms
-- the codes have changed again, so this applies the NEW codes everywhere the
-- courses appear (Statistics, Computer Science, Mathematics, Economics, and any
-- CBT or material tagged with the code).
--
-- Order matters: STA 132 -> STA 122 runs first, to free the STA 132 code before
-- STA 172 takes it. If run twice, the guard below stops it safely.
-- A backup of every row that changes is kept in
-- public.course_code_change_backup_2026_11_03 (old code + title) so the change
-- can be reversed.
-- =============================================================================

-- 0. Guard: stop if STA 122 is already used by a different course.
do $$
begin
  if exists (select 1 from public.course_outlines
              where institution = 'University of Nigeria, Nsukka' and course_code = 'STA 122') then
    raise exception 'STA 122 already exists in course_outlines - nothing was changed. Check before re-running.';
  end if;
end $$;

-- 1. Backup of what is about to change.
create table if not exists public.course_code_change_backup_2026_11_03 (
  source text, row_id text, old_code text, old_title text, department text
);
insert into public.course_code_change_backup_2026_11_03
select 'course_outlines', id::text, course_code, course_title, department
  from public.course_outlines
 where institution = 'University of Nigeria, Nsukka' and course_code in ('STA 132', 'STA 172');
insert into public.course_code_change_backup_2026_11_03
select 'cbt_questions', id::text, subject_name, subject_id, department
  from public.cbt_questions
 where subject_name ~ '^STA (132|172)';
insert into public.course_code_change_backup_2026_11_03
select 'materials', id::text, course_code, title, department
  from public.materials
 where course_code in ('STA 132', 'STA 172');

-- 2. STA 132 -> STA 122 (Inference II)
update public.course_outlines
   set course_code = 'STA 122'
 where institution = 'University of Nigeria, Nsukka' and course_code = 'STA 132';
update public.cbt_questions
   set subject_name = regexp_replace(subject_name, '^STA 132', 'STA 122'),
       question = case when subject_id = 'sta-132-coming-soon'
                       then replace(question, 'STA 132', 'STA 122') else question end
 where subject_name ~ '^STA 132';
update public.materials set course_code = 'STA 122' where course_code = 'STA 132';

-- 3. STA 172 -> STA 132 (Statistical Computing)
update public.course_outlines
   set course_code = 'STA 132'
 where institution = 'University of Nigeria, Nsukka' and course_code = 'STA 172';
update public.cbt_questions
   set subject_name = regexp_replace(subject_name, '^STA 172', 'STA 132'),
       question = case when subject_id = 'sta-172-coming-soon'
                       then replace(question, 'STA 172', 'STA 132') else question end
 where subject_name ~ '^STA 172';
update public.materials set course_code = 'STA 132' where course_code = 'STA 172';

-- 4. If the materials table also has a separate `code` column, keep it in step.
do $$
begin
  if exists (select 1 from information_schema.columns
              where table_schema = 'public' and table_name = 'materials' and column_name = 'code') then
    execute 'update public.materials set code = ''STA 122'' where code = ''STA 132'' and course_code = ''STA 122''';
    execute 'update public.materials set code = ''STA 132'' where code = ''STA 172'' and course_code = ''STA 132''';
  end if;
end $$;

-- 5. Check: new codes per department (STA 122 = Inference II, STA 132 = Statistical Computing)
select course_code, course_title, department, count(*) as rows
  from public.course_outlines
 where institution = 'University of Nigeria, Nsukka'
   and course_code in ('STA 122', 'STA 132', 'STA 172')
 group by 1, 2, 3 order by 3, 1;
