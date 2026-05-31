import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/features/match_center/presentation/live/widgets/live_score_header.dart';
import 'package:arca_tribun/features/match_center/presentation/live/widgets/live_stats_widget.dart';
import 'package:arca_tribun/features/match_center/presentation/live/widgets/match_events_list.dart';
import 'package:arca_tribun/features/match_center/presentation/live/widgets/possession_bar.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Canlı maç ekranı
class LiveScreen extends ConsumerWidget {
  const LiveScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(liveMatchProvider(matchId));
    final eventsAsync = ref.watch(matchEventsProvider(matchId));
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: liveAsync.when(
        loading: () => const LoadingShimmer(),
        error: (_, __) => const ContentErrorState(),
        data: (liveMatch) {
          if (liveMatch == null) {
            return const BrandedEmptyState(
              icon: Icons.sensors_outlined,
              title: 'Canlı yayın bekleniyor',
              message:
                  'Doğrulanmış maç olayları yayınlandığında burada görünecek.',
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
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Text(
                      'Maç olayları yüklenemedi.',
                      style: TextStyle(color: colors.textSecondary),
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
