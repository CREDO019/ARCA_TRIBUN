import 'package:arca_tribun/core/error/error_handler.dart';
import 'package:arca_tribun/core/error/failure.dart';
import 'package:arca_tribun/features/auth/domain/auth_repository.dart';
import 'package:arca_tribun/features/auth/domain/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// AuthRepository implementasyonu — Supabase Auth kullanır.
///
/// Firebase Auth → Supabase Auth geçişi.
/// Domain arayüzü ([AuthRepository]) ve [UserModel] hiç değişmedi;
/// sadece bu implementasyon dosyası güncellendi.
///
/// Desteklenen giriş yöntemleri:
/// - E-posta + şifre
/// - Google (OAuth via google_sign_in + Supabase idToken)
/// - Apple (OAuth via sign_in_with_apple + Supabase idToken)
/// - Misafir (anonymous)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    SupabaseClient? supabaseClient,
    GoogleSignIn? googleSignIn,
  })  : _supabase = supabaseClient ?? Supabase.instance.client,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final SupabaseClient _supabase;
  final GoogleSignIn _googleSignIn;
  static final Logger _logger = Logger();

  // ─── E-posta / Şifre ──────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserModel>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure());
      }
      return Right(_mapUser(user));
    } catch (e, st) {
      _logger.e(
        '[AuthRepository] Email login failed',
        error: e,
        stackTrace: st,
      );
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'loginWithEmail',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName, 'full_name': displayName},
      );
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure());
      }
      if (response.session == null) {
        return const Left(
          AuthFailure(message: 'errors.auth_confirmation_required'),
        );
      }
      return Right(_mapUser(user, displayNameOverride: displayName));
    } catch (e, st) {
      _logger.e('[AuthRepository] Register failed', error: e, stackTrace: st);
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'registerWithEmail',
        ),
      );
    }
  }

  // ─── Google Sign-In ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Left(AuthFailure(message: 'errors.auth_cancelled'));
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        return const Left(AuthFailure(message: 'errors.auth_google_token'));
      }

      // Supabase'e Google ID Token ile giriş
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure());
      }

      return Right(_mapUser(user));
    } catch (e, st) {
      _logger.e(
        '[AuthRepository] Google login failed',
        error: e,
        stackTrace: st,
      );
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'loginWithGoogle',
        ),
      );
    }
  }

  // ─── Apple Sign-In ────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserModel>> loginWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = appleCredential.identityToken;
      if (idToken == null) {
        return const Left(AuthFailure(message: 'errors.auth_apple_token'));
      }

      // Supabase'e Apple ID Token ile giriş
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: appleCredential.authorizationCode,
      );

      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure());
      }

      // Apple sadece ilk girişte ad soyad verir; metadata'ya kaydet
      final fullName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].where((e) => e != null).join(' ');

      if (fullName.isNotEmpty) {
        await _supabase.auth.updateUser(
          UserAttributes(
            data: {'display_name': fullName, 'full_name': fullName},
          ),
        );
      }

      return Right(_mapUser(user));
    } catch (e, st) {
      _logger.e(
        '[AuthRepository] Apple login failed',
        error: e,
        stackTrace: st,
      );
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'loginWithApple',
        ),
      );
    }
  }

  // ─── Misafir Girişi ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserModel>> loginAsGuest() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure());
      }
      return Right(_mapUser(user, isGuest: true));
    } catch (e, st) {
      _logger.e(
        '[AuthRepository] Guest login failed',
        error: e,
        stackTrace: st,
      );
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'loginAsGuest',
        ),
      );
    }
  }

  // ─── Mevcut Kullanıcı ────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return const Right(null);
    return Right(_mapUser(user, isGuest: user.isAnonymous));
  }

  // ─── Oturum Kapatma ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _supabase.auth.signOut();
      await _signOutGoogleQuietly();
      return const Right(null);
    } catch (e, st) {
      return Left(
        ErrorHandler.handleException(e, stackTrace: st, context: 'logout'),
      );
    }
  }

  // ─── Hesap Silme ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      if (_supabase.auth.currentUser == null) {
        return const Left(AuthFailure());
      }

      await _supabase.functions.invoke('delete-account');
      await _supabase.auth.signOut();
      await _signOutGoogleQuietly();
      return const Right(null);
    } catch (e, st) {
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'deleteAccount',
        ),
      );
    }
  }

  // ─── Auth Durum Stream'i ──────────────────────────────────────────────

  @override
  Stream<UserModel?> authStateChanges() {
    // Supabase onAuthStateChange → UserModel stream
    return _supabase.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return _mapUser(user, isGuest: user.isAnonymous);
    });
  }

  // ─── Şifre Sıfırlama ─────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (e, st) {
      return Left(
        ErrorHandler.handleException(
          e,
          stackTrace: st,
          context: 'sendPasswordResetEmail',
        ),
      );
    }
  }

  // ─── Private Helpers ──────────────────────────────────────────────────

  Future<void> _signOutGoogleQuietly() async {
    try {
      await _googleSignIn.signOut();
    } catch (error, stackTrace) {
      _logger.w(
        '[AuthRepository] Google sign-out cleanup failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Supabase [User]'ı domain [UserModel]'ine dönüştür.
  UserModel _mapUser(
    User user, {
    bool? isGuest,
    String? displayNameOverride,
  }) {
    final meta = user.userMetadata ?? {};
    final displayName = displayNameOverride ??
        (meta['display_name'] as String?) ??
        (meta['full_name'] as String?) ??
        (meta['name'] as String?) ??
        user.email?.split('@').first ??
        'Taraftar';

    return UserModel(
      uid: user.id,
      email: user.email,
      displayName: displayName,
      isGuest: isGuest ?? user.isAnonymous,
      photoUrl: meta['avatar_url'] as String?,
    );
  }
}
