class PilotData {
  PilotData._();

  static const appName = 'ARCA TRİBÜN';
  static const clubName = 'ARCA ÇORUM FK';
  static const finalMatchId = '20000000-0000-0000-0000-000000000001';
  static const seasonStartMatchId = '20000000-0000-0000-0000-000000000002';

  static final newsRows = <Map<String, dynamic>>[
    {
      'id': '10000000-0000-0000-0000-000000000001',
      'title': 'Çorum FK Süper Lig’e yükseldi',
      'summary': 'Çorum FK, play-off finalinde Esenler Erokspor’u 2-0 '
          'mağlup ederek Süper Lig’e yükseldi.',
      'content': '24 Mayıs 2026 tarihinde Medaş Konya Büyükşehir '
          'Stadyumu’nda oynanan Trendyol 1. Lig Play-Off Finali’nde '
          'Çorum FK, Esenler Erokspor’u 2-0 mağlup ederek Süper Lig’e '
          'yükseldi. Goller 37. dakikada Serdar Gürler ve 53. dakikada '
          'Mame Thiam’dan geldi. Bu içerik pilot uygulama için doğrulanmış '
          'sonuçlardan hazırlanmıştır.',
      'author_name': appName,
      'category': 'Yükseliş',
      'status': 'published',
      'published_at': '2026-05-24T22:10:00+03:00',
    },
    {
      'id': '10000000-0000-0000-0000-000000000002',
      'title': 'Yeni sezon hazırlığı',
      'summary': 'Süper Lig 2026/2027 sezonu için hazırlık haftası bekleniyor.',
      'content': 'Yeni sezon fikstürü açıklandığında maç detayları '
          'güncellenecek. Pilot veri görünümünde kesinleşmemiş rakip '
          'bilgisi kullanılmaz.',
      'author_name': appName,
      'category': 'Pilot veri',
      'status': 'published',
      'published_at': '2026-05-25T10:00:00+03:00',
    },
  ];

  static final matches = <Map<String, dynamic>>[
    {
      'id': finalMatchId,
      'competition': 'Trendyol 1. Lig Play-Off Finali',
      'season': '2025/2026',
      'home_team': 'Esenler Erokspor',
      'away_team': 'Çorum FK',
      'opponent': 'Esenler Erokspor',
      'is_home': false,
      'stadium': 'Medaş Konya Büyükşehir Stadyumu',
      'match_date': '2026-05-24T19:00:00+03:00',
      'status': 'finished',
      'home_score': 0,
      'away_score': 2,
      'minute': 90,
    },
    {
      'id': seasonStartMatchId,
      'competition': 'Trendyol Süper Lig',
      'season': '2026/2027',
      'home_team': clubName,
      'away_team': 'Rakip açıklanacak',
      'opponent': 'Rakip açıklanacak',
      'is_home': true,
      'stadium': 'Çorum Şehir Stadyumu',
      'match_date': '2026-08-14T20:00:00+03:00',
      'status': 'scheduled',
      'home_score': null,
      'away_score': null,
      'minute': null,
    },
  ];

  static final matchEvents = <Map<String, dynamic>>[
    {
      'id': '30000000-0000-0000-0000-000000000001',
      'match_id': finalMatchId,
      'minute': 37,
      'event_type': 'goal',
      'team': 'Çorum FK',
      'player_name': 'Serdar Gürler',
      'description': 'Serdar Gürler, Çorum FK adına skoru 0-1 yaptı.',
    },
    {
      'id': '30000000-0000-0000-0000-000000000002',
      'match_id': finalMatchId,
      'minute': 53,
      'event_type': 'goal',
      'team': 'Çorum FK',
      'player_name': 'Mame Thiam',
      'description': 'Mame Thiam farkı ikiye çıkardı.',
    },
    {
      'id': '30000000-0000-0000-0000-000000000003',
      'match_id': finalMatchId,
      'minute': 92,
      'event_type': 'red_card',
      'team': 'Esenler Erokspor',
      'player_name': 'Guélor Kanga',
      'description': '90+2’ Guélor Kanga kırmızı kart gördü.',
    },
  ];

  static final squadRows = <Map<String, dynamic>>[
    _player('40000000-0000-0000-0000-000000000001', 'Ibrahim Sehic', 13,
        'goalkeeper', 'Bosna-Hersek'),
    _player('40000000-0000-0000-0000-000000000002', 'Ahmet Said Kıvanç', 1,
        'goalkeeper', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000003', 'Hasan Hüseyin Akınay', 27,
        'goalkeeper', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000004', 'Arda Şengül', 15,
        'defender', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000005', 'Joseph Attamah', 3,
        'defender', 'Gana'),
    _player('40000000-0000-0000-0000-000000000006', 'Efe Sarıkaya', 33,
        'defender', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000007', 'Sinan Osmanoğlu', 5,
        'defender', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000008', 'Cemali Sertel', 19,
        'defender', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000009', 'Erkan Kaş', 39, 'defender',
        'Türkiye / Kosova'),
    _player('40000000-0000-0000-0000-000000000010', 'Kerem Kalafat', 22,
        'defender', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000011', 'Üzeyir Ergün', 23,
        'defender', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000012', 'Ferhat Yazgan', 6,
        'midfielder', 'Türkiye / Almanya'),
    _player('40000000-0000-0000-0000-000000000013', 'Atakan Cangöz', 92,
        'midfielder', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000014', 'Atakan Akkaynak', 8,
        'midfielder', 'Türkiye / Almanya'),
    _player('40000000-0000-0000-0000-000000000015', 'Pedrinho', 14,
        'midfielder', 'Portekiz'),
    _player('40000000-0000-0000-0000-000000000016', 'Ahmed Ildız', 66,
        'midfielder', 'Türkiye / Avusturya'),
    _player('40000000-0000-0000-0000-000000000017', 'Fredy Ribeiro', 16,
        'midfielder', 'Angola / Portekiz'),
    _player('40000000-0000-0000-0000-000000000018', 'Oğuz Gürbulak', 20,
        'midfielder', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000019', 'Danijel Aleksić', 9,
        'midfielder', 'Sırbistan'),
    _player('40000000-0000-0000-0000-000000000020', 'Ibrahim Zubairu', 21,
        'forward', 'Gana / Sırbistan'),
    _player('40000000-0000-0000-0000-000000000021', 'Yusuf Erdoğan', 10,
        'forward', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000022', 'Burak Çoban', 77,
        'forward', 'Türkiye / Almanya'),
    _player('40000000-0000-0000-0000-000000000023', 'Serdar Gürler', 7,
        'forward', 'Türkiye / Fransa'),
    _player('40000000-0000-0000-0000-000000000024', 'Eren Karadağ', 99,
        'forward', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000025', 'Furkan Çetinkaya', 45,
        'midfielder', 'Türkiye'),
    _player('40000000-0000-0000-0000-000000000026', 'Mame Thiam', 17, 'forward',
        'Senegal / İtalya'),
    _player('40000000-0000-0000-0000-000000000027', 'Braian Samudio', 18,
        'forward', 'Paraguay'),
  ];

  static final notificationCards = <Map<String, String>>[
    {
      'title': 'Çorum FK 2-0 Esenler Erokspor',
      'body': 'Play-off final zaferiyle Süper Lig’e yükseldik.',
    },
    {
      'title': 'Yeni sezon fikstürü',
      'body': 'Yeni sezon fikstürü açıklandığında bildirim alacaksın.',
    },
    {
      'title': 'Kadro bilgileri güncellendi',
      'body': 'Doğrulanmış A takım kadrosu yayınlandı.',
    },
  ];

  static Map<String, dynamic>? matchById(String matchId) {
    return _firstWhereOrNull(matches, (row) => row['id'] == matchId);
  }

  static List<Map<String, dynamic>> eventsForMatch(String matchId) {
    return matchEvents.where((row) => row['match_id'] == matchId).toList();
  }

  static Map<String, dynamic>? playerById(String playerId) {
    return _firstWhereOrNull(squadRows, (row) => row['id'] == playerId);
  }

  static Map<String, dynamic> _player(
    String id,
    String name,
    int? number,
    String position,
    String nationality,
  ) {
    return {
      'id': id,
      'name': name,
      'number': number,
      'position': position,
      'nationality': nationality,
      'status': 'active',
    };
  }

  static Map<String, dynamic>? _firstWhereOrNull(
    List<Map<String, dynamic>> rows,
    bool Function(Map<String, dynamic>) test,
  ) {
    for (final row in rows) {
      if (test(row)) return row;
    }
    return null;
  }
}
