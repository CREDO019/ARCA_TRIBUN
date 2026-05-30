import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/content_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../domain/match_model.dart';
import 'live/live_screen.dart';
import 'match_provider.dart';
import 'post_match/post_match_screen.dart';
import 'pre_game/pre_game_screen.dart';

/// Maç merkezi ekranı — duruma göre alt ekran gösterir.
/// matchStatusProvider → preGame / live+halfTime / postMatch
class MatchCenterScreen extends ConsumerWidget {
  const MatchCenterScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(matchStatusProvider(matchId));

    return statusAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingShimmer(),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColors.background,
        body: ContentErrorState(),
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
            key: const ValueKey('postMatch'), matchId: matchId);
      case MatchStatus.cancelled:
        return Scaffold(
          key: const ValueKey('cancelled'),
          backgroundColor: AppColors.background,
          body: const Center(
            child: Text('Maç iptal edildi.',
                style: TextStyle(color: AppColors.white)),
          ),
        );
    }
  }
}
