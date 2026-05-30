create extension if not exists pgcrypto;

create table public.news (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  summary text,
  content text,
  image_url text,
  author_name text,
  category text not null default 'club',
  status text not null default 'published'
    check (status in ('draft', 'published', 'archived')),
  published_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index news_published_at_idx on public.news (published_at desc);
create index news_status_idx on public.news (status);

create table public.matches (
  id uuid primary key default gen_random_uuid(),
  competition text not null default 'Süper Lig',
  season text not null default '2026/2027',
  home_team text not null,
  away_team text not null,
  opponent text not null,
  is_home boolean not null,
  stadium text,
  match_date timestamptz not null,
  status text not null default 'scheduled'
    check (status in ('scheduled', 'live', 'finished', 'postponed', 'cancelled')),
  home_score integer check (home_score is null or home_score >= 0),
  away_score integer check (away_score is null or away_score >= 0),
  minute integer check (minute is null or minute between 0 and 130),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index matches_match_date_idx on public.matches (match_date);
create index matches_status_idx on public.matches (status);

create table public.match_events (
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null references public.matches (id) on delete cascade,
  minute integer not null check (minute between 0 and 130),
  event_type text not null
    check (
      event_type in (
        'goal',
        'own_goal',
        'yellow_card',
        'red_card',
        'substitution',
        'penalty_goal',
        'kickoff',
        'fulltime',
        'other'
      )
    ),
  team text,
  player_name text,
  assist_player_name text,
  description text,
  created_at timestamptz not null default now()
);

create index match_events_match_id_idx on public.match_events (match_id);
create index match_events_match_id_minute_idx
  on public.match_events (match_id, minute);

create table public.standings (
  id uuid primary key default gen_random_uuid(),
  season text not null default '2026/2027',
  team_name text not null,
  position integer not null check (position > 0),
  played integer not null default 0 check (played >= 0),
  won integer not null default 0 check (won >= 0),
  drawn integer not null default 0 check (drawn >= 0),
  lost integer not null default 0 check (lost >= 0),
  goals_for integer not null default 0 check (goals_for >= 0),
  goals_against integer not null default 0 check (goals_against >= 0),
  goal_difference integer not null default 0,
  points integer not null default 0 check (points >= 0),
  updated_at timestamptz not null default now(),
  unique (season, team_name),
  unique (season, position)
);

create index standings_season_idx on public.standings (season);
create index standings_season_position_idx
  on public.standings (season, position);

create table public.squad (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  number integer check (number is null or number between 1 and 99),
  position text not null,
  nationality text,
  image_url text,
  birth_date date,
  height_cm integer check (height_cm is null or height_cm between 120 and 230),
  preferred_foot text check (preferred_foot is null or preferred_foot in ('left', 'right', 'both')),
  status text not null default 'active'
    check (status in ('active', 'injured', 'suspended', 'inactive')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index squad_position_idx on public.squad (position);
create index squad_status_idx on public.squad (status);

create table public.fan_profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  avatar_url text,
  points integer not null default 0 check (points >= 0),
  level integer not null default 1 check (level > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.user_predictions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  match_id uuid not null references public.matches (id) on delete cascade,
  home_score integer not null check (home_score between 0 and 30),
  away_score integer not null check (away_score between 0 and 30),
  points_awarded integer not null default 0 check (points_awarded >= 0),
  locked boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, match_id)
);

create index user_predictions_user_id_idx
  on public.user_predictions (user_id);
create index user_predictions_match_id_idx
  on public.user_predictions (match_id);

create table public.user_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  device_token text not null unique,
  platform text check (platform is null or platform in ('ios', 'android', 'web')),
  notification_enabled boolean not null default true,
  last_seen_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index user_devices_user_id_idx on public.user_devices (user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.fan_profiles (id, display_name, avatar_url)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'display_name',
      new.raw_user_meta_data ->> 'full_name',
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      'Taraftar'
    ),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger news_set_updated_at
before update on public.news
for each row execute function public.set_updated_at();

create trigger matches_set_updated_at
before update on public.matches
for each row execute function public.set_updated_at();

create trigger standings_set_updated_at
before update on public.standings
for each row execute function public.set_updated_at();

create trigger squad_set_updated_at
before update on public.squad
for each row execute function public.set_updated_at();

create trigger fan_profiles_set_updated_at
before update on public.fan_profiles
for each row execute function public.set_updated_at();

create trigger user_predictions_set_updated_at
before update on public.user_predictions
for each row execute function public.set_updated_at();

revoke all on function public.handle_new_user() from public, anon, authenticated;
revoke all on function public.set_updated_at() from public, anon, authenticated;

create view public.fixtures
with (security_invoker = true)
as
select *
from public.matches;

create view public.live_match_state
with (security_invoker = true)
as
select
  id,
  id as match_id,
  minute,
  home_score,
  away_score,
  null::text as last_scorer,
  null::text as last_scoring_team,
  50::integer as home_possession,
  50::integer as away_possession,
  0::integer as home_shots,
  0::integer as away_shots,
  0::integer as home_corners,
  0::integer as away_corners
from public.matches
where status = 'live';

-- This security-invoker view intentionally inherits fan_profiles RLS.
-- It exposes only the authenticated user's own row until a privacy-reviewed
-- leaderboard RPC or read model is introduced.
create view public.leaderboard
with (security_invoker = true)
as
select
  id as user_id,
  display_name,
  avatar_url,
  points,
  level,
  rank() over (order by points desc, created_at asc) as rank
from public.fan_profiles;

alter table public.news enable row level security;
alter table public.matches enable row level security;
alter table public.match_events enable row level security;
alter table public.standings enable row level security;
alter table public.squad enable row level security;
alter table public.fan_profiles enable row level security;
alter table public.user_predictions enable row level security;
alter table public.user_devices enable row level security;

create policy "published news is readable"
on public.news for select
to anon, authenticated
using (status = 'published');

create policy "matches are readable"
on public.matches for select
to anon, authenticated
using (true);

create policy "match events are readable"
on public.match_events for select
to anon, authenticated
using (true);

create policy "standings are readable"
on public.standings for select
to anon, authenticated
using (true);

create policy "active squad is readable"
on public.squad for select
to anon, authenticated
using (status = 'active');

create policy "users can read own fan profile"
on public.fan_profiles for select
to authenticated
using ((select auth.uid()) = id);

create policy "users can create own fan profile"
on public.fan_profiles for insert
to authenticated
with check ((select auth.uid()) = id);

create policy "users can update own fan profile"
on public.fan_profiles for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

create policy "users can read own predictions"
on public.user_predictions for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "users can create own future predictions"
on public.user_predictions for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1
    from public.matches
    where matches.id = user_predictions.match_id
      and matches.match_date > now()
      and matches.status = 'scheduled'
  )
);

create policy "users can update own unlocked future predictions"
on public.user_predictions for update
to authenticated
using (
  (select auth.uid()) = user_id
  and not locked
  and exists (
    select 1
    from public.matches
    where matches.id = user_predictions.match_id
      and matches.match_date > now()
      and matches.status = 'scheduled'
  )
)
with check (
  (select auth.uid()) = user_id
  and not locked
  and exists (
    select 1
    from public.matches
    where matches.id = user_predictions.match_id
      and matches.match_date > now()
      and matches.status = 'scheduled'
  )
);

create policy "users can read own devices"
on public.user_devices for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "users can create own devices"
on public.user_devices for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "users can update own devices"
on public.user_devices for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "users can delete own devices"
on public.user_devices for delete
to authenticated
using ((select auth.uid()) = user_id);

revoke all on public.news from anon, authenticated;
revoke all on public.matches from anon, authenticated;
revoke all on public.match_events from anon, authenticated;
revoke all on public.standings from anon, authenticated;
revoke all on public.squad from anon, authenticated;
revoke all on public.fan_profiles from anon, authenticated;
revoke all on public.user_predictions from anon, authenticated;
revoke all on public.user_devices from anon, authenticated;
revoke all on public.fixtures from anon, authenticated;
revoke all on public.live_match_state from anon, authenticated;
revoke all on public.leaderboard from anon, authenticated;

grant select on public.news to anon, authenticated;
grant select on public.matches to anon, authenticated;
grant select on public.match_events to anon, authenticated;
grant select on public.standings to anon, authenticated;
grant select on public.squad to anon, authenticated;
grant select on public.fixtures to anon, authenticated;
grant select on public.live_match_state to anon, authenticated;

grant select on public.fan_profiles to authenticated;
grant insert (id, display_name, avatar_url) on public.fan_profiles
to authenticated;
grant update (display_name, avatar_url) on public.fan_profiles
to authenticated;

grant select on public.user_predictions to authenticated;
grant insert (user_id, match_id, home_score, away_score)
on public.user_predictions to authenticated;
grant update (home_score, away_score)
on public.user_predictions to authenticated;

grant select, delete on public.user_devices to authenticated;
grant insert (user_id, device_token, platform, notification_enabled, last_seen_at)
on public.user_devices to authenticated;
grant update (device_token, platform, notification_enabled, last_seen_at)
on public.user_devices to authenticated;
grant select on public.leaderboard to authenticated;

grant all on public.news to service_role;
grant all on public.matches to service_role;
grant all on public.match_events to service_role;
grant all on public.standings to service_role;
grant all on public.squad to service_role;
grant all on public.fan_profiles to service_role;
grant all on public.user_predictions to service_role;
grant all on public.user_devices to service_role;
grant select on public.fixtures to service_role;
grant select on public.live_match_state to service_role;
grant select on public.leaderboard to service_role;
