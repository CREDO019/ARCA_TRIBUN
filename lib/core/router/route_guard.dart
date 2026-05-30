import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'route_names.dart';

/// Kimlik doğrulama ve onboarding guard'ı.
///
/// Firebase Auth → Supabase Auth geçişi.
/// `FirebaseAuth.instance.currentUser` yerine
/// `Supabase.instance.client.auth.currentUser` kullanılır.
class RouteGuard {
  RouteGuard._();

  static final Logger _logger = Logger();

  /// Supabase auth client'ına kısa erişim
  static GotrouterUser? get _currentUser =>
      Supabase.instance.client.auth.currentUser;

  /// Auth guard — redirect fonksiyonu olarak kullanılır
  static String? authGuard(GoRouterState state) {
    final user = _currentUser;
    final isLoggedIn = user != null;
    final isGoingToAuth = state.matchedLocation.startsWith('/auth');
    final isGoingToOnboarding = state.matchedLocation == RouteNames.onboarding;
    final isGoingToSplash = state.matchedLocation == RouteNames.splash;

    // Splash ve onboarding her zaman erişilebilir
    if (isGoingToSplash || isGoingToOnboarding) return null;

    // Auth ekranlarına giden kullanıcı login'se → home'a yönlendir
    if (isGoingToAuth && isLoggedIn) {
      _logger.d('[RouteGuard] Already logged in, redirecting to home');
      return RouteNames.home;
    }

    // Korunan ekrana giden kullanıcı login değilse → login'e yönlendir
    if (!isGoingToAuth && !isLoggedIn) {
      _logger.d('[RouteGuard] Not logged in, redirecting to login');
      return RouteNames.login;
    }

    return null; // Yönlendirme gerekmiyor
  }

  /// Misafir (anonymous) kullanıcı kontrolü.
  ///
  /// Supabase'de anonymous kullanıcılar `user.isAnonymous` alanıyla belirlenir.
  static bool get isGuestUser {
    final user = _currentUser;
    if (user == null) return false;
    return user.isAnonymous;
  }

  /// Guest kullanıcı guard — yalnızca tam auth gerektiren özellikler için
  static bool isFullAuthRequired(String path) {
    const fullAuthPaths = [
      '/home/profile',
      '/home/profile/badges',
      '/home/profile/leaderboard',
      '/home/notifications',
    ];
    return fullAuthPaths.any((p) => path.startsWith(p));
  }
}

/// Supabase User tipi için alias (import sadeleştirme)
typedef GotrouterUser = User;
