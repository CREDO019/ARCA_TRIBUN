/// Firebase Analytics olay isimleri — tüm takip edilecek kullanıcı aksiyonları.
/// Direkt string kullanım yasak: her zaman bu sınıftan al.
class EventNames {
  EventNames._();

  // ─── Auth Events ──────────────────────────────────────────────────────
  static const String loginSuccess = 'login_success';
  static const String loginFailure = 'login_failure';
  static const String registerSuccess = 'register_success';
  static const String logout = 'logout';
  static const String guestContinue = 'guest_continue';

  // ─── Screen Events ────────────────────────────────────────────────────
  static const String screenHome = 'screen_home';
  static const String screenMatchCenter = 'screen_match_center';
  static const String screenNews = 'screen_news';
  static const String screenNewsDetail = 'screen_news_detail';
  static const String screenFixtures = 'screen_fixtures';
  static const String screenStandings = 'screen_standings';
  static const String screenSquad = 'screen_squad';
  static const String screenPlayerDetail = 'screen_player_detail';
  static const String screenProfile = 'screen_profile';
  static const String screenLeaderboard = 'screen_leaderboard';
  static const String screenBadges = 'screen_badges';
  static const String screenNotificationPrefs = 'screen_notification_prefs';

  // ─── Match Events ─────────────────────────────────────────────────────
  static const String matchCenterOpened = 'match_center_opened';
  static const String liveMatchViewed = 'live_match_viewed';
  static const String matchEventViewed = 'match_event_viewed';

  // ─── Prediction Events ────────────────────────────────────────────────
  static const String predictionSubmitted = 'prediction_submitted';
  static const String predictionCorrect = 'prediction_correct';

  // ─── Fan Profile Events ───────────────────────────────────────────────
  static const String checkIn = 'fan_check_in';
  static const String badgeUnlocked = 'badge_unlocked';
  static const String leaderboardViewed = 'leaderboard_viewed';
  static const String fanLevelUp = 'fan_level_up';

  // ─── Content Events ───────────────────────────────────────────────────
  static const String newsRead = 'news_read';
  static const String newsShared = 'news_shared';
  static const String playerProfileViewed = 'player_profile_viewed';

  // ─── Notification Events ──────────────────────────────────────────────
  static const String notificationReceived = 'notification_received';
  static const String notificationTapped = 'notification_tapped';
  static const String notificationPermissionGranted =
      'notification_permission_granted';

  // ─── Error Events ─────────────────────────────────────────────────────
  static const String errorOccurred = 'error_occurred';
  static const String offlineModeEntered = 'offline_mode_entered';
  static const String offlineModeExited = 'offline_mode_exited';
}
