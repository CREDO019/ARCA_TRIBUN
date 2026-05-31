import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/storage/onboarding_preferences.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/auth/presentation/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash ekranı — uygulama açılışında gösterilir.
/// Auth durumunu kontrol ederek yönlendirme yapar.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scaleIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleIn = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _navigate();
  }

  Future<void> _navigate() async {
    // Splash süresi
    await Future<void>.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    final hasSeenOnboarding = await OnboardingPreferences.hasSeenOnboarding();

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      context.go(RouteNames.onboarding);
      return;
    }

    final user = await ref.read(authNotifierProvider.future);

    if (!mounted) return;

    if (user != null) {
      context.go(RouteNames.home);
    } else {
      context.go(RouteNames.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) => FadeTransition(
            opacity: _fadeIn,
            child: ScaleTransition(
              scale: _scaleIn,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sports_soccer,
                      color: AppColors.white,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('ARCA Tribün', style: AppTypography.displayMedium),
                  const SizedBox(height: 8),
                  Text('Arca Çorum FK', style: AppTypography.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
