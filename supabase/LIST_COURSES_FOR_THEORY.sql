-- Lists every course in Eduvora, with how many CBT questions it already has.
-- Run in the SQL Editor, then use Export > CSV (or screenshot the first rows).
select
  o.course_code,
  min(o.course_title) as course_title,
  count(distinct o.department) as departments,
  coalesce(max(s.question_count), 0) as cbt_questions
from public.course_outlines o
left join public.cbt_subject_summaries s
  on s.subject_name ilike o.course_code || '%'
where o.institution ilike '%Nsukka%'
group by o.course_code
order by o.course_code;
