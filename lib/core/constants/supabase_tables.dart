/// Supabase tablo ve kolon adları için merkezi sabitler.
///
/// Firebase Firestore'daki [FirestorePaths]'ın karşılığıdır.
/// Collection path'leri yerine PostgreSQL tablo adları kullanılır.
///
/// Kullanım:
/// ```dart
/// supabase.from(SupabaseTables.matches).select()...
/// supabase.from(SupabaseTables.liveMatchState).eq('match_id', id)...
/// ```
class SupabaseTables {
  SupabaseTables._();

  // ── Maç tabloları ──────────────────────────────────────────────────────

  /// Ana maç bilgileri
  static const String matches = 'matches';

  /// Canlı maç durumu (skor, dakika, son atış bilgileri)
  static const String liveMatchState = 'live_match_state';

  /// Maç olayları (gol, kart, değişiklik)
  static const String matchEvents = 'match_events';

  // ── İçerik tabloları ──────────────────────────────────────────────────

  /// Haberler
  static const String news = 'news';

  /// Fikstür (gelecek ve geçmiş maçlar)
  static const String fixtures = 'fixtures';

  /// Puan durumu
  static const String standings = 'standings';

  /// Kadro (oyuncular)
  static const String squad = 'squad';

  // ── Kullanıcı tabloları ───────────────────────────────────────────────

  /// Fan profilleri (auth.uid = id)
  static const String fanProfiles = 'fan_profiles';

  /// Maç tahminleri
  static const String userPredictions = 'user_predictions';

  /// Kullanıcı cihazları (FCM token yönetimi)
  static const String userDevices = 'user_devices';

  /// Sıralama (liderboard)
  static const String leaderboard = 'leaderboard';

  // ── Kolon adları ──────────────────────────────────────────────────────

  /// Ortak kolonlar
  static const String colId = 'id';
  static const String colMatchId = 'match_id';
  static const String colUserId = 'user_id';
  static const String colCreatedAt = 'created_at';
  static const String colUpdatedAt = 'updated_at';
  static const String colPublishedAt = 'published_at';
  static const String colStatus = 'status';
  static const String colScore = 'score';
  static const String colMinute = 'minute';
  static const String colFcmToken = 'fcm_token';
  static const String colPlatform = 'platform';
  static const String colFanPoints = 'fan_points';
  static const String colFanLevel = 'fan_level';
  static const String colDisplayName = 'display_name';
  static const String colLastScorer = 'last_scorer';
  static const String colLastScoringTeam = 'last_scoring_team';
}

// ─── Geriye dönük uyumluluk shim ─────────────────────────────────────────────
// Eski FirestorePaths referanslarını kırmamak için

/// @deprecated [SupabaseTables] kullanın.
@Deprecated('Use SupabaseTables instead')
class FirestorePaths {
  FirestorePaths._();

  static const String matches = SupabaseTables.matches;
  static String match(String id) => '${SupabaseTables.matches}/$id';
  static String liveMatch(String id) => '${SupabaseTables.liveMatchState}/$id';
  static String matchEvents(String id) => '${SupabaseTables.matchEvents}/$id';
  static const String news = SupabaseTables.news;
  static String newsItem(String id) => '${SupabaseTables.news}/$id';
  static const String standings = SupabaseTables.standings;
  static const String fixtures = SupabaseTables.fixtures;
  static const String squad = SupabaseTables.squad;
  static String player(String id) => '${SupabaseTables.squad}/$id';
  static String fanProfile(String uid) => '${SupabaseTables.fanProfiles}/$uid';
  static String predictions(String matchId) =>
      '${SupabaseTables.userPredictions}/$matchId';
  static String userPrediction(String matchId, String uid) =>
      '${SupabaseTables.userPredictions}/$matchId/$uid';
  static const String leaderboard = SupabaseTables.leaderboard;
  static const String weeklyLeaderboard =
      '${SupabaseTables.leaderboard}_weekly';
}
