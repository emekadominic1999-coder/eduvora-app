-- One-time setup for the "Update Eduvora" prompt. Safe to run twice.
create table if not exists public.app_update (
  id int primary key default 1,
  latest_build int not null default 0,
  min_build int not null default 0,
  message text not null default '',
  constraint app_update_one_row check (id = 1)
);
alter table public.app_update enable row level security;
drop policy if exists "anyone can read app_update" on public.app_update;
create policy "anyone can read app_update" on public.app_update for select using (true);
insert into public.app_update (id, latest_build, min_build, message)
values (1, 32, 0, 'A new version of Eduvora is ready with new questions, notes and improvements.')
on conflict (id) do nothing;
select * from public.app_update;
