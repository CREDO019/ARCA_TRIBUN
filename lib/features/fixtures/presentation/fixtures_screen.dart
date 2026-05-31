import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Fikstür ekranı — yaklaşan ve geçmiş maçlar
class FixturesScreen extends ConsumerWidget {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingAsync = ref.watch(upcomingMatchesProvider);
    final recentAsync = ref.watch(recentMatchesProvider);
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Fikstür')),
      body: upcomingAsync.when(
        loading: () => const LoadingShimmer(itemCount: 6),
        error: (_, __) => ContentErrorState(
          onRetry: () {
            ref.invalidate(upcomingMatchesProvider);
            ref.invalidate(recentMatchesProvider);
          },
        ),
        data: (upcomingMatches) => recentAsync.when(
          loading: () => const LoadingShimmer(itemCount: 6),
          error: (_, __) => ContentErrorState(
            onRetry: () {
              ref.invalidate(upcomingMatchesProvider);
              ref.invalidate(recentMatchesProvider);
            },
          ),
          data: (recentMatches) {
            final fixtures = <MatchModel>[
              ...upcomingMatches,
              ...recentMatches,
            ];

            if (fixtures.isEmpty) {
              return const BrandedEmptyState(
                icon: Icons.calendar_month_outlined,
                title: 'Fikstür hazırlanıyor',
                message:
                    'Maç verileri kulüp tarafından doğrulandığında yayınlanacak.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: fixtures.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final match = fixtures[index];
                return GestureDetector(
                  onTap: () =>
                      context.push(RouteNames.matchCenterPath(match.id)),
                  child: _FixtureTile(match: match),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FixtureTile extends StatelessWidget {
  const _FixtureTile({required this.match});

  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    final date = match.kickoffTime;
    final hasScore = match.homeScore != null && match.awayScore != null;
    final colors = context.arcaColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Text('${date.day}', style: AppTypography.headlineMedium),
                Text(
                  _monthShort(date.month),
                  style: AppTypography.labelSmall
                      .copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${match.homeTeam} vs ${match.awayTeam}',
                  style: AppTypography.titleMedium,
                ),
                Text(
                  match.competition ?? 'Lig',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          if (hasScore)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                '${match.homeScore} - ${match.awayScore}',
                style: AppTypography.titleMedium
                    .copyWith(color: AppColors.primaryRed),
              ),
            )
          else
            Text(
              '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
              style: AppTypography.bodyMedium,
            ),
        ],
      ),
    );
  }
}

String _monthShort(int month) => [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ][month];
