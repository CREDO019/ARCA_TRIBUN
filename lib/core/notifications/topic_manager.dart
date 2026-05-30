import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';

/// FCM konularına (topics) abone olma/çıkma işlemlerini yönetir.
class TopicManager {
  TopicManager._();

  static final TopicManager instance = TopicManager._();

  static final Logger _logger = Logger();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  /// Tüm kullanıcıların abone olacağı varsayılan konular
  Future<void> subscribeToDefaultTopics() async {
    await subscribeToTopic(AppConstants.topicAllUsers);
    await subscribeToTopic(AppConstants.topicGoalAlerts);
    await subscribeToTopic(AppConstants.topicNews);
    _logger.i('[TopicManager] Subscribed to default topics');
  }

  /// Belirli bir konuya abone ol
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      _logger.d('[TopicManager] Subscribed: $topic');
    } catch (e) {
      _logger.e('[TopicManager] Subscribe failed: $topic - $e');
    }
  }

  /// Belirli bir konudan çık
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      _logger.d('[TopicManager] Unsubscribed: $topic');
    } catch (e) {
      _logger.e('[TopicManager] Unsubscribe failed: $topic - $e');
    }
  }

  /// Belirli bir maç bildirimlerine abone ol
  Future<void> subscribeToMatch(String matchId) async {
    await subscribeToTopic('match_$matchId');
  }

  /// Maç bildirimlerinden çık
  Future<void> unsubscribeFromMatch(String matchId) async {
    await unsubscribeFromTopic('match_$matchId');
  }

  /// Gol bildirimleri tercihine göre abone ol/çık
  Future<void> setGoalAlertsEnabled({required bool enabled}) async {
    if (enabled) {
      await subscribeToTopic(AppConstants.topicGoalAlerts);
    } else {
      await unsubscribeFromTopic(AppConstants.topicGoalAlerts);
    }
  }

  /// Haber bildirimleri tercihine göre abone ol/çık
  Future<void> setNewsAlertsEnabled({required bool enabled}) async {
    if (enabled) {
      await subscribeToTopic(AppConstants.topicNews);
    } else {
      await unsubscribeFromTopic(AppConstants.topicNews);
    }
  }

  /// Maç başlangıç bildirimleri
  Future<void> setMatchStartAlertsEnabled({required bool enabled}) async {
    if (enabled) {
      await subscribeToTopic(AppConstants.topicMatchStart);
    } else {
      await unsubscribeFromTopic(AppConstants.topicMatchStart);
    }
  }
}
