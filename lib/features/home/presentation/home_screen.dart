import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/features/home/presentation/widgets/fan_prediction_strip.dart';
import 'package:arca_tribun/features/home/presentation/widgets/live_match_hero_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/matchday_assistant_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/news_horizontal_scroll.dart';
import 'package:arca_tribun/features/home/presentation/widgets/squad_mini_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/standings_mini_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/store_banner_card.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:arca_tribun/shared/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Ana ekran — taraftar dashboard
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingMatches = ref.watch(upcomingMatchesProvider).valueOrNull;
    final recentMatches = ref.watch(recentMatchesProvider).valueOrNull;
    final nextMatch = upcomingMatches != null && upcomingMatches.isNotEmpty
        ? upcomingMatches.first
        : null;
    final recentMatch = recentMatches != null && recentMatches.isNotEmpty
        ? recentMatches.first
        : null;
    final liveMatch = ref.watch(currentLiveMatchProvider).valueOrNull;
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    MatchdayAssistantCard(
                      upcomingMatch: nextMatch,
                      liveMatch: liveMatch,
                      recentMatch: recentMatch,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const LiveMatchHeroCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const NewsHorizontalScroll(),
                    const SizedBox(height: AppSpacing.xl),
                    const StandingsMiniCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const SquadMiniCard(),
                    const SizedBox(height: AppSpacing.xl),
                    const FanPredictionStrip(),
                    const SizedBox(height: AppSpacing.xl),
                    const StoreBannerCard(),
                    const SizedBox(height: AppSpacing.massive),
                  ]),
                ),
              ),
            ],
          ),
          const Positioned(top: 0, left: 0, right: 0, child: OfflineBanner()),
        ],
      ),
    );
  }
}
