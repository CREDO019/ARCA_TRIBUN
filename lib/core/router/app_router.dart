import 'dart:async';

import 'package:arca_tribun/core/notifications/notification_router.dart';
import 'package:arca_tribun/core/router/route_guard.dart';
import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/features/auth/presentation/login_screen.dart';
import 'package:arca_tribun/features/auth/presentation/register_screen.dart';
import 'package:arca_tribun/features/fan_profile/presentation/badges/badge_detail_screen.dart';
import 'package:arca_tribun/features/fan_profile/presentation/badges/badges_screen.dart';
import 'package:arca_tribun/features/fan_profile/presentation/leaderboard/leaderboard_screen.dart';
import 'package:arca_tribun/features/fan_profile/presentation/profile_screen.dart';
import 'package:arca_tribun/features/fixtures/presentation/fixtures_screen.dart';
import 'package:arca_tribun/features/home/presentation/home_screen.dart';
import 'package:arca_tribun/features/match_center/presentation/match_center_screen.dart';
import 'package:arca_tribun/features/news/presentation/news_detail_screen.dart';
import 'package:arca_tribun/features/news/presentation/news_list_screen.dart';
import 'package:arca_tribun/features/notification_preferences/presentation/notification_prefs_screen.dart';
import 'package:arca_tribun/features/onboarding/presentation/onboarding_screen.dart';
import 'package:arca_tribun/features/splash/presentation/splash_screen.dart';
import 'package:arca_tribun/features/squad/presentation/player_detail_screen.dart';
import 'package:arca_tribun/features/squad/presentation/squad_screen.dart';
import 'package:arca_tribun/features/standings/presentation/standings_screen.dart';
import 'package:arca_tribun/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uygulama navigasyon konfigürasyonu — go_router tabanlı.
/// ShellRoute ile bottom navigation bar paylaşımı sağlanır.
class AppRouter {
  AppRouter._();

  static final _authRefreshNotifier = _AuthRefreshNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    refreshListenable: _authRefreshNotifier,
    redirect: (context, state) => RouteGuard.authGuard(state),
    routes: [
      // ─── Splash ────────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const SplashScreen(),
        ),
      ),

      // ─── Onboarding ────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),

      // ─── Auth ──────────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        pageBuilder: (context, state) => _fadePage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        pageBuilder: (context, state) => _slidePage(
          state: state,
          child: const RegisterScreen(),
        ),
      ),

      // ─── Home Shell (Bottom Nav) ───────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            pageBuilder: (context, state) => _fadePage(
              state: state,
              child: const HomeScreen(),
            ),
            routes: [
              // Match Center
              GoRoute(
                path: 'match-center/:matchId',
                name: 'match-center',
                pageBuilder: (context, state) {
                  final matchId = state.pathParameters['matchId']!;
                  return _slidePage(
                    state: state,
                    child: MatchCenterScreen(matchId: matchId),
                  );
                },
              ),

              // News
              GoRoute(
                path: 'news',
                name: 'news',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const NewsListScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':newsId',
                    name: 'news-detail',
                    pageBuilder: (context, state) {
                      final newsId = state.pathParameters['newsId']!;
                      return _slidePage(
                        state: state,
                        child: NewsDetailScreen(newsId: newsId),
                      );
                    },
                  ),
                ],
              ),

              // Fixtures
              GoRoute(
                path: 'fixtures',
                name: 'fixtures',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const FixturesScreen(),
                ),
              ),

              // Standings
              GoRoute(
                path: 'standings',
                name: 'standings',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const StandingsScreen(),
                ),
              ),

              // Squad
              GoRoute(
                path: 'squad',
                name: 'squad',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const SquadScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':playerId',
                    name: 'player-detail',
                    pageBuilder: (context, state) {
                      final playerId = state.pathParameters['playerId']!;
                      return _slidePage(
                        state: state,
                        child: PlayerDetailScreen(playerId: playerId),
                      );
                    },
                  ),
                ],
              ),

              // Profile
              GoRoute(
                path: 'profile',
                name: 'profile',
                pageBuilder: (context, state) => _fadePage(
                  state: state,
                  child: const ProfileScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'badges',
                    name: 'badges',
                    pageBuilder: (context, state) => _slidePage(
                      state: state,
                      child: const BadgesScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path: ':badgeId',
                        name: 'badge-detail',
                        pageBuilder: (context, state) {
                          final badgeId = state.pathParameters['badgeId']!;
                          return _slidePage(
                            state: state,
                            child: BadgeDetailScreen(badgeId: badgeId),
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'leaderboard',
                    name: 'leaderboard',
                    pageBuilder: (context, state) => _slidePage(
                      state: state,
                      child: const LeaderboardScreen(),
                    ),
                  ),
                ],
              ),

              // Notification Prefs
              GoRoute(
                path: 'notifications',
                name: 'notifications',
                pageBuilder: (context, state) => _slidePage(
                  state: state,
                  child: const NotificationPrefsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF090909),
      body: Center(
        child: Text(
          'Sayfa bulunamadı: ${state.error}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );

  /// NotificationRouter'a navigasyon callback'ini kaydet
  static void setupNotificationRouting() {
    NotificationRouter.instance.setNavigateCallback(
      router.go,
    );
  }

  // ─── Page Transitions ─────────────────────────────────────────────────
  static CustomTransitionPage<void> _fadePage({
    required GoRouterState state,
    required Widget child,
  }) =>
      CustomTransitionPage<void>(
        key: state.pageKey,
        child: child,
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      );

  static CustomTransitionPage<void> _slidePage({
    required GoRouterState state,
    required Widget child,
  }) =>
      CustomTransitionPage<void>(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
      );
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (_) => notifyListeners(),
    );
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Bottom nav ile sarılmış scaffold — ShellRoute child'ı
class AppScaffoldWithNav extends StatelessWidget {
  const AppScaffoldWithNav({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
