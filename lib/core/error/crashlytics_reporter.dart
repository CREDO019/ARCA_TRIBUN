import 'package:arca_tribun/core/error/sentry_reporter.dart';
import 'package:flutter/foundation.dart';

/// Firebase Crashlytics → Sentry geçiş katmanı.
///
/// Bu dosya geriye dönük uyumluluk içindir.
/// Tüm çağrılar [SentryReporter]'a yönlendirilir.
/// Yeni kodda doğrudan [SentryReporter] kullanın.
@Deprecated('Use SentryReporter instead')
class CrashlyticsReporter {
  CrashlyticsReporter._();

  // ignore: avoid_setters_without_getters
  static set enabled(bool value) => SentryReporter.enabled = value;

  static Future<void> recordFlutterFatalError(FlutterErrorDetails details) =>
      SentryReporter.recordFlutterFatalError(details);

  static Future<void> recordFlutterError(FlutterErrorDetails details) =>
      SentryReporter.recordFlutterError(details);

  static Future<void> recordError(
    Object exception, {
    StackTrace? stackTrace,
    String? context,
    bool fatal = false,
  }) =>
      SentryReporter.recordError(
        exception,
        stackTrace: stackTrace,
        context: context,
        fatal: fatal,
      );

  static Future<void> setUserId(String uid) => SentryReporter.setUserId(uid);

  static Future<void> clearUserId() => SentryReporter.clearUserId();

  static Future<void> setCustomKey(String key, Object value) =>
      SentryReporter.setCustomKey(key, value);

  static Future<void> log(String message) => SentryReporter.log(message);
}
