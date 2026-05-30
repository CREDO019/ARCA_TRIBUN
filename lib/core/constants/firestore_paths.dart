/// Firestore koleksiyon ve doküman yolları.
/// Tüm Firestore referansları bu sınıf üzerinden oluşturulur.
/// Hiçbir yerde hardcode path yazılmaz.
class FirestorePaths {
  FirestorePaths._();

  // ─── Matches ──────────────────────────────────────────────────────────
  static const String matches = 'matches';

  /// Tek bir maç dokümanı
  static String match(String id) => 'matches/$id';

  /// Canlı maç durumu (realtime)
  static String liveMatch(String id) => 'matches/$id/live/current';

  /// Maç olayları (goller, kartlar, vb.)
  static String matchEvents(String id) => 'matches/$id/events';

  // ─── News ─────────────────────────────────────────────────────────────
  static const String news = 'news';

  /// Tek haber
  static String newsItem(String id) => 'news/$id';

  // ─── Standings & Fixtures ─────────────────────────────────────────────
  static const String standings = 'standings/current';
  static const String fixtures = 'fixtures';

  // ─── Squad ────────────────────────────────────────────────────────────
  static const String squad = 'squad';

  /// Tek oyuncu
  static String player(String id) => 'squad/$id';

  // ─── Fan Profiles ─────────────────────────────────────────────────────
  /// Kullanıcı profili (uid ile)
  static String fanProfile(String uid) => 'fan_profiles/$uid';

  // ─── Predictions ──────────────────────────────────────────────────────
  /// Bir maça yapılan tüm tahminler
  static String predictions(String matchId) => 'predictions/$matchId';

  /// Belirli kullanıcının bir maçtaki tahmini
  static String userPrediction(String matchId, String uid) =>
      'predictions/$matchId/user_predictions/$uid';

  // ─── Leaderboard ──────────────────────────────────────────────────────
  static const String leaderboard = 'leaderboard/global';
  static const String weeklyLeaderboard = 'leaderboard/weekly';

  // ─── Rate Limits ──────────────────────────────────────────────────────
  /// Rate limit dökümanı (uid ile)
  static String rateLimit(String uid) => 'rate_limits/$uid';

  // ─── FCM Tokens ───────────────────────────────────────────────────────
  /// Kullanıcı FCM token kaydı
  static String fcmToken(String uid) => 'fcm_tokens/$uid';
}
