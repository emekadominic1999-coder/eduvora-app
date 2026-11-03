select 'MTH 103 calculus (expect 1)' as check_name, count(*) as found
  from public.cbt_questions where question ilike '%x^{x}%derivative at%'
union all
select 'PHY 102 first set (expect 1)', count(*)
  from public.cbt_questions where question ilike '%solenoid must produce%'
union all
select 'PHY 102 second set (expect 1)', count(*)
  from public.cbt_questions where question ilike '%circular arc of radius%'
union all
select 'PHY 108 practical (expect about 55)', count(*)
  from public.cbt_questions where topic in ('Errors and Measurement','Graphs and Data Analysis','Lenses and Mirrors','Prism and Refraction','Electricity Practicals')
union all
select 'STA 112 probability (expect about 63)', count(*)
  from public.cbt_questions where topic in ('Set Theory and Counting','Probability and Bayes Theorem','Random Variables and Expectation','Discrete Distributions','Continuous Distributions','Moment Generating Functions and Limit Theorems')
union all
select 'Engineering outlines added (expect about 280)', count(*)
  from public.course_outlines where contributor_name = 'NUC CCMAS 2023 (Engineering)'
order by 1;
