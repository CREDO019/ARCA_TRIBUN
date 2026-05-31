import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/home/presentation/widgets/fan_prediction_strip.dart';
import 'package:arca_tribun/features/home/presentation/widgets/live_match_hero_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/news_horizontal_scroll.dart';
import 'package:arca_tribun/features/home/presentation/widgets/next_match_countdown.dart';
import 'package:arca_tribun/features/home/presentation/widgets/standings_mini_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/store_banner_card.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/shared/widgets/offline_banner.dart';
import 'package:arca_tribun/shared/widgets/pilot_demo_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ana ekran — taraftar dashboard
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingMatches = ref.watch(upcomingMatchesProvider).valueOrNull;
    final nextMatchTime =
        (upcomingMatches != null && upcomingMatches.isNotEmpty)
            ? upcomingMatches.first.kickoffTime
            : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ─── App Bar ────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 60,
                floating: true,
                backgroundColor: AppColors.background,
                title: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: const Icon(
                        Icons.sports_soccer,
                        size: 18,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('ARCA Tribün', style: AppTypography.headlineMedium),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => context.push(RouteNames.notificationPrefs),
                  ),
                ],
              ),

              // ─── Content ─────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _HomeWelcomeCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // Canlı Maç Hero Kartı
                    const LiveMatchHeroCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // Sıradaki Maç Sayacı
                    NextMatchCountdown(matchTime: nextMatchTime),
                    const SizedBox(height: AppSpacing.xl),

                    // Taraftar Tahmini
                    const FanPredictionStrip(),
                    const SizedBox(height: AppSpacing.xl),

                    // Puan Durumu Mini Kart
                    const StandingsMiniCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // Son Haberler
                    const NewsHorizontalScroll(),
                    const SizedBox(height: AppSpacing.xl),

                    // Mağaza Banner
                    const StoreBannerCard(),
                    const SizedBox(height: AppSpacing.massive),
                  ]),
                ),
              ),
            ],
          ),

          // Offline banner üstte göster
          const Positioned(top: 0, left: 0, right: 0, child: OfflineBanner()),
        ],
      ),
    );
  }
}

class _HomeWelcomeCard extends StatelessWidget {
  const _HomeWelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.heroGradient,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(
                'AT',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('ARCA TRİBÜN', style: AppTypography.headlineMedium),
                    const SizedBox(width: AppSpacing.sm),
                    const PilotDemoBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Takımına dair gelişmeler burada seninle buluşacak.',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
