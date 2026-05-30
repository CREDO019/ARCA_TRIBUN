import 'package:equatable/equatable.dart';

/// Uygulama hata hiyerarşisinin temel sınıfı.
/// Tüm use case ve repository metodları [Either<Failure, T>] döner.
abstract class Failure extends Equatable {
  const Failure({required this.message, this.code});

  /// Kullanıcıya gösterilecek lokalize hata mesajı anahtarı
  final String message;

  /// Opsiyonel hata kodu (HTTP status, Firebase error code vb.)
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Ağ bağlantısı hatası
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'errors.no_connection',
    super.code,
  });
}

/// Sunucu taraflı hata (5xx, Firebase exceptions)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'errors.server_error',
    super.code,
  });
}

/// Yerel önbellek / Hive hatası
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'errors.cache_error',
    super.code,
  });
}

/// Kimlik doğrulama hatası
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'errors.auth_error',
    super.code,
  });
}

/// Doğrulama hatası (form alanları vb.)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Rate limit aşıldı
class RateLimitFailure extends Failure {
  const RateLimitFailure({
    super.message = 'errors.rate_limit',
    super.code = '429',
  });
}

/// Beklenmedik / bilinmeyen hata
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'errors.unknown',
    super.code,
  });
}
