-- Optional remote pilot seed. Run manually only after reviewing the target.
-- This file is never applied automatically by the application.
insert into public.news (id, title, summary, content, author_name, category, status, published_at) values
('10000000-0000-0000-0000-000000000001', 'Çorum FK Süper Lig’e yükseldi', 'Çorum FK, play-off finalinde Esenler Erokspor’u 2-0 mağlup ederek Süper Lig’e yükseldi.', '24 Mayıs 2026 tarihinde Medaş Konya Büyükşehir Stadyumu’nda oynanan Trendyol 1. Lig Play-Off Finali’nde Çorum FK, Esenler Erokspor’u 2-0 mağlup ederek Süper Lig’e yükseldi. Bu içerik pilot uygulama için doğrulanmış sonuçlardan hazırlanmıştır.', 'ARCA TRİBÜN', 'Yükseliş', 'published', '2026-05-24T22:10:00+03:00'),
('10000000-0000-0000-0000-000000000002', 'Yeni sezon hazırlığı', 'Süper Lig 2026/2027 sezonu için hazırlık haftası bekleniyor.', 'Yeni sezon fikstürü açıklandığında maç detayları güncellenecek.', 'ARCA TRİBÜN', 'Pilot veri', 'published', '2026-05-25T10:00:00+03:00')
on conflict (id) do update set title = excluded.title, summary = excluded.summary, content = excluded.content;

insert into public.matches (id, competition, season, home_team, away_team, opponent, is_home, stadium, match_date, status, home_score, away_score, minute) values
('20000000-0000-0000-0000-000000000001', 'Trendyol 1. Lig Play-Off Finali', '2025/2026', 'Esenler Erokspor', 'Çorum FK', 'Esenler Erokspor', false, 'Medaş Konya Büyükşehir Stadyumu', '2026-05-24T19:00:00+03:00', 'finished', 0, 2, 90),
('20000000-0000-0000-0000-000000000002', 'Trendyol Süper Lig', '2026/2027', 'ARCA ÇORUM FK', 'Rakip açıklanacak', 'Rakip açıklanacak', true, 'Çorum Şehir Stadyumu', '2026-08-14T20:00:00+03:00', 'scheduled', null, null, null)
on conflict (id) do update set competition = excluded.competition, season = excluded.season, home_team = excluded.home_team, away_team = excluded.away_team, opponent = excluded.opponent, is_home = excluded.is_home, stadium = excluded.stadium, match_date = excluded.match_date, status = excluded.status, home_score = excluded.home_score, away_score = excluded.away_score, minute = excluded.minute;

insert into public.match_events (id, match_id, minute, event_type, team, player_name, description) values
('30000000-0000-0000-0000-000000000001', '20000000-0000-0000-0000-000000000001', 37, 'goal', 'Çorum FK', 'Serdar Gürler', 'Serdar Gürler, Çorum FK adına skoru 0-1 yaptı.'),
('30000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', 53, 'goal', 'Çorum FK', 'Mame Thiam', 'Mame Thiam farkı ikiye çıkardı.'),
('30000000-0000-0000-0000-000000000003', '20000000-0000-0000-0000-000000000001', 92, 'red_card', 'Esenler Erokspor', 'Guélor Kanga', '90+2’ Guélor Kanga kırmızı kart gördü.')
on conflict (id) do update set minute = excluded.minute, event_type = excluded.event_type, team = excluded.team, player_name = excluded.player_name, description = excluded.description;

-- Market value is intentionally omitted: the current schema has no verified field.
insert into public.squad (id, name, number, position, nationality, status) values
('40000000-0000-0000-0000-000000000001', 'Ibrahim Sehic', 13, 'goalkeeper', 'Bosna-Hersek', 'active'),
('40000000-0000-0000-0000-000000000002', 'Ahmet Said Kıvanç', 1, 'goalkeeper', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000003', 'Hasan Hüseyin Akınay', 27, 'goalkeeper', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000004', 'Arda Şengül', 15, 'defender', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000005', 'Joseph Attamah', 3, 'defender', 'Gana', 'active'),
('40000000-0000-0000-0000-000000000006', 'Efe Sarıkaya', 33, 'defender', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000007', 'Sinan Osmanoğlu', 5, 'defender', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000008', 'Cemali Sertel', 19, 'defender', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000009', 'Erkan Kaş', 39, 'defender', 'Türkiye / Kosova', 'active'),
('40000000-0000-0000-0000-000000000010', 'Kerem Kalafat', 22, 'defender', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000011', 'Üzeyir Ergün', 23, 'defender', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000012', 'Ferhat Yazgan', 6, 'midfielder', 'Türkiye / Almanya', 'active'),
('40000000-0000-0000-0000-000000000013', 'Atakan Cangöz', 92, 'midfielder', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000014', 'Atakan Akkaynak', 8, 'midfielder', 'Türkiye / Almanya', 'active'),
('40000000-0000-0000-0000-000000000015', 'Pedrinho', 14, 'midfielder', 'Portekiz', 'active'),
('40000000-0000-0000-0000-000000000016', 'Ahmed Ildız', 66, 'midfielder', 'Türkiye / Avusturya', 'active'),
('40000000-0000-0000-0000-000000000017', 'Fredy Ribeiro', 16, 'midfielder', 'Angola / Portekiz', 'active'),
('40000000-0000-0000-0000-000000000018', 'Oğuz Gürbulak', 20, 'midfielder', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000019', 'Danijel Aleksić', 9, 'midfielder', 'Sırbistan', 'active'),
('40000000-0000-0000-0000-000000000020', 'Ibrahim Zubairu', 21, 'forward', 'Gana / Sırbistan', 'active'),
('40000000-0000-0000-0000-000000000021', 'Yusuf Erdoğan', 10, 'forward', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000022', 'Burak Çoban', 77, 'forward', 'Türkiye / Almanya', 'active'),
('40000000-0000-0000-0000-000000000023', 'Serdar Gürler', 7, 'forward', 'Türkiye / Fransa', 'active'),
('40000000-0000-0000-0000-000000000024', 'Eren Karadağ', 99, 'forward', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000025', 'Furkan Çetinkaya', 45, 'midfielder', 'Türkiye', 'active'),
('40000000-0000-0000-0000-000000000026', 'Mame Thiam', 17, 'forward', 'Senegal / İtalya', 'active'),
('40000000-0000-0000-0000-000000000027', 'Braian Samudio', 18, 'forward', 'Paraguay', 'active')
on conflict (id) do update set name = excluded.name, number = excluded.number, position = excluded.position, nationality = excluded.nationality, status = excluded.status;

delete from public.squad
where id = '40000000-0000-0000-0000-000000000028';

-- Verified staff: Çorum FK Uğur Uçar; Esenler Erokspor Güray Gündoğdu.
