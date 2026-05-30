import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../domain/standing_model.dart';
import 'standings_provider.dart';

/// Puan durumu ekranı — Süper Lig tablosu
class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(seasonStandingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Puan Durumu')),
      body: standingsAsync.when(
        loading: () => const LoadingShimmer(itemCount: 10),
        error: (_, __) => _ErrorState(
          onRetry: () => ref.invalidate(seasonStandingsProvider),
        ),
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(
              child: Text(
                'Henüz puan durumu bulunmuyor.',
                style: TextStyle(color: AppColors.secondaryGray),
              ),
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
                        child: Text('KULÜP',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.secondaryGray))),
                    SizedBox(
                        width: 25,
                        child: Text('O',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.secondaryGray),
                            textAlign: TextAlign.center)),
                    SizedBox(
                        width: 25,
                        child: Text('G',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.secondaryGray),
                            textAlign: TextAlign.center)),
                    SizedBox(
                        width: 25,
                        child: Text('B',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.secondaryGray),
                            textAlign: TextAlign.center)),
                    SizedBox(
                        width: 25,
                        child: Text('M',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.secondaryGray),
                            textAlign: TextAlign.center)),
                    SizedBox(
                        width: 30,
                        child: Text('P',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.primaryRed),
                            textAlign: TextAlign.center)),
                  ],
                ),
              ),
              const Divider(color: AppColors.border, height: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: teams.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: AppColors.border, height: 1),
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
              child:
                  Text('${team.position}', style: AppTypography.bodyMedium)),
          Expanded(
            child: Text(
              team.teamName,
              style: isOurTeam
                  ? AppTypography.titleMedium.copyWith(color: AppColors.primaryRed)
                  : AppTypography.bodyMedium.copyWith(color: AppColors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
              width: 25,
              child: Text('${team.played}',
                  style: AppTypography.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 25,
              child: Text('${team.won}',
                  style: AppTypography.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 25,
              child: Text('${team.drawn}',
                  style: AppTypography.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 25,
              child: Text('${team.lost}',
                  style: AppTypography.bodySmall, textAlign: TextAlign.center)),
          SizedBox(
              width: 30,
              child: Text('${team.points}',
                  style: AppTypography.titleMedium.copyWith(color: AppColors.white),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'İçerik yüklenemedi. Lütfen tekrar deneyin.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}
