-- =============================================================================
-- Eduvora — automatic education news
-- =============================================================================
-- Run in the Supabase SQL Editor AFTER deploying the fetch-news Edge Function.
-- Safe to run more than once.
--
-- Prepares the `news` table to be filled automatically from public RSS feeds
-- instead of by hand, and schedules the fetch to run four times a day.
-- =============================================================================

-- -------------------------------------------------------- 1. tidy the table
-- The upsert keys on `link`, which needs a unique index. Existing rows have to
-- be made safe for that first: seeded entries carry an empty link, and the
-- same story may already be in twice.

-- Give every link-less row a unique placeholder rather than deleting it, so
-- nothing anybody added by hand is lost.
update public.news
   set link = 'eduvora:manual/' || id::text
 where coalesce(link, '') = '';

-- Where the same link appears more than once, keep the most recent row.
delete from public.news a
 using public.news b
 where a.link = b.link
   and a.published_at < b.published_at;

-- Any remaining ties (identical link and timestamp) are broken by id.
delete from public.news a
 using public.news b
 where a.link = b.link
   and a.published_at = b.published_at
   and a.id < b.id;

alter table public.news alter column link set not null;

create unique index if not exists news_link_key on public.news (link);

-- The feed writes these; make sure they exist for anyone on an older schema.
alter table public.news
  add column if not exists source text not null default '',
  add column if not exists summary text not null default '',
  add column if not exists is_featured boolean not null default false;

create index if not exists news_category_idx on public.news (category);

-- ------------------------------------------------------- 2. who may write
-- The noticeboard stays readable by everyone. Writes come only from the Edge
-- Function, which uses the service role key and bypasses RLS — so no insert
-- or update policy is granted to ordinary users here. That is deliberate:
-- students should not be able to post to the noticeboard.

drop policy if exists "news is readable by everyone" on public.news;
create policy "news is readable by everyone"
  on public.news for select using (true);

-- ---------------------------------------------------------- 3. the schedule
-- Easiest route: Supabase Dashboard → Integrations → Cron → Create job, point
-- it at the fetch-news function, schedule '0 */6 * * *'. If you would rather
-- do it in SQL, the rest of this file does the same thing.

create extension if not exists pg_cron with schema extensions;
create extension if not exists pg_net with schema extensions;

-- The service role key is a password: it goes in the Vault, never inline in a
-- migration that ends up in git.
--
--   1. Dashboard → Project Settings → Vault → New secret
--   2. Name it exactly:  eduvora_service_role_key
--   3. Paste your service role key as the value
--
-- Then run the block below.

do $$
declare
  service_key text;
  project_url text := 'https://wdsvzhxhqzblpekdmsqs.supabase.co';
begin
  select decrypted_secret into service_key
    from vault.decrypted_secrets
   where name = 'eduvora_service_role_key';

  if service_key is null then
    raise notice 'No vault secret named eduvora_service_role_key — skipping the schedule. Add it, then run this file again.';
    return;
  end if;

  -- Replacing rather than stacking, so running this file twice does not
  -- schedule the fetch twice.
  perform cron.unschedule('eduvora-fetch-news')
    where exists (
      select 1 from cron.job where jobname = 'eduvora-fetch-news'
    );

  perform cron.schedule(
    'eduvora-fetch-news',
    '0 */6 * * *',
    format(
      $job$
      select net.http_post(
        url := %L,
        headers := jsonb_build_object(
          'Content-Type', 'application/json',
          'Authorization', %L
        ),
        body := '{}'::jsonb,
        timeout_milliseconds := 60000
      );
      $job$,
      project_url || '/functions/v1/fetch-news',
      'Bearer ' || service_key
    )
  );

  raise notice 'Scheduled eduvora-fetch-news every six hours.';
end $$;

-- =============================================================================
-- 4. CHECK IT WORKED
-- =============================================================================

-- The schedule:
select jobname, schedule, active
  from cron.job
 where jobname = 'eduvora-fetch-news';

-- What has arrived so far (empty until the function has run once):
select category, count(*) as stories, max(published_at) as newest
  from public.news
 group by category
 order by stories desc;
