/// Tüm uygulama route isimlerini ve yollarını içerir.
/// Hiçbir yerde hardcode path kullanma, her zaman bu sınıftan al.
class RouteNames {
  RouteNames._();

  // ─── Root ─────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // ─── Auth ─────────────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // ─── Home Shell ───────────────────────────────────────────────────────
  static const String home = '/home';

  // ─── Match Center ─────────────────────────────────────────────────────
  static const String matchCenter = '/home/match-center/:matchId';
  static String matchCenterPath(String matchId) =>
      '/home/match-center/$matchId';

  // ─── News ─────────────────────────────────────────────────────────────
  static const String newsList = '/home/news';
  static const String newsDetail = '/home/news/:newsId';
  static String newsDetailPath(String newsId) => '/home/news/$newsId';

  // ─── Other Sections ───────────────────────────────────────────────────
  static const String fixtures = '/home/fixtures';
  static const String standings = '/home/standings';

  // ─── Squad ────────────────────────────────────────────────────────────
  static const String squad = '/home/squad';
  static const String playerDetail = '/home/squad/:playerId';
  static String playerDetailPath(String playerId) => '/home/squad/$playerId';

  // ─── Profile ──────────────────────────────────────────────────────────
  static const String profile = '/home/profile';
  static const String badges = '/home/profile/badges';
  static const String leaderboard = '/home/profile/leaderboard';

  // ─── Notifications ────────────────────────────────────────────────────
  static const String notificationPrefs = '/home/notifications';
}
