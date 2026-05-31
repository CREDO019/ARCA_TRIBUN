import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maç sonu ekranı — özet, oyunun adamı, fan oylaması
class PostMatchScreen extends ConsumerWidget {
  const PostMatchScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailProvider(matchId));
    final events =
        ref.watch(matchEventsProvider(matchId)).valueOrNull ?? const [];
    final colors = context.arcaColors;

    return matchAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.background,
        body: const LoadingShimmer(itemCount: 4),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: colors.background,
        body: const ContentErrorState(),
      ),
      data: (match) {
        if (match == null) {
          return Scaffold(
            backgroundColor: colors.background,
            body: const BrandedEmptyState(
              icon: Icons.sports_score_outlined,
              title: 'Maç özeti hazırlanıyor',
              message:
                  'Karşılaşma özeti doğrulandığında detaylar burada yayınlanacak.',
            ),
          );
        }

        return _PostMatchContent(
          homeTeam: match.homeTeam,
          awayTeam: match.awayTeam,
          homeScore: match.homeScore,
          awayScore: match.awayScore,
          events: events,
        );
      },
    );
  }
}

class _PostMatchContent extends StatelessWidget {
  const _PostMatchContent({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.events,
  });

  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final List<MatchEventModel> events;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Maç Sonu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Final skor
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors.heroGradient),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  Text(
                    'MAÇ SONA ERDİ',
                    style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${homeScore ?? 0} - ${awayScore ?? 0}',
                    style: AppTypography.scoreDisplay,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '$homeTeam - $awayTeam',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.76),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text(
              'MAÇ OLAYLARI',
              style: AppTypography.labelSmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...events.map(
              (event) => Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Text(
                      _minuteText(event.minute),
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      event.type == MatchEventType.redCard
                          ? Icons.style
                          : Icons.sports_soccer,
                      color: AppColors.primaryRed,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: Text(event.detail ?? event.playerName)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Teknik direktörler: Çorum FK - Uğur Uçar, '
                      'Esenler Erokspor - Güray Gündoğdu.',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _minuteText(int minute) {
    return minute > 90 ? '90+${minute - 90}’' : '$minute’';
  }
}
