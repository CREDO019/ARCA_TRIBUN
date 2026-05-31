import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/standings/presentation/standings_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Puan durumu mini kart widget'ı — home screen'de özet gösterir.
class StandingsMiniCard extends ConsumerWidget {
  const StandingsMiniCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(seasonStandingsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
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
                    .copyWith(color: AppColors.secondaryGray),
              ),
              TextButton(
                onPressed: () => context.push(RouteNames.standings),
                child: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          standingsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'Yükleniyor...',
                style: TextStyle(color: AppColors.secondaryGray),
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

              final visibleTeams = teams.take(3);
              return Column(
                children: visibleTeams.map((team) {
                  final isOurTeam =
                      team.teamName.toLowerCase().contains('arca çorum');
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
                        Expanded(
                          child: Text(
                            team.teamName,
                            style: isOurTeam
                                ? AppTypography.titleMedium
                                    .copyWith(color: AppColors.primaryRed)
                                : AppTypography.bodyMedium
                                    .copyWith(color: AppColors.white),
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
                              .copyWith(color: AppColors.white),
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
