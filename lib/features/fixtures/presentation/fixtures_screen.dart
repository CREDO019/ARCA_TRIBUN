import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:arca_tribun/shared/widgets/team_crest.dart';
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

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                if (upcomingMatches.isNotEmpty) ...[
                  const _SectionTitle('YENİ SEZON BAŞLANGICI'),
                  ...upcomingMatches.map(
                    (match) => _FixtureLink(match: match),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                if (recentMatches.isNotEmpty) ...[
                  const _SectionTitle('SONUÇLANAN MAÇLAR'),
                  ...recentMatches.map(
                    (match) => _FixtureLink(match: match),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

class _FixtureLink extends StatelessWidget {
  const _FixtureLink({required this.match});

  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: () => context.push(RouteNames.matchCenterPath(match.id)),
        child: _FixtureTile(match: match),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 42,
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
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  hasScore ? 'Play-off Final Sonucu' : 'Yeni Sezon Başlangıcı',
                  style: AppTypography.titleMedium,
                ),
              ),
              Flexible(
                child: Text(
                  match.competition ?? 'Lig',
                  style: AppTypography.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              TeamCrest(teamName: match.homeTeam, size: 38),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  match.homeTeam,
                  style: AppTypography.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  hasScore
                      ? '${match.homeScore} - ${match.awayScore}'
                      : '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                  style: AppTypography.titleMedium
                      .copyWith(color: AppColors.primaryRed),
                ),
              ),
              Expanded(
                child: Text(
                  match.awayTeam,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              TeamCrest(teamName: match.awayTeam, size: 38),
            ],
          ),
          if (!hasScore) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Rakip, fikstür açıklandığında güncellenecek.',
              style: AppTypography.bodySmall,
            ),
          ],
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
