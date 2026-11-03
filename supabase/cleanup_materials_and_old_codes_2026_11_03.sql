-- =============================================================================
-- EDUVORA CLEANUP (3 Nov 2026) - materials and old course codes
-- =============================================================================
-- Requested by the owner: remove junk materials, and fix or remove anything that
-- still uses an OLD course code, so the app only shows current courses.
--
-- SAFETY
--   * Step 0 copies every row of `materials` and `course_outlines` into backup
--     tables first (only the first time it runs), so every change can be undone.
--   * Only codes the owner has explicitly declared old are changed.
--   * Anything that is unclear is NOT deleted. It is listed in the final table so
--     it can be reviewed.
--   * Safe to run twice.
--
-- WHAT IT DOES
--   1. Backs up materials and course_outlines.
--   2. Tidies how course codes are typed in materials ("phy101", "Phy-101" -> "PHY 101").
--   3. Changes old codes to their current codes in materials AND course_outlines
--      (BIO 151->BIO 101, PHY 121->PHY 101, GSP 101->GST 111, MTH 111->MTH 101 ...).
--   4. Removes duplicate rows that this creates (same title, department, code, file).
--   5. Removes materials with no title or no file/link (unusable).
--   6. Removes the old PHY 121 outline row where PHY 101 and PHY 103 now exist.
--   7. Shows a summary and the codes that still need a decision.
-- =============================================================================

-- 0. Backups (kept private)
create table if not exists public.cleanup_backup_materials_2026_11_03 as
  select * from public.materials;
create table if not exists public.cleanup_backup_outlines_2026_11_03 as
  select * from public.course_outlines;
alter table public.cleanup_backup_materials_2026_11_03 enable row level security;
alter table public.cleanup_backup_outlines_2026_11_03 enable row level security;
do $$
begin
  if to_regclass('public.course_code_change_backup_2026_11_03') is not null then
    execute 'alter table public.course_code_change_backup_2026_11_03 enable row level security';
  end if;
end $$;

-- 1. Old code -> current code (only mappings the owner has confirmed)
create temp table code_map (old_code text primary key, new_code text);
insert into code_map values
  ('BIO 151', 'BIO 101'), ('BIO 152', 'BIO 102'), ('BIO 154', 'BIO 108'),
  ('PHY 121', 'PHY 101'), ('PHY 124', 'PHY 102'), ('PHY 114', 'PHY 102'), ('PHY 192', 'PHY 108'),
  ('PHY 191', 'PHY 107'), ('PHY 193', 'PHY 107'),
  ('MTH 111', 'MTH 101'), ('MTH 121', 'MTH 103'), ('MTH 122', 'MTH 102'),
  ('GSP 101', 'GST 111'), ('GSP 102', 'GST 114'), ('GSP 201', 'GST 311'), ('GSP 202', 'GST 312'),
  ('GSP 207', 'GST 211'), ('GSP 208', 'GST 212'), ('GST 208', 'GST 212'),
  ('EGR 101', 'GET 101'), ('ECO 131', 'ECO 111');

-- 2. Tidy how codes are typed in materials
update public.materials
   set course_code = regexp_replace(upper(trim(course_code)), '^([A-Z]{2,4})\s*[-_.]?\s*([0-9]{3})$', '\1 \2')
 where course_code ~* '^\s*[a-z]{2,4}\s*[-_.]?\s*[0-9]{3}\s*$'
   and course_code <> regexp_replace(upper(trim(course_code)), '^([A-Z]{2,4})\s*[-_.]?\s*([0-9]{3})$', '\1 \2');

-- 3a. Materials: old code -> current code
update public.materials m
   set course_code = c.new_code
  from code_map c
 where m.course_code = c.old_code;

-- keep a separate `code` column in step if the table has one
do $$
begin
  if exists (select 1 from information_schema.columns
              where table_schema = 'public' and table_name = 'materials' and column_name = 'code') then
    execute 'update public.materials set code = course_code where code is distinct from course_code and course_code <> ''''';
  end if;
end $$;

-- 3b. Course outlines: where the current-code row already exists for the same
--     department, drop the old row (it would only duplicate); otherwise rename it.
delete from public.course_outlines o
 using code_map c
 where o.course_code = c.old_code
   and exists (select 1 from public.course_outlines n
                where n.course_code = c.new_code
                  and n.institution = o.institution
                  and n.faculty = o.faculty
                  and n.department = o.department);
update public.course_outlines o
   set course_code = c.new_code
  from code_map c
 where o.course_code = c.old_code;

-- 4. Remove duplicate materials (same title, code, department, FACULTY, level and file).
--    Faculty matters: the app shows a material to a faculty only if a copy exists for it.
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

-- 5. Remove unusable materials (no title, or no file/link at all)
delete from public.materials
 where coalesce(trim(title), '') = ''
    or length(trim(title)) < 3
    or coalesce(trim(file_url), '') = '';

-- 6. Summary and the codes that still need a decision (nothing here was deleted)
select item, value from (
  select 1 as ord, 'materials before cleanup' as item, count(*)::text as value
    from public.cleanup_backup_materials_2026_11_03
  union all
  select 2, 'materials now', count(*)::text from public.materials
  union all
  select 3, 'outline rows before cleanup', count(*)::text from public.cleanup_backup_outlines_2026_11_03
  union all
  select 4, 'outline rows now', count(*)::text from public.course_outlines
  union all
  select 5, 'NEEDS REVIEW - code not in any course: ' || x.course_code, x.n::text
    from (select m.course_code, count(*) as n
            from public.materials m
           where not exists (select 1 from public.course_outlines o where o.course_code = m.course_code)
           group by m.course_code order by count(*) desc limit 40) x
) r order by ord, item;
