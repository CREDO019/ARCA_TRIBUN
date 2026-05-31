import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/standings/domain/standing_model.dart';
import 'package:arca_tribun/features/standings/presentation/standings_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:arca_tribun/shared/widgets/team_crest.dart';
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
            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: const [
                _VerifiedFinalContextCard(),
                SizedBox(height: AppSpacing.xl),
                BrandedEmptyState(
                  icon: Icons.leaderboard_outlined,
                  title: 'Puan durumu hazırlanıyor',
                  message:
                      'Sezon puan durumu doğrulandığında burada görünecek.',
                ),
              ],
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
                    const SizedBox(width: 38),
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
    final isOurTeam = isArcaCorumFk(team.teamName);
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
          TeamCrest(teamName: team.teamName, size: 30),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Row(
              children: [
                Flexible(
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
                if (isOurTeam) ...[
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(
                    Icons.verified,
                    size: 15,
                    color: AppColors.primaryRed,
                  ),
                ],
              ],
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

class _VerifiedFinalContextCard extends StatelessWidget {
  const _VerifiedFinalContextCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Text(
            'PLAY-OFF FİNAL SONUCU',
            style:
                AppTypography.labelSmall.copyWith(color: AppColors.primaryRed),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const TeamCrest(teamName: 'Esenler Erokspor', size: 42),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(child: Text('Esenler Erokspor')),
              Text('0 - 2', style: AppTypography.headlineMedium),
              const Expanded(
                child: Text('Çorum FK', textAlign: TextAlign.end),
              ),
              const SizedBox(width: AppSpacing.sm),
              const TeamCrest(teamName: 'Çorum FK', size: 42),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Çorum FK bu sonuçla Süper Lig’e yükseldi.',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
