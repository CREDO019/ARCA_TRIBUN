import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/standings/presentation/standings_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/team_crest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Puan durumu mini kart widget'ı — home screen'de özet gösterir.
class StandingsMiniCard extends ConsumerWidget {
  const StandingsMiniCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(seasonStandingsProvider);
    final colors = context.arcaColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PUAN DURUMU',
                style: AppTypography.labelSmall
                    .copyWith(color: colors.textSecondary),
              ),
              TextButton(
                onPressed: () => context.push(RouteNames.standings),
                child: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          standingsAsync.when(
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'Yükleniyor...',
                style: TextStyle(color: colors.textSecondary),
              ),
            ),
            error: (_, __) => const ContentErrorState(
              compact: true,
            ),
            data: (teams) {
              if (teams.isEmpty) {
                return const BrandedEmptyState(
                  icon: Icons.leaderboard_outlined,
                  title: 'Lig tablosu hazırlanıyor',
                  message: 'Doğrulanmış veriler burada yayınlanacak.',
                  compact: true,
                );
              }

              final visibleTeams = teams.take(3).toList();
              final ourTeam = teams.where(
                (team) => isArcaCorumFk(team.teamName),
              );
              if (ourTeam.isNotEmpty && !visibleTeams.contains(ourTeam.first)) {
                visibleTeams.add(ourTeam.first);
              }
              return Column(
                children: visibleTeams.map((team) {
                  final isOurTeam = isArcaCorumFk(team.teamName);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${team.position}',
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        TeamCrest(teamName: team.teamName, size: 24),
                        const SizedBox(width: AppSpacing.sm),
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
                        Text(
                          '${team.played} O',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          '${team.points} P',
                          style: AppTypography.titleMedium
                              .copyWith(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
