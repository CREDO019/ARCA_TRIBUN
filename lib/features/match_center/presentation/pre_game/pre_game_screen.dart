import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/features/stadium/presentation/stadium_card.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:arca_tribun/shared/widgets/team_crest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maç öncesi ekranı — kadro, stadyum, hava durumu bilgileri
class PreGameScreen extends ConsumerWidget {
  const PreGameScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailProvider(matchId));
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
              icon: Icons.stadium_outlined,
              title: 'Maç merkezi hazırlanıyor',
              message:
                  'Karşılaşma bilgileri kulüp tarafından doğrulandığında yayınlanacak.',
            ),
          );
        }

        final kickoff =
            '${match.kickoffTime.day.toString().padLeft(2, '0')}.${match.kickoffTime.month.toString().padLeft(2, '0')}.${match.kickoffTime.year} '
            '${match.kickoffTime.hour.toString().padLeft(2, '0')}:${match.kickoffTime.minute.toString().padLeft(2, '0')}';

        return _PreGameContent(
          homeTeam: match.homeTeam,
          awayTeam: match.awayTeam,
          kickoff: kickoff,
          venue: match.venue ?? 'Stadyum bilgisi bekleniyor',
          fixturePending: match.awayTeam == 'Rakip açıklanacak',
        );
      },
    );
  }
}

class _PreGameContent extends StatelessWidget {
  const _PreGameContent({
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoff,
    required this.venue,
    required this.fixturePending,
  });

  final String homeTeam;
  final String awayTeam;
  final String kickoff;
  final String venue;
  final bool fixturePending;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Maç Öncesi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Maç bilgisi
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors.heroGradient),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      TeamCrest(teamName: homeTeam, size: 44),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          '$homeTeam\nvs\n$awayTeam',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      TeamCrest(teamName: awayTeam, size: 44),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '$kickoff • $venue',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.white.withValues(alpha: 0.76),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Muhtemel 11
            Text(
              fixturePending ? 'FİKSTÜR NOTU' : 'MUHTEMEL 11',
              style: AppTypography.labelSmall
                  .copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: colors.border),
              ),
              child: Center(
                child: Text(
                  fixturePending
                      ? 'Yeni sezon fikstürü açıklandığında rakip ve maç '
                          'detayları burada güncellenecek.'
                      : 'Doğrulanmış kadro bilgileri bekleniyor.',
                  style: TextStyle(color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Stadyum ve maç günü hava durumu
            Text(
              'STADYUM VE MAÇ GÜNÜ HAVA DURUMU',
              style: AppTypography.labelSmall
                  .copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            const StadiumCard(),
          ],
        ),
      ),
    );
  }
}
