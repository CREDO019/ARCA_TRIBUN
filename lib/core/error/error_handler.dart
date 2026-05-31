import 'package:arca_tribun/core/error/failure.dart';
import 'package:arca_tribun/core/error/sentry_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Tüm exception'ları [Failure] türlerine dönüştüren merkezi hata işleyici.
///
/// Supabase exception'ları:
/// - [AuthException] → kimlik doğrulama hataları
/// - [PostgrestException] → veritabanı/REST sorgu hataları
/// - [StorageException] → dosya yükleme hataları
/// - [RealtimeException] → gerçek zamanlı bağlantı hataları
class ErrorHandler {
  ErrorHandler._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    level: kDebugMode ? Level.debug : Level.error,
  );

  /// Herhangi bir exception'ı [Failure]'a dönüştür ve Sentry'e raporla.
  static Failure handleException(
    Object exception, {
    StackTrace? stackTrace,
    String? context,
  }) {
    final failure = _mapException(exception);

    _logger.e(
      '[ErrorHandler] ${context ?? 'Unknown context'}',
      error: exception,
      stackTrace: stackTrace,
    );

    // Sadece üretim hatalarını Sentry'e gönder
    if (!kDebugMode || failure is ServerFailure || failure is UnknownFailure) {
      SentryReporter.recordError(
        exception,
        stackTrace: stackTrace,
        context: context,
      );
    }

    return failure;
  }

  static Failure _mapException(Object exception) {
    // ── Supabase Auth hataları ─────────────────────────────────────────
    if (exception is AuthException) {
      return _mapAuthException(exception);
    }

    // ── Supabase PostgREST (veritabanı) hataları ──────────────────────
    if (exception is PostgrestException) {
      return _mapPostgrestException(exception);
    }

    // ── Supabase Storage hataları ──────────────────────────────────────
    if (exception is StorageException) {
      return ServerFailure(
        message: 'errors.storage_error',
        code: exception.statusCode,
      );
    }

    // ── Ağ bağlantısı hataları ─────────────────────────────────────────
    if (exception is NetworkException) {
      return const NetworkFailure();
    }

    return UnknownFailure(
      code: exception.toString(),
    );
  }

  /// Supabase Auth hata kodlarını [AuthFailure]'a map et.
  ///
  /// Tam liste: https://supabase.com/docs/reference/dart/auth-signinwithpassword
  static Failure _mapAuthException(AuthException e) {
    switch (e.statusCode) {
      case '400':
        // Geçersiz kimlik bilgileri
        if (e.message.contains('Invalid login credentials') ||
            e.message.contains('invalid_credentials')) {
          return const AuthFailure(message: 'errors.auth_invalid_credentials');
        }
        if (e.message.contains('Email not confirmed')) {
          return const AuthFailure(message: 'errors.auth_email_not_confirmed');
        }
        if (e.message.contains('Password should be at least')) {
          return const AuthFailure(message: 'errors.auth_weak_password');
        }
        return AuthFailure(code: e.statusCode);

      case '422':
        // Email zaten kayıtlı
        if (e.message.contains('already registered') ||
            e.message.contains('User already registered')) {
          return const AuthFailure(message: 'errors.auth_email_in_use');
        }
        return AuthFailure(code: e.statusCode);

      case '429':
        return const RateLimitFailure();

      case '503':
        return const NetworkFailure();

      default:
        return AuthFailure(
          code: e.statusCode ?? e.message,
        );
    }
  }

  /// Supabase PostgREST hata kodlarını [Failure]'a map et.
  ///
  /// PostgreSQL error codes: https://www.postgresql.org/docs/current/errcodes-appendix.html
  static Failure _mapPostgrestException(PostgrestException e) {
    switch (e.code) {
      case '42501': // insufficient_privilege
        return const AuthFailure(message: 'errors.permission_denied');

      case 'PGRST116': // Row not found (PostgREST)
        return const ServerFailure(message: 'errors.not_found');

      case '23505': // unique_violation
        return const ServerFailure(message: 'errors.duplicate_entry');

      case '54000': // too_many_connections / rate limit
        return const RateLimitFailure();

      default:
        // HTTP durum koduna göre
        if (e.message.contains('network') || e.message.contains('connection')) {
          return const NetworkFailure();
        }
        return ServerFailure(
          code: e.code,
        );
    }
  }
}

/// Ağ bağlantısı exception'ı (connectivity_plus ile kullanılır)
class NetworkException implements Exception {
  const NetworkException([this.message]);
  final String? message;

  @override
  String toString() =>
      'NetworkException: ${message ?? 'No internet connection'}';
}
