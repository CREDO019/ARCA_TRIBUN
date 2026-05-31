import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Sentry entegrasyonu için merkezi hata raporlama servisi.
///
/// Firebase Crashlytics'in birebir karşılığıdır; tüm API yüzeyi
/// aynı kaldığından çağıran kod değiştirilmez.
///
/// Kullanım:
/// ```dart
/// SentryReporter.recordError(e, stackTrace: st, context: 'login');
/// SentryReporter.setUserId(user.uid);
/// ```
class SentryReporter {
  SentryReporter._();

  /// Hata raporlama aktif mi? Debug modda varsayılan olarak kapalı.
  static bool _isEnabled = !kDebugMode;

  /// Debug modda da raporlamayı etkinleştir (test amaçlı)
  // ignore: avoid_setters_without_getters
  static set enabled(bool value) => _isEnabled = value;

  /// Flutter framework hatalarını Sentry'e gönder (fatal)
  static Future<void> recordFlutterFatalError(
    FlutterErrorDetails details,
  ) async {
    if (!_isEnabled) return;
    await Sentry.captureException(
      details.exception,
      stackTrace: details.stack,
      hint: Hint.withMap({'fatal': true, 'context': 'flutter_fatal_error'}),
    );
  }

  /// Flutter framework hatalarını Sentry'e gönder (non-fatal)
  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (!_isEnabled) return;
    await Sentry.captureException(
      details.exception,
      stackTrace: details.stack,
    );
  }

  /// Genel exception raporla
  static Future<void> recordError(
    Object exception, {
    StackTrace? stackTrace,
    String? context,
    bool fatal = false,
  }) async {
    if (!_isEnabled) return;

    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: context != null
          ? Hint.withMap({'error_context': context, 'fatal': fatal})
          : null,
    );
  }

  /// Kullanıcı ID'sini Sentry'e bağla (login sonrası)
  static Future<void> setUserId(String uid) async {
    if (!_isEnabled) return;
    Sentry.configureScope((scope) {
      scope.setUser(SentryUser(id: uid));
    });
  }

  /// Kullanıcı oturumu kapandığında ID'yi temizle
  static Future<void> clearUserId() async {
    if (!_isEnabled) return;
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Özel anahtar-değer çifti ekle (hata ayıklama için)
  static Future<void> setCustomKey(String key, Object value) async {
    if (!_isEnabled) return;
    Sentry.configureScope((scope) {
      scope.setTag(key, value.toString());
    });
  }

  /// Uygulama navigasyonu gibi önemli olayları logla (breadcrumb)
  static Future<void> log(String message) async {
    if (!_isEnabled) return;
    await Sentry.addBreadcrumb(
      Breadcrumb(message: message, timestamp: DateTime.now()),
    );
  }
}
