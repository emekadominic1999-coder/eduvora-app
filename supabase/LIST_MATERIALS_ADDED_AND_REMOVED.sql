-- 1) Materials added since yesterday (2 Nov 2026), newest first
select course_code, title, department, level, created_at
  from public.materials
 where created_at >= timestamptz '2026-11-02 00:00:00+01'
 order by created_at desc;

-- 2) Materials that were in the app before the 3 Nov cleanup and are NOT there now
--    (the cleanup keeps a full backup, so nothing is lost)
select b.course_code, b.title, b.department, b.level
  from public.cleanup_backup_materials_2026_11_03 b
 where not exists (select 1 from public.materials m where m.id = b.id)
 order by b.course_code, b.title;
