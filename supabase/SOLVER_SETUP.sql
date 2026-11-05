-- One-time setup for the AI solver and question maker. Safe to run twice.
create table if not exists public.ai_solve_usage (
  user_id uuid not null,
  day date not null,
  uses int not null default 0,
  primary key (user_id, day)
);
alter table public.ai_solve_usage add column if not exists gen_uses int not null default 0;
alter table public.ai_solve_usage enable row level security;
select 'ai usage table ready' as status;
