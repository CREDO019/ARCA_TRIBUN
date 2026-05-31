import 'package:arca_tribun/core/notifications/notification_service.dart';
import 'package:logger/logger.dart';

/// Bildirim tıklamalarını doğru uygulama rotasına yönlendirir.
/// go_router ile deep link entegrasyonu sağlar.
class NotificationRouter {
  NotificationRouter._();

  static final NotificationRouter instance = NotificationRouter._();

  static final Logger _logger = Logger();

  /// Bekleyen navigasyon isteği (router hazır olana kadar)
  String? _pendingRoute;

  /// Navigasyon callback (AppRouter'dan set edilir)
  void Function(String route, {Map<String, dynamic>? extra})? _navigateCallback;

  /// AppRouter bağlandığında callback'i kaydet
  void setNavigateCallback(
    void Function(String, {Map<String, dynamic>? extra}) callback,
  ) {
    _navigateCallback = callback;

    // Bekleyen route varsa şimdi işle
    if (_pendingRoute != null) {
      callback(_pendingRoute!);
      _pendingRoute = null;
    }
  }

  /// Bildirim payload'ını parse et ve ilgili ekrana yönlendir
  void route(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final matchId = data['matchId'] as String?;
    final newsId = data['newsId'] as String?;

    _logger.d('[NotificationRouter] Routing: type=$type, matchId=$matchId');

    switch (type) {
      case NotificationPayloadType.goal:
      case NotificationPayloadType.redCard:
      case NotificationPayloadType.matchEvent:
      case NotificationPayloadType.matchStart:
      case NotificationPayloadType.matchEnd:
        if (matchId != null) {
          _navigate('/home/match-center/$matchId');
        } else {
          _navigate('/home');
        }
      case NotificationPayloadType.news:
        if (newsId != null) {
          _navigate('/home/news/$newsId');
        } else {
          _navigate('/home/news');
        }
      default:
        _navigate('/home');
    }
  }

  void _navigate(String route, {Map<String, dynamic>? extra}) {
    if (_navigateCallback != null) {
      _navigateCallback!(route, extra: extra);
    } else {
      // Router henüz hazır değil, beklet
      _pendingRoute = route;
      _logger.d('[NotificationRouter] Router not ready, queuing: $route');
    }
  }
}
