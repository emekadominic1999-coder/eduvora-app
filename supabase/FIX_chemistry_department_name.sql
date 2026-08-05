-- =============================================================================
-- Eduvora — merge "Industrial Chemistry" into "Pure and Industrial Chemistry"
-- =============================================================================
-- The department list briefly carried both names, which is the same department
-- under two labels. "Pure and Industrial Chemistry" is the name UNN actually
-- uses, so the shorter one has been dropped from the app.
--
-- This moves any existing rows onto the surviving name so nobody who had
-- already chosen the old one is stranded with an empty outline.
--
-- Safe to run more than once, and safe to run before or after loading the
-- chemistry course outline.
-- =============================================================================

update public.profiles
   set department = 'Pure and Industrial Chemistry'
 where department = 'Industrial Chemistry';

update public.course_outlines
   set department = 'Pure and Industrial Chemistry'
 where department = 'Industrial Chemistry';

update public.materials
   set department = 'Pure and Industrial Chemistry'
 where department = 'Industrial Chemistry';

update public.academic_videos
   set department = 'Pure and Industrial Chemistry'
 where department = 'Industrial Chemistry';

update public.cbt_questions
   set department = 'Pure and Industrial Chemistry'
 where department = 'Industrial Chemistry';

update public.community_posts
   set department = 'Pure and Industrial Chemistry'
 where department = 'Industrial Chemistry';

-- Report what is left, so a stray row cannot go unnoticed.
select 'profiles' as table_name, count(*) as still_on_old_name
  from public.profiles where department = 'Industrial Chemistry'
union all
select 'course_outlines', count(*)
  from public.course_outlines where department = 'Industrial Chemistry'
union all
select 'materials', count(*)
  from public.materials where department = 'Industrial Chemistry'
union all
select 'academic_videos', count(*)
  from public.academic_videos where department = 'Industrial Chemistry'
union all
select 'cbt_questions', count(*)
  from public.cbt_questions where department = 'Industrial Chemistry'
union all
select 'community_posts', count(*)
  from public.community_posts where department = 'Industrial Chemistry'
order by 1;
