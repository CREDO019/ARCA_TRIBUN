/// Firebase Performance Monitoring izleme isimleri.
/// Kritik kullanıcı operasyonlarının performansını ölçer.
class PerformanceTraces {
  PerformanceTraces._();

  // ─── Data Loading ─────────────────────────────────────────────────────
  static const String homeDataLoad = 'home_data_load';
  static const String matchCenterLoad = 'match_center_load';
  static const String newsListLoad = 'news_list_load';
  static const String standingsLoad = 'standings_load';
  static const String squadLoad = 'squad_load';

  // ─── Auth ─────────────────────────────────────────────────────────────
  static const String loginTime = 'login_time';
  static const String registerTime = 'register_time';

  // ─── Network Requests ─────────────────────────────────────────────────
  static const String firestoreQuery = 'firestore_query';
  static const String fcmTokenFetch = 'fcm_token_fetch';

  // ─── Rendering ────────────────────────────────────────────────────────
  static const String liveScoreRender = 'live_score_render';
  static const String goalCelebrationRender = 'goal_celebration_render';
}
