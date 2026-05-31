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

delete from public.standings where season = '2025/2026';

insert into public.standings (season, team_name, position, played, won, drawn, lost, goals_for, goals_against, goal_difference, points) values
('2025/2026', 'Erzurumspor FK', 1, 38, 23, 12, 3, 82, 27, 55, 81),
('2025/2026', 'Amed SK', 2, 38, 21, 11, 6, 81, 42, 39, 74),
('2025/2026', 'Esenler Erokspor', 3, 38, 21, 11, 6, 81, 35, 46, 74),
('2025/2026', 'ARCA ÇORUM FK', 4, 38, 21, 8, 9, 63, 39, 24, 71),
('2025/2026', 'Bodrum FK', 5, 38, 18, 10, 10, 71, 39, 32, 64),
('2025/2026', 'Pendikspor', 6, 38, 16, 15, 7, 58, 33, 25, 63),
('2025/2026', 'Keçiörengücü', 7, 38, 16, 12, 10, 73, 43, 30, 60),
('2025/2026', 'Bandırmaspor', 8, 38, 16, 12, 10, 47, 34, 13, 60),
('2025/2026', 'Manisa FK', 9, 38, 16, 7, 15, 57, 56, 1, 55),
('2025/2026', 'Sivasspor', 10, 38, 14, 11, 13, 47, 43, 4, 53),
('2025/2026', 'İstanbulspor', 11, 38, 13, 13, 12, 57, 55, 2, 52),
('2025/2026', 'Sarıyer', 12, 38, 15, 7, 16, 44, 44, 0, 52),
('2025/2026', 'Iğdır FK', 13, 38, 13, 11, 14, 52, 54, -2, 50),
('2025/2026', 'Vanspor FK', 14, 38, 13, 10, 15, 52, 47, 5, 49),
('2025/2026', 'Boluspor', 15, 38, 14, 6, 18, 61, 57, 4, 48),
('2025/2026', 'Ümraniyespor', 16, 38, 13, 7, 18, 47, 51, -4, 46),
('2025/2026', 'Serik Spor', 17, 38, 11, 6, 21, 44, 75, -31, 39),
('2025/2026', 'Sakaryaspor', 18, 38, 8, 10, 20, 45, 72, -27, 34),
('2025/2026', 'Hatayspor', 19, 38, 2, 8, 28, 33, 102, -69, 14),
('2025/2026', 'Adana Demirspor', 20, 38, 1, 3, 34, 22, 169, -147, -57);

-- Market value is intentionally omitted: the current schema has no verified field.
insert into public.squad (id, name, number, position, nationality, status, image_url) values
('40000000-0000-0000-0000-000000000001', 'Ibrahim Sehic', 13, 'goalkeeper', 'Bosna-Hersek', 'active', 'assets/images/players/corum_fk/ibrahim_sehic.jpg'),
('40000000-0000-0000-0000-000000000002', 'Ahmet Said Kıvanç', 1, 'goalkeeper', 'Türkiye', 'active', 'assets/images/players/corum_fk/ahmet_kivanc.jpg'),
('40000000-0000-0000-0000-000000000003', 'Hasan Hüseyin Akınay', 27, 'goalkeeper', 'Türkiye', 'active', 'assets/images/players/corum_fk/hasan_huseyin_akinay.jpg'),
('40000000-0000-0000-0000-000000000004', 'Arda Şengül', 15, 'defender', 'Türkiye', 'active', 'assets/images/players/corum_fk/arda_sengul.jpg'),
('40000000-0000-0000-0000-000000000005', 'Joseph Attamah', 3, 'defender', 'Gana', 'active', 'assets/images/players/corum_fk/joseph_attamah.jpg'),
('40000000-0000-0000-0000-000000000006', 'Efe Sarıkaya', 33, 'defender', 'Türkiye', 'active', 'assets/images/players/corum_fk/efe_sarikaya.jpg'),
('40000000-0000-0000-0000-000000000007', 'Sinan Osmanoğlu', 5, 'defender', 'Türkiye', 'active', 'assets/images/players/corum_fk/sinan_osmanoglu.jpg'),
('40000000-0000-0000-0000-000000000008', 'Cemali Sertel', 19, 'defender', 'Türkiye', 'active', 'assets/images/players/corum_fk/cemali_sertel.jpg'),
('40000000-0000-0000-0000-000000000009', 'Erkan Kaş', 39, 'defender', 'Türkiye / Kosova', 'active', 'assets/images/players/corum_fk/erkan_kas.jpg'),
('40000000-0000-0000-0000-000000000010', 'Kerem Kalafat', 22, 'defender', 'Türkiye', 'active', 'assets/images/players/corum_fk/kerem_kalafat.jpg'),
('40000000-0000-0000-0000-000000000011', 'Üzeyir Ergün', 23, 'defender', 'Türkiye', 'active', 'assets/images/players/corum_fk/uzeyir_ergun.jpg'),
('40000000-0000-0000-0000-000000000012', 'Ferhat Yazgan', 6, 'midfielder', 'Türkiye / Almanya', 'active', 'assets/images/players/corum_fk/ferhat_yazgan.jpg'),
('40000000-0000-0000-0000-000000000013', 'Atakan Cangöz', 92, 'midfielder', 'Türkiye', 'active', 'assets/images/players/corum_fk/atakan_cangoz.jpg'),
('40000000-0000-0000-0000-000000000014', 'Atakan Akkaynak', 8, 'midfielder', 'Türkiye / Almanya', 'active', 'assets/images/players/corum_fk/atakan_akkaynak.jpg'),
('40000000-0000-0000-0000-000000000015', 'Pedrinho', 14, 'midfielder', 'Portekiz', 'active', 'assets/images/players/corum_fk/pedrinho.jpg'),
('40000000-0000-0000-0000-000000000016', 'Ahmed Ildız', 66, 'midfielder', 'Türkiye / Avusturya', 'active', 'assets/images/players/corum_fk/ahmed_ildiz.jpg'),
('40000000-0000-0000-0000-000000000017', 'Fredy Ribeiro', 16, 'midfielder', 'Angola / Portekiz', 'active', 'assets/images/players/corum_fk/fredy.jpg'),
('40000000-0000-0000-0000-000000000018', 'Oğuz Gürbulak', 20, 'midfielder', 'Türkiye', 'active', 'assets/images/players/corum_fk/oguz_gurbulak.jpg'),
('40000000-0000-0000-0000-000000000019', 'Danijel Aleksić', 9, 'midfielder', 'Sırbistan', 'active', 'assets/images/players/corum_fk/danijel_aleksic.jpg'),
('40000000-0000-0000-0000-000000000020', 'Ibrahim Zubairu', 21, 'forward', 'Gana / Sırbistan', 'active', 'assets/images/players/corum_fk/ibrahim_zubairu.jpg'),
('40000000-0000-0000-0000-000000000021', 'Yusuf Erdoğan', 10, 'forward', 'Türkiye', 'active', 'assets/images/players/corum_fk/yusuf_erdogan.jpg'),
('40000000-0000-0000-0000-000000000022', 'Burak Çoban', 77, 'forward', 'Türkiye / Almanya', 'active', 'assets/images/players/corum_fk/burak_coban.jpg'),
('40000000-0000-0000-0000-000000000023', 'Serdar Gürler', 7, 'forward', 'Türkiye / Fransa', 'active', 'assets/images/players/corum_fk/serdar_gurler.jpg'),
('40000000-0000-0000-0000-000000000024', 'Eren Karadağ', 99, 'forward', 'Türkiye', 'active', 'assets/images/players/corum_fk/eren_karadag.jpg'),
('40000000-0000-0000-0000-000000000025', 'Furkan Çetinkaya', 45, 'midfielder', 'Türkiye', 'active', 'assets/images/players/corum_fk/furkan_cetinkaya.jpg'),
('40000000-0000-0000-0000-000000000026', 'Mame Thiam', 17, 'forward', 'Senegal / İtalya', 'active', null),
('40000000-0000-0000-0000-000000000027', 'Braian Samudio', 18, 'forward', 'Paraguay', 'active', 'assets/images/players/corum_fk/braian_samudio.jpg')
on conflict (id) do update set name = excluded.name, number = excluded.number, position = excluded.position, nationality = excluded.nationality, status = excluded.status, image_url = excluded.image_url;

delete from public.squad
where id = '40000000-0000-0000-0000-000000000028';

-- Verified staff: Çorum FK Uğur Uçar; Esenler Erokspor Güray Gündoğdu.
