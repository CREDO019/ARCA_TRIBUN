import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Uygulama arka planda veya kapalıyken gelen FCM mesajlarını işler.
/// Bu fonksiyon top-level olmalı (sınıf metodu olamaz).
@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint('[BackgroundHandler] Message: ${message.messageId}');
  // Firebase zaten ana isolate'de başlatılmış
  // Arka planda yalnızca minimum işlem yap
}
