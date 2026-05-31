import 'package:arca_tribun/core/error/failure.dart';
import 'package:arca_tribun/features/auth/domain/user_model.dart';
import 'package:dartz/dartz.dart';

/// Auth repository soyut arayüzü.
/// Sunum katmanı bu arayüz üzerinden çalışır.
abstract class AuthRepository {
  /// E-posta ve şifre ile giriş
  Future<Either<Failure, UserModel>> loginWithEmail({
    required String email,
    required String password,
  });

  /// E-posta ve şifre ile kayıt
  Future<Either<Failure, UserModel>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Google ile giriş
  Future<Either<Failure, UserModel>> loginWithGoogle();

  /// Apple ile giriş
  Future<Either<Failure, UserModel>> loginWithApple();

  /// Misafir olarak giriş
  Future<Either<Failure, UserModel>> loginAsGuest();

  /// Mevcut kullanıcıyı al
  Future<Either<Failure, UserModel?>> getCurrentUser();

  /// Oturumu kapat
  Future<Either<Failure, void>> logout();

  /// Kullanıcı oturum durumu stream'i
  Stream<UserModel?> authStateChanges();

  /// Şifre sıfırlama e-postası gönder
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
}
