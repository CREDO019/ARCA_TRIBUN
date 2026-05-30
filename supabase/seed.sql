insert into public.news (
  id,
  title,
  summary,
  content,
  author_name,
  category,
  status,
  published_at
) values
  (
    '10000000-0000-0000-0000-000000000001',
    'Yeni sezon hazırlıkları başladı',
    'Arca Çorum FK yeni sezon çalışmalarına başladı.',
    'Takım, yeni sezon hazırlık programının ilk bölümünü tamamladı. Bu kayıt yerel geliştirme ortamı için hazırlanmış demo içeriktir.',
    'ARCA Tribün Demo',
    'club',
    'published',
    '2026-05-28T10:00:00+03:00'
  ),
  (
    '10000000-0000-0000-0000-000000000002',
    'Taraftar buluşması için geri sayım',
    'Sezon öncesi taraftar buluşmasının detayları yakında açıklanacak.',
    'Kulüp ve taraftarları bir araya getirecek etkinlik için hazırlıklar sürüyor. Bu kayıt yerel geliştirme ortamı için hazırlanmış demo içeriktir.',
    'ARCA Tribün Demo',
    'community',
    'published',
    '2026-05-27T14:30:00+03:00'
  ),
  (
    '10000000-0000-0000-0000-000000000003',
    'Maç merkezi test yayını hazır',
    'ARCA Tribün maç merkezi demo verilerle kullanıma hazır.',
    'Canlı skor ve maç olayları altyapısı geliştirme ortamında örnek verilerle doğrulanabilir. Bu kayıt resmi bir maç duyurusu değildir.',
    'ARCA Tribün Demo',
    'app',
    'published',
    '2026-05-26T09:15:00+03:00'
  )
on conflict (id) do nothing;

insert into public.matches (
  id,
  competition,
  season,
  home_team,
  away_team,
  opponent,
  is_home,
  stadium,
  match_date,
  status,
  home_score,
  away_score,
  minute
) values
  (
    '20000000-0000-0000-0000-000000000001',
    'Demo Lig',
    '2026/2027',
    'Arca Çorum FK',
    'Anadolu Demo SK',
    'Anadolu Demo SK',
    true,
    'Çorum Şehir Stadyumu',
    '2026-08-16T20:00:00+03:00',
    'scheduled',
    null,
    null,
    null
  ),
  (
    '20000000-0000-0000-0000-000000000002',
    'Demo Lig',
    '2026/2027',
    'Kuzey Demo FK',
    'Arca Çorum FK',
    'Kuzey Demo FK',
    false,
    'Demo Stadyumu',
    '2026-08-23T19:00:00+03:00',
    'scheduled',
    null,
    null,
    null
  ),
  (
    '20000000-0000-0000-0000-000000000003',
    'Demo Hazırlık',
    '2026/2027',
    'Arca Çorum FK',
    'Kale Demo Spor',
    'Kale Demo Spor',
    true,
    'Çorum Şehir Stadyumu',
    '2026-05-30T18:00:00+03:00',
    'live',
    2,
    1,
    67
  ),
  (
    '20000000-0000-0000-0000-000000000004',
    'Demo Hazırlık',
    '2026/2027',
    'Vadi Demo SK',
    'Arca Çorum FK',
    'Vadi Demo SK',
    false,
    'Demo Stadyumu',
    '2026-05-20T18:00:00+03:00',
    'finished',
    0,
    1,
    90
  ),
  (
    '20000000-0000-0000-0000-000000000005',
    'Demo Lig',
    '2026/2027',
    'Arca Çorum FK',
    'Güney Demo FK',
    'Güney Demo FK',
    true,
    'Çorum Şehir Stadyumu',
    '2026-08-30T20:00:00+03:00',
    'scheduled',
    null,
    null,
    null
  )
on conflict (id) do nothing;

insert into public.match_events (
  id,
  match_id,
  minute,
  event_type,
  team,
  player_name,
  description
) values
  (
    '30000000-0000-0000-0000-000000000001',
    '20000000-0000-0000-0000-000000000003',
    1,
    'kickoff',
    null,
    null,
    'Demo maç başladı.'
  ),
  (
    '30000000-0000-0000-0000-000000000002',
    '20000000-0000-0000-0000-000000000003',
    24,
    'goal',
    'Arca Çorum FK',
    'Demo Oyuncu 09',
    'Demo gol kaydı.'
  ),
  (
    '30000000-0000-0000-0000-000000000003',
    '20000000-0000-0000-0000-000000000003',
    52,
    'yellow_card',
    'Kale Demo Spor',
    'Demo Rakip 04',
    'Demo sarı kart kaydı.'
  )
on conflict (id) do nothing;

insert into public.squad (
  id,
  name,
  number,
  position,
  nationality,
  height_cm,
  preferred_foot,
  status
) values
  ('40000000-0000-0000-0000-000000000001', 'Demo Kaleci 01', 1, 'goalkeeper', 'TR', 190, 'right', 'active'),
  ('40000000-0000-0000-0000-000000000002', 'Demo Kaleci 13', 13, 'goalkeeper', 'TR', 186, 'right', 'active'),
  ('40000000-0000-0000-0000-000000000003', 'Demo Defans 02', 2, 'defender', 'TR', 182, 'right', 'active'),
  ('40000000-0000-0000-0000-000000000004', 'Demo Defans 04', 4, 'defender', 'TR', 187, 'left', 'active'),
  ('40000000-0000-0000-0000-000000000005', 'Demo Defans 05', 5, 'defender', 'TR', 180, 'right', 'active'),
  ('40000000-0000-0000-0000-000000000006', 'Demo Orta Saha 06', 6, 'midfielder', 'TR', 178, 'right', 'active'),
  ('40000000-0000-0000-0000-000000000007', 'Demo Orta Saha 08', 8, 'midfielder', 'TR', 176, 'left', 'active'),
  ('40000000-0000-0000-0000-000000000008', 'Demo Orta Saha 10', 10, 'midfielder', 'TR', 174, 'both', 'active'),
  ('40000000-0000-0000-0000-000000000009', 'Demo Forvet 09', 9, 'forward', 'TR', 184, 'right', 'active'),
  ('40000000-0000-0000-0000-000000000010', 'Demo Forvet 11', 11, 'forward', 'TR', 181, 'left', 'active')
on conflict (id) do nothing;

insert into public.standings (
  id,
  season,
  team_name,
  position,
  played,
  won,
  drawn,
  lost,
  goals_for,
  goals_against,
  goal_difference,
  points
) values
  ('50000000-0000-0000-0000-000000000001', '2026/2027', 'Anadolu Demo SK', 1, 8, 6, 1, 1, 16, 6, 10, 19),
  ('50000000-0000-0000-0000-000000000002', '2026/2027', 'Arca Çorum FK', 2, 8, 5, 2, 1, 14, 7, 7, 17),
  ('50000000-0000-0000-0000-000000000003', '2026/2027', 'Kuzey Demo FK', 3, 8, 4, 2, 2, 12, 8, 4, 14),
  ('50000000-0000-0000-0000-000000000004', '2026/2027', 'Kale Demo Spor', 4, 8, 3, 3, 2, 10, 9, 1, 12),
  ('50000000-0000-0000-0000-000000000005', '2026/2027', 'Vadi Demo SK', 5, 8, 3, 1, 4, 9, 11, -2, 10),
  ('50000000-0000-0000-0000-000000000006', '2026/2027', 'Güney Demo FK', 6, 8, 2, 2, 4, 8, 12, -4, 8),
  ('50000000-0000-0000-0000-000000000007', '2026/2027', 'Ova Demo Spor', 7, 8, 1, 2, 5, 6, 13, -7, 5),
  ('50000000-0000-0000-0000-000000000008', '2026/2027', 'Irmak Demo FK', 8, 8, 1, 1, 6, 5, 14, -9, 4)
on conflict (id) do nothing;

