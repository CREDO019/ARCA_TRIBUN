/// Uygulama genelinde kullanılan sabitler.
/// Magic number kullanımını önlemek için tüm sabitler burada tanımlanır.
class AppConstants {
  AppConstants._();

  // ─── App Info ─────────────────────────────────────────────────────────
  static const String appName = 'ARCA Tribün';
  static const String clubName = 'Arca Çorum FK';
  static const String packageName = 'com.arcafk.arca_tribun';

  // ─── Firebase Topics ──────────────────────────────────────────────────
  static const String topicAllUsers = 'all_users';
  static const String topicGoalAlerts = 'match_goal_alerts';
  static const String topicMatchStart = 'match_start_alerts';
  static const String topicMatchEnd = 'match_end_alerts';
  static const String topicNews = 'news_alerts';

  // ─── Hive Box Names ───────────────────────────────────────────────────
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveBoxSyncQueue = 'sync_queue_box';
  static const String hiveBoxCache = 'cache_box';

  // ─── Hive Type Adapters ───────────────────────────────────────────────
  static const int hiveTypeSyncOperation = 1;
  static const int hiveTypeFanProfile = 2;

  // ─── Cache ────────────────────────────────────────────────────────────
  static const Duration cacheDurationNews = Duration(minutes: 15);
  static const Duration cacheDurationFixtures = Duration(hours: 1);
  static const Duration cacheDurationStandings = Duration(hours: 2);
  static const Duration cacheDurationSquad = Duration(hours: 6);

  // ─── Pagination ───────────────────────────────────────────────────────
  static const int pageSize = 20;
  static const int newsFeedPageSize = 15;

  // ─── Gamification ─────────────────────────────────────────────────────
  static const int pointsCorrectResult = 100;
  static const int pointsCorrectScore = 200;
  static const int pointsCheckIn = 10;
  static const int pointsFirstPrediction = 50;

  // Fan levels
  static const Map<int, String> fanLevelTitles = {
    1: 'Bronz',
    2: 'Gümüş',
    3: 'Altın',
    4: 'Platin',
    5: 'Efsane',
  };

  static const Map<int, int> fanLevelThresholds = {
    1: 0,
    2: 500,
    3: 1500,
    4: 3000,
    5: 6000,
  };

  // ─── Animation Durations ──────────────────────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
  static const Duration animExtraSlow = Duration(milliseconds: 800);

  /// Gol kutlama overlay süresi
  static const Duration goalCelebrationDuration = Duration(seconds: 3);

  /// Gol ses sekansı arası bekleme
  static const Duration goalSoundDelay = Duration(milliseconds: 800);

  // ─── Vibration Patterns ───────────────────────────────────────────────
  static const List<int> vibrationGoal = [0, 200, 100, 200, 100, 400];
  static const List<int> vibrationRedCard = [0, 500];
  static const List<int> vibrationNotification = [0, 100];

  // ─── Rate Limits ──────────────────────────────────────────────────────
  static const int rateLimitPredictionsPerMatch = 1;
  static const int rateLimitCheckInsPerDay = 1;
  static const int rateLimitGeneralPerMinute = 10;

  // ─── Network ──────────────────────────────────────────────────────────
  static const int maxSyncRetries = 3;
  static const Duration connectivityCheckInterval = Duration(seconds: 5);

  // ─── Supported Locales ────────────────────────────────────────────────
  static const List<String> supportedLocales = ['tr', 'en', 'de', 'ar'];
  static const String defaultLocale = 'tr';

  // ─── Deep Link Paths ──────────────────────────────────────────────────
  static const String deepLinkScheme = 'arcatribun';
  static const String deepLinkHost = 'app';
}
