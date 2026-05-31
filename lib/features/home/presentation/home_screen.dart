import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/pilot/pilot_data.dart';
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
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ana ekran — taraftar dashboard
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingMatches = ref.watch(upcomingMatchesProvider).valueOrNull;
    final nextMatch = upcomingMatches != null && upcomingMatches.isNotEmpty
        ? upcomingMatches.first
        : null;
    final isSeasonStart = nextMatch?.id == PilotData.seasonStartMatchId;
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ─── App Bar ────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 60,
                floating: true,
                backgroundColor: colors.background,
                title: Row(
                  children: [
                    const ClubLogo(size: 34),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'ARCA TRİBÜN',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
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
                    NextMatchCountdown(
                      matchTime: nextMatch?.kickoffTime,
                      title: isSeasonStart
                          ? 'Yeni Sezon Başlangıcı'
                          : 'Sıradaki Maç',
                      description: isSeasonStart
                          ? 'Süper Lig 2026/2027 sezonu başlangıç haftası.'
                          : null,
                    ),
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
    final colors = context.arcaColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors.heroGradient,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const ClubLogo(size: 52),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ARCA TRİBÜN',
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const PilotDemoBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Takımına dair gelişmeler burada seninle buluşacak.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
