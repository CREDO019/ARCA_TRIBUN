import 'package:arca_tribun/core/notifications/notification_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

/// Uygulama tamamen kapalıyken (terminated) bildirime tıklanınca çalışır.
class TerminatedHandler {
  TerminatedHandler._();

  static final Logger _logger = Logger();

  /// Uygulama başlangıcında çağrılmalı — bildirimden açıldıysa yönlendir
  static Future<void> initialize() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _logger.i(
        '[TerminatedHandler] App opened from notification: ${initialMessage.messageId}',
      );
      NotificationRouter.instance.route(initialMessage.data);
    }
  }
}
