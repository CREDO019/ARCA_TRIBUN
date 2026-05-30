import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/offline_banner.dart';
import 'widgets/fan_prediction_strip.dart';
import 'widgets/live_match_hero_card.dart';
import 'widgets/news_horizontal_scroll.dart';
import 'widgets/next_match_countdown.dart';
import 'widgets/standings_mini_card.dart';
import 'widgets/store_banner_card.dart';

/// Ana ekran — taraftar dashboard
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                pinned: false,
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
                      child: const Icon(Icons.sports_soccer,
                          size: 18, color: AppColors.white),
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
                    // Canlı Maç Hero Kartı
                    const LiveMatchHeroCard(),
                    const SizedBox(height: AppSpacing.xl),

                    // Sıradaki Maç Sayacı
                    const NextMatchCountdown(),
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
