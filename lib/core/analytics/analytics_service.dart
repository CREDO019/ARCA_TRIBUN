import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../../supabase_config.dart';
import 'event_names.dart';

/// Mixpanel Analytics için merkezi soyutlama katmanı.
///
/// Firebase Analytics → Mixpanel geçişi.
/// API yüzeyi (logEvent, logScreen, setUserId) aynı kaldığından
/// sunum katmanında hiçbir değişiklik yapılmaz.
///
/// Token boşsa tüm çağrılar sessizce yok sayılır (stub mod).
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  static final Logger _logger = Logger();

  Mixpanel? _mixpanel;
  bool _isInitialized = false;

  /// Mixpanel'i başlat — main.dart'tan çağrılmalı.
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (SupabaseConfig.mixpanelToken.isEmpty ||
        SupabaseConfig.mixpanelToken == 'YOUR_MIXPANEL_TOKEN') {
      _logger.w('[Analytics] Mixpanel token not set, running in stub mode');
      _isInitialized = true;
      return;
    }

    try {
      _mixpanel = await Mixpanel.init(
        SupabaseConfig.mixpanelToken,
        optOutTrackingDefault: false,
        trackAutomaticEvents: true,
      );
      _isInitialized = true;
      _logger.i('[Analytics] Mixpanel initialized');
    } catch (e) {
      _logger.w('[Analytics] Mixpanel init failed: $e');
    }
  }

  // ─── Screen Tracking ──────────────────────────────────────────────────

  /// Ekran geçişini logla
  Future<void> logScreen(String screenName, {String? screenClass}) async {
    if (_mixpanel == null) return;
    try {
      _mixpanel!.track('screen_view', properties: {
        'screen_name': screenName,
        'screen_class': screenClass ?? screenName,
      });
      _logger.d('[Analytics] Screen: $screenName');
    } catch (e) {
      _logger.w('[Analytics] logScreen failed: $e');
    }
  }

  // ─── Event Tracking ───────────────────────────────────────────────────

  /// Genel olay logla
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (_mixpanel == null) return;
    try {
      _mixpanel!.track(name, properties: parameters);
      _logger.d('[Analytics] Event: $name, params: $parameters');
    } catch (e) {
      _logger.w('[Analytics] logEvent failed: $e');
    }
  }

  // ─── Auth Events ──────────────────────────────────────────────────────

  Future<void> logLogin(String method) async {
    await logEvent(EventNames.loginSuccess, parameters: {'method': method});
  }

  Future<void> logSignUp(String method) async {
    await logEvent(EventNames.registerSuccess, parameters: {'method': method});
  }

  Future<void> setUserId(String? uid) async {
    if (_mixpanel == null) return;
    if (uid != null) {
      _mixpanel!.identify(uid);
    } else {
      _mixpanel!.reset();
    }
  }

  // ─── Prediction Events ────────────────────────────────────────────────

  Future<void> logPredictionSubmitted(String matchId) async {
    await logEvent(
      EventNames.predictionSubmitted,
      parameters: {'match_id': matchId},
    );
  }

  // ─── Content Events ───────────────────────────────────────────────────

  Future<void> logNewsRead(String newsId, String title) async {
    await logEvent(
      EventNames.newsRead,
      parameters: {'news_id': newsId, 'title': title},
    );
  }

  // ─── Fan Profile Events ───────────────────────────────────────────────

  Future<void> logBadgeUnlocked(String badgeId) async {
    await logEvent(
      EventNames.badgeUnlocked,
      parameters: {'badge_id': badgeId},
    );
  }

  Future<void> logFanLevelUp(int newLevel) async {
    await logEvent(
      EventNames.fanLevelUp,
      parameters: {'new_level': newLevel},
    );
  }

  // ─── Error Events ─────────────────────────────────────────────────────

  Future<void> logError(String errorType, String context) async {
    await logEvent(
      EventNames.errorOccurred,
      parameters: {'error_type': errorType, 'context': context},
    );
  }

  /// Debug build'de tüm analitik olayları konsola logla
  void enableDebugLogging() {
    if (!kDebugMode) return;
    _mixpanel?.setLoggingEnabled(true);
  }
}
