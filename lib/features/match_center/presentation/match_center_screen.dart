import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/features/match_center/presentation/live/live_screen.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/features/match_center/presentation/post_match/post_match_screen.dart';
import 'package:arca_tribun/features/match_center/presentation/pre_game/pre_game_screen.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maç merkezi ekranı — duruma göre alt ekran gösterir.
/// matchStatusProvider → preGame / live+halfTime / postMatch
class MatchCenterScreen extends ConsumerWidget {
  const MatchCenterScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(matchStatusProvider(matchId));
    final colors = context.arcaColors;

    return statusAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.background,
        body: const LoadingShimmer(),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: colors.background,
        body: const ContentErrorState(),
      ),
      data: (status) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _buildScreen(status),
        );
      },
    );
  }

  Widget _buildScreen(MatchStatus status) {
    switch (status) {
      case MatchStatus.preGame:
      case MatchStatus.scheduled:
        return PreGameScreen(key: const ValueKey('preGame'), matchId: matchId);
      case MatchStatus.live:
      case MatchStatus.halfTime:
        return LiveScreen(key: const ValueKey('live'), matchId: matchId);
      case MatchStatus.postMatch:
        return PostMatchScreen(
          key: const ValueKey('postMatch'),
          matchId: matchId,
        );
      case MatchStatus.cancelled:
        return Builder(
          key: const ValueKey('cancelled'),
          builder: (context) => Scaffold(
            backgroundColor: context.arcaColors.background,
            body: Center(
              child: Text(
                'Maç iptal edildi.',
                style: TextStyle(color: context.arcaColors.textPrimary),
              ),
            ),
          ),
        );
    }
  }
}
