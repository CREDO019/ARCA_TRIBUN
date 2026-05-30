import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/content_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../match_provider.dart';
import 'widgets/live_score_header.dart';
import 'widgets/live_stats_widget.dart';
import 'widgets/match_events_list.dart';
import 'widgets/possession_bar.dart';

/// Canlı maç ekranı
class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(liveMatchProvider(matchId));
    final eventsAsync = ref.watch(matchEventsProvider(matchId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: liveAsync.when(
        loading: () => const LoadingShimmer(),
        error: (_, __) => const ContentErrorState(),
        data: (liveMatch) {
          if (liveMatch == null) {
            return const BrandedEmptyState(
              icon: Icons.sensors_outlined,
              title: 'Canlı yayın bekleniyor',
              message: 'Maç başladığında anlık gelişmeler burada olacak.',
            );
          }

          return CustomScrollView(
            slivers: [
              // Canlı skor başlığı
              SliverToBoxAdapter(child: LiveScoreHeader(liveMatch: liveMatch)),

              // Topa sahip olma çubuğu
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: PossessionBar(
                    homePossession: liveMatch.homePossession,
                    awayPossession: liveMatch.awayPossession,
                  ),
                ),
              ),

              // İstatistikler
              SliverToBoxAdapter(
                child: LiveStatsWidget(liveMatch: liveMatch),
              ),

              // Maç olayları
              SliverToBoxAdapter(
                child: eventsAsync.when(
                  loading: () => const LoadingShimmer(),
                  error: (_, __) => const Padding(
                    padding: EdgeInsets.all(AppSpacing.screenPadding),
                    child: Text(
                      'Maç olayları yüklenemedi.',
                      style: TextStyle(color: AppColors.secondaryGray),
                    ),
                  ),
                  data: (events) => MatchEventsList(events: events),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
