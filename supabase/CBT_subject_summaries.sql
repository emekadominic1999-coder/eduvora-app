-- =============================================================================
-- CBT subject list, without downloading every question
-- =============================================================================
-- Run once in the Supabase SQL Editor.
--
-- The app used to download the whole cbt_questions table (tens of thousands of
-- rows, ~19 MB) every time a student opened CBT practice just to show the list
-- of papers. This view returns ONE small row per paper (name, faculty, level,
-- question count, topics); the questions themselves are then fetched only for
-- the paper a student actually starts.
--
-- security_invoker makes the view obey the same row-level security as the
-- table underneath (readable by signed-in students only).
create or replace view public.cbt_subject_summaries
with (security_invoker = true) as
select
  subject_id,
  max(subject_name)                       as subject_name,
  max(institution)                        as institution,
  max(faculty)                            as faculty,
  max(department)                         as department,
  max(level)                              as level,
  max(semester)                           as semester,
  max(units)                              as units,
  bool_or(coalesce(is_general, false))    as is_general,
  count(*)                                as question_count,
  bool_and(topic = 'Coming Soon')         as only_placeholder,
  array_agg(distinct topic)               as topics
from public.cbt_questions
group by subject_id;

grant select on public.cbt_subject_summaries to authenticated;

-- check it worked: should list one row per paper
select subject_id, subject_name, question_count from public.cbt_subject_summaries order by subject_name limit 10;
