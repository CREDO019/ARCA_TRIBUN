import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import 'user_model.dart';

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
