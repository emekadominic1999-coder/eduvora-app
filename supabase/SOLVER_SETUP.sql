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

-- Paid access to the AI tools. A student can use them while expires_at is in the future.
create table if not exists public.ai_access (
  user_id uuid primary key,
  expires_at timestamptz not null,
  note text not null default ''
);
alter table public.ai_access enable row level security;
select 'ai access table ready' as status;
