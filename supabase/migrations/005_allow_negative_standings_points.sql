-- Penalty deductions can result in a verified negative final league score.
alter table public.standings
  drop constraint if exists standings_points_check;
