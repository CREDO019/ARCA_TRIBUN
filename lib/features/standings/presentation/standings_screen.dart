import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/standings/domain/standing_model.dart';
import 'package:arca_tribun/features/standings/presentation/standings_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Puan durumu ekranı — Süper Lig tablosu
class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(seasonStandingsProvider);
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Puan Durumu')),
      body: standingsAsync.when(
        loading: () => const LoadingShimmer(itemCount: 10),
        error: (_, __) => ContentErrorState(
          onRetry: () => ref.invalidate(seasonStandingsProvider),
        ),
        data: (teams) {
          if (teams.isEmpty) {
            return const BrandedEmptyState(
              icon: Icons.leaderboard_outlined,
              title: 'Puan durumu hazırlanıyor',
              message:
                  'Lig tablosu doğrulanmış veri kaynağına bağlandığında yayınlanacak.',
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        'KULÜP',
                        style: AppTypography.labelSmall
                            .copyWith(color: colors.textSecondary),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      child: Text(
                        'O',
                        style: AppTypography.labelSmall
                            .copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      child: Text(
                        'G',
                        style: AppTypography.labelSmall
                            .copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      child: Text(
                        'B',
                        style: AppTypography.labelSmall
                            .copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                      child: Text(
                        'M',
                        style: AppTypography.labelSmall
                            .copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        'P',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.primaryRed),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: colors.border, height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: teams.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: colors.border, height: 1),
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return _StandingRow(team: team);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StandingRow extends StatelessWidget {
  const _StandingRow({required this.team});

  final StandingModel team;

  @override
  Widget build(BuildContext context) {
    final isOurTeam = team.teamName.toLowerCase().contains('arca çorum');
    final colors = context.arcaColors;

    return Container(
      color: isOurTeam
          ? AppColors.primaryRed.withValues(alpha: 0.08)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text('${team.position}', style: AppTypography.bodyMedium),
          ),
          Expanded(
            child: Text(
              team.teamName,
              style: isOurTeam
                  ? AppTypography.titleMedium
                      .copyWith(color: AppColors.primaryRed)
                  : AppTypography.bodyMedium
                      .copyWith(color: colors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 25,
            child: Text(
              '${team.played}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 25,
            child: Text(
              '${team.won}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 25,
            child: Text(
              '${team.drawn}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 25,
            child: Text(
              '${team.lost}',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              '${team.points}',
              style:
                  AppTypography.titleMedium.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
