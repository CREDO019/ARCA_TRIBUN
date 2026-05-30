import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_constants.dart';
import 'notification_channels.dart';
import 'notification_router.dart';

/// FCM top-level background handler (isolate dışında çalışmalı)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // FCM bu fonksiyonu ayrı bir isolate'de çalıştırır.
  // Supabase burada initialize edilmiş olmayabilir; sadece log at.
  debugPrint('[NotificationService] Background message: ${message.messageId}');
}

/// FCM ve yerel bildirimleri yöneten singleton servis.
///
/// Firebase Auth kaldırıldı ancak Firebase Messaging (FCM) push notification için korundu.
/// FCM token artık Supabase'deki `user_devices` tablosunda saklanır.
/// Auth değişimlerini Supabase onAuthStateChange stream'i üzerinden takip eder.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static final Logger _logger = Logger();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  bool _isInitialized = false;

  String? get fcmToken => _fcmToken;

  /// Bildirimleri başlat — main.dart'tan çağrılmalı
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _requestPermissions();
    await _initLocalNotifications();
    await _setupFCMToken();
    _setupHandlers();
    _listenAuthStateForTokenSync();

    _isInitialized = true;
    _logger.i('[NotificationService] Initialized successfully');
  }

  Future<void> _requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: false,
      provisional: false,
    );

    _logger.d(
      '[NotificationService] Permission: ${settings.authorizationStatus}',
    );

    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Android kanallarını oluştur
    await NotificationChannels.createAllChannels(_localNotifications);
  }

  Future<void> _setupFCMToken() async {
    _fcmToken = await _fcm.getToken();
    _logger.d('[NotificationService] FCM Token: $_fcmToken');

    // Token yenilenince Supabase'i güncelle
    _fcm.onTokenRefresh.listen((newToken) async {
      _fcmToken = newToken;
      _logger.d('[NotificationService] FCM Token refreshed: $newToken');
      await _saveFcmTokenToSupabase(newToken);
    });
  }

  /// Supabase Auth durumu değişince FCM token'ı senkronize et.
  ///
  /// - Login olunca: token'ı `user_devices` tablosuna kaydet
  /// - Logout olunca: token kaydını sil
  void _listenAuthStateForTokenSync() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        if (_fcmToken != null) {
          _saveFcmTokenToSupabase(_fcmToken!);
        }
      } else if (event == AuthChangeEvent.signedOut) {
        _removeFcmTokenFromSupabase();
      }
    });
  }

  /// FCM token'ı Supabase `user_devices` tablosuna kaydet (upsert)
  Future<void> _saveFcmTokenToSupabase(String token) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await Supabase.instance.client.from('user_devices').upsert({
        'user_id': userId,
        'fcm_token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'updated_at': DateTime.now().toIso8601String(),
      });
      _logger.d('[NotificationService] FCM token saved to Supabase');
    } catch (e) {
      _logger.w('[NotificationService] FCM token save failed: $e');
    }
  }

  /// Kullanıcı çıkış yaptığında FCM token kaydını temizle
  Future<void> _removeFcmTokenFromSupabase() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null || _fcmToken == null) return;

    try {
      await Supabase.instance.client
          .from('user_devices')
          .delete()
          .eq('user_id', userId)
          .eq('fcm_token', _fcmToken!);
      _logger.d('[NotificationService] FCM token removed from Supabase');
    } catch (e) {
      _logger.w('[NotificationService] FCM token removal failed: $e');
    }
  }

  void _setupHandlers() {
    // Uygulama ön plandayken gelen mesajlar
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Arka planda bildirim tıklanınca
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTapped);

    // Uygulama kapalıyken bildirim tıklanınca
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _onNotificationTapped(message);
      }
    });

    // Background handler (top-level fonksiyon)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _onForegroundMessage(RemoteMessage message) {
    _logger.d('[NotificationService] Foreground message: ${message.messageId}');

    final notification = message.notification;
    if (notification == null) return;

    final payload = message.data;
    final channelId = _resolveChannelId(payload['type'] as String?);

    _showLocalNotification(
      id: message.hashCode,
      title: notification.title ?? AppConstants.appName,
      body: notification.body ?? '',
      channelId: channelId,
      payload: message.data.toString(),
    );
  }

  void _onNotificationTapped(RemoteMessage message) {
    _logger
        .d('[NotificationService] Notification tapped: ${message.messageId}');
    NotificationRouter.instance.route(message.data);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;
    _logger.d('[NotificationService] Local notification tapped: $payload');
  }

  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  String _resolveChannelId(String? type) {
    switch (type) {
      case NotificationPayloadType.goal:
        return NotificationChannels.goalChannelId;
      case NotificationPayloadType.redCard:
      case NotificationPayloadType.matchEvent:
        return NotificationChannels.matchEventChannelId;
      case NotificationPayloadType.news:
        return NotificationChannels.newsChannelId;
      case NotificationPayloadType.campaign:
        return NotificationChannels.campaignChannelId;
      case NotificationPayloadType.matchEnd:
        return NotificationChannels.matchEndChannelId;
      default:
        return NotificationChannels.newsChannelId;
    }
  }
}

/// Bildirim payload tipleri
class NotificationPayloadType {
  NotificationPayloadType._();

  static const String goal = 'GOAL';
  static const String redCard = 'RED_CARD';
  static const String matchEvent = 'MATCH_EVENT';
  static const String news = 'NEWS';
  static const String campaign = 'CAMPAIGN';
  static const String matchEnd = 'MATCH_END';
  static const String matchStart = 'MATCH_START';
}
