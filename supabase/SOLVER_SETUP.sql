-- One-time setup for the "Snap a question" solver. Safe to run twice.
create table if not exists public.ai_solve_usage (
  user_id uuid not null,
  day date not null,
  uses int not null default 0,
  primary key (user_id, day)
);
alter table public.ai_solve_usage enable row level security;
select 'ai_solve_usage ready' as status;
