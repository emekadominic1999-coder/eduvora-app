-- =============================================================================
-- REPAIR: bring back the per-faculty material copies the first cleanup removed
-- =============================================================================
-- The cleanup treated materials that differ ONLY by faculty as duplicates. The app
-- shows an "All departments" material to a student only when a copy exists for
-- that student's faculty, so those copies are needed.
-- This restores every removed row from the backup (except genuinely unusable
-- ones), re-applies the code tidy-up and old-to-current code changes, and then
-- removes only TRUE duplicates (same title, code, department, faculty, level, file).
-- Safe to run twice.
-- =============================================================================

-- 1. Restore removed rows (not unusable ones)
insert into public.materials
select b.*
  from public.cleanup_backup_materials_2026_11_03 b
 where not exists (select 1 from public.materials m where m.id = b.id)
   and coalesce(trim(b.title), '') <> ''
   and length(trim(b.title)) >= 3
   and coalesce(trim(b.file_url), '') <> '';

-- 2. Re-apply the code tidy-up and the old -> current code changes on those rows
create temp table code_map (old_code text primary key, new_code text);
insert into code_map values
  ('BIO 151', 'BIO 101'), ('BIO 152', 'BIO 102'), ('BIO 154', 'BIO 108'),
  ('PHY 121', 'PHY 101'), ('PHY 124', 'PHY 102'), ('PHY 114', 'PHY 102'), ('PHY 192', 'PHY 108'),
  ('PHY 191', 'PHY 107'), ('PHY 193', 'PHY 107'),
  ('MTH 111', 'MTH 101'), ('MTH 121', 'MTH 103'), ('MTH 122', 'MTH 102'),
  ('GSP 101', 'GST 111'), ('GSP 102', 'GST 114'), ('GSP 201', 'GST 311'), ('GSP 202', 'GST 312'),
  ('GSP 207', 'GST 211'), ('GSP 208', 'GST 212'), ('GST 208', 'GST 212'),
  ('EGR 101', 'GET 101'), ('ECO 131', 'ECO 111');

update public.materials
   set course_code = regexp_replace(upper(trim(course_code)), '^([A-Z]{2,4})\s*[-_.]?\s*([0-9]{3})$', '\1 \2')
 where course_code ~* '^\s*[a-z]{2,4}\s*[-_.]?\s*[0-9]{3}\s*$'
   and course_code <> regexp_replace(upper(trim(course_code)), '^([A-Z]{2,4})\s*[-_.]?\s*([0-9]{3})$', '\1 \2');

update public.materials m
   set course_code = c.new_code
  from code_map c
 where m.course_code = c.old_code;

do $$
begin
  if exists (select 1 from information_schema.columns
              where table_schema = 'public' and table_name = 'materials' and column_name = 'code') then
    execute 'update public.materials set code = course_code where code is distinct from course_code and course_code <> ''''';
  end if;
end $$;

-- 3. Remove TRUE duplicates only (faculty and level are part of the match)
delete from public.materials a
 using public.materials b
 where a.ctid > b.ctid
   and a.title = b.title
   and a.course_code = b.course_code
   and a.department = b.department
   and a.faculty = b.faculty
   and a.level = b.level
   and a.file_url = b.file_url
   and coalesce(a.file_url, '') <> '';

-- 4. Check
select 'materials before the first cleanup' as item, count(*)::text as value from public.cleanup_backup_materials_2026_11_03
union all select 'materials now (after repair)', count(*)::text from public.materials
union all select 'materials still removed (unusable or true duplicates)',
  ((select count(*) from public.cleanup_backup_materials_2026_11_03) - (select count(*) from public.materials))::text
order by 1;
