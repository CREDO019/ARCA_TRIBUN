import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Android bildirim kanalları.
/// Her bildirim tipi için özel ses, titreşim ve öncelik ayarları.
class NotificationChannels {
  NotificationChannels._();

  // ─── Channel IDs ──────────────────────────────────────────────────────
  static const String goalChannelId = 'GOL_CHANNEL';
  static const String matchEventChannelId = 'MAC_AYRINTISI_CHANNEL';
  static const String newsChannelId = 'HABER_CHANNEL';
  static const String campaignChannelId = 'KAMPANYA_CHANNEL';
  static const String matchEndChannelId = 'MAC_SONU_CHANNEL';

  // ─── Channel Definitions ──────────────────────────────────────────────
  static final AndroidNotificationChannel goalChannel =
      AndroidNotificationChannel(
    goalChannelId,
    'Gol Bildirimleri',
    description: 'Maç sırasında atılan goller için anlık bildirimler',
    importance: Importance.max,
    vibrationPattern: Int64List.fromList([0, 200, 100, 200]),
  );

  static const AndroidNotificationChannel matchEventChannel =
      AndroidNotificationChannel(
    matchEventChannelId,
    'Maç Ayrıntıları',
    description: 'Kırmızı kart, oyuncu değişikliği gibi maç olayları',
    importance: Importance.high,
  );

  static const AndroidNotificationChannel newsChannel =
      AndroidNotificationChannel(
    newsChannelId,
    'Haberler',
    description: 'Kulüp haberleri ve duyurular',
  );

  static const AndroidNotificationChannel campaignChannel =
      AndroidNotificationChannel(
    campaignChannelId,
    'Kampanyalar',
    description: 'Özel teklifler ve kampanyalar',
    importance: Importance.low,
    playSound: false,
    enableVibration: false,
  );

  static const AndroidNotificationChannel matchEndChannel =
      AndroidNotificationChannel(
    matchEndChannelId,
    'Maç Sonu',
    description: 'Maç sonu sonuçları ve özeti',
    importance: Importance.high,
  );

  /// Tüm kanalları oluştur (uygulama başlangıcında çağrılmalı)
  static Future<void> createAllChannels(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final channels = [
      goalChannel,
      matchEventChannel,
      newsChannel,
      campaignChannel,
      matchEndChannel,
    ];

    for (final channel in channels) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }
}
