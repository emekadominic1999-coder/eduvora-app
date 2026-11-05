-- Run this ONCE before the theory questions file. Safe to run twice.
create table if not exists public.theory_questions (
  id uuid primary key default gen_random_uuid(),
  course_code text not null,
  course_title text not null default '',
  topic text not null default '',
  question text not null,
  marks int not null default 5,
  model_answer text not null default '',
  key_points jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);
create index if not exists theory_questions_course_idx on public.theory_questions (course_code);
alter table public.theory_questions enable row level security;
drop policy if exists "anyone can read theory_questions" on public.theory_questions;
create policy "anyone can read theory_questions" on public.theory_questions for select using (true);
select 'theory_questions table ready' as status;
