import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/storage/onboarding_preferences.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// İlk açılışta kulüp deneyimini tanıtan ve login akışına geçiş sağlayan ekran.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      assetPath: 'assets/images/onboarding/onboarding_1.jpg',
      eyebrow: 'ARCA ÇORUM FK',
      title: 'ARCA TRİBÜN’E\nHOŞ GELDİN',
      description:
          'Arca Çorum FK haberleri, maçları ve taraftar deneyimi artık cebinde.',
    ),
    _OnboardingPageData(
      assetPath: 'assets/images/onboarding/onboarding_2.jpg',
      eyebrow: 'MAÇ MERKEZİ',
      title: 'MAÇ GÜNÜNÜ\nKAÇIRMA',
      description: 'Fikstür, kadro, skor ve önemli gelişmeleri anlık takip et.',
    ),
    _OnboardingPageData(
      assetPath: 'assets/images/onboarding/onboarding_3.jpg',
      eyebrow: 'TARAFTAR DENEYİMİ',
      title: 'TRİBÜNÜN\nDİJİTAL EVİ',
      description:
          'Taraftar anketleri, bildirimler ve özel içeriklerle takıma daha yakın ol.',
    ),
    _OnboardingPageData(
      assetPath: 'assets/images/onboarding/onboarding_4.jpg',
      eyebrow: 'BİZİM HİKAYEMİZ',
      title: 'KIRMIZI\nSİYAH RUH',
      description: 'Şehrinin takımını her an yanında taşı.',
    ),
  ];

  final PageController _pageController = PageController();
  int _activePage = 0;

  bool get _isLastPage => _activePage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToLogin() async {
    await OnboardingPreferences.markAsSeen();
    if (!mounted) return;
    context.go(RouteNames.login);
  }

  Future<void> _handlePrimaryAction() async {
    if (_isLastPage) {
      await _goToLogin();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            key: const Key('onboarding_page_view'),
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (page) => setState(() => _activePage = page),
            itemBuilder: (context, index) => _OnboardingPage(
              data: _pages[index],
            ),
          ),
          Positioned(
            right: AppSpacing.screenPadding,
            bottom: 0,
            left: AppSpacing.screenPadding,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _OnboardingFooter(
                activePage: _activePage,
                pageCount: _pages.length,
                isLastPage: _isLastPage,
                onSkip: _goToLogin,
                onPrimaryAction: _handlePrimaryAction,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _OnboardingBackground(assetPath: data.assetPath),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  data.eyebrow,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primaryRedLight,
                    letterSpacing: 2.4,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  data.title,
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 46,
                    height: 0.94,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Text(
                    data.description,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.white.withValues(alpha: 0.78),
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 174),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF220000),
                AppColors.deepBlack,
                AppColors.background,
              ],
            ),
          ),
        ),
        Image.asset(
          assetPath,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => const SizedBox.expand(),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.42, 0.72, 1],
              colors: [
                Color(0xA6000000),
                Color(0x33000000),
                Color(0xB8090909),
                AppColors.background,
              ],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0, 0.58],
              colors: [
                Color(0x803D0000),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingFooter extends StatelessWidget {
  const _OnboardingFooter({
    required this.activePage,
    required this.pageCount,
    required this.isLastPage,
    required this.onSkip,
    required this.onPrimaryAction,
  });

  final int activePage;
  final int pageCount;
  final bool isLastPage;
  final VoidCallback onSkip;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var index = 0; index < pageCount; index++) ...[
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: index == activePage ? AppSpacing.xxl : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: index == activePage
                      ? AppColors.primaryRed
                      : AppColors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
              if (index != pageCount - 1) const SizedBox(width: AppSpacing.sm),
            ],
            const Spacer(),
            Text(
              '0${activePage + 1} / 0$pageCount',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.62),
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            if (!isLastPage)
              TextButton(
                key: const Key('onboarding_skip'),
                onPressed: onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.white.withValues(alpha: 0.82),
                  minimumSize: const Size(72, AppSpacing.buttonHeight),
                ),
                child: const Text('ATLA'),
              )
            else
              const SizedBox(width: 72),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton(
                key: const Key('onboarding_primary_action'),
                onPressed: onPrimaryAction,
                child: Text(isLastPage ? 'GİRİŞ YAP' : 'DEVAM ET'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.assetPath,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String assetPath;
  final String eyebrow;
  final String title;
  final String description;
}
