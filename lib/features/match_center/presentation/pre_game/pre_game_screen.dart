import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maç öncesi ekranı — kadro, stadyum, hava durumu bilgileri
class PreGameScreen extends ConsumerWidget {
  const PreGameScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailProvider(matchId));

    return matchAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingShimmer(itemCount: 4),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColors.background,
        body: ContentErrorState(),
      ),
      data: (match) {
        if (match == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: BrandedEmptyState(
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
  });

  final String homeTeam;
  final String awayTeam;
  final String kickoff;
  final String venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                gradient: const LinearGradient(colors: AppColors.heroGradient),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  Text(
                    '$homeTeam vs $awayTeam',
                    style: AppTypography.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('$kickoff • $venue', style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Muhtemel 11
            Text(
              'MUHTEMEL 11',
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.secondaryGray),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text(
                  'Doğrulanmış kadro bilgileri bekleniyor.',
                  style: TextStyle(color: AppColors.secondaryGray),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Hava durumu
            Text(
              'HAVA DURUMU',
              style: AppTypography.labelSmall
                  .copyWith(color: AppColors.secondaryGray),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.cloud_outlined,
                    color: AppColors.secondaryGray,
                    size: 40,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hava durumu verisi hazırlanıyor',
                        style: AppTypography.titleLarge,
                      ),
                      Text(
                        'Doğrulanmış bilgiler maç öncesinde yayınlanacak.',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
