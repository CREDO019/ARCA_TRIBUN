import 'package:arca_tribun/core/audio/sound_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

/// Uygulama ön plandayken gelen FCM mesajlarını işler.
class ForegroundHandler {
  ForegroundHandler._();

  static final Logger _logger = Logger();

  /// Foreground message listener'ı başlat
  static void initialize() {
    FirebaseMessaging.onMessage.listen(_handle);
    _logger.d('[ForegroundHandler] Initialized');
  }

  static Future<void> _handle(RemoteMessage message) async {
    _logger.d('[ForegroundHandler] Received: ${message.messageId}');

    final type = message.data['type'] as String?;

    // Gol bildirimi geldiğinde ses çal
    if (type == 'GOAL') {
      await SoundManager.instance.playGoalSound();
    }
  }
}
