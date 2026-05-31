import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/content_state.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../match_provider.dart';

/// Maç sonu ekranı — özet, oyunun adamı, fan oylaması
class PostMatchScreen extends ConsumerWidget {
  const PostMatchScreen({super.key, required this.matchId});

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
  });

  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                gradient: const LinearGradient(colors: AppColors.heroGradient),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  Text('MAÇ SONA ERDİ',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.secondaryGray)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${homeScore ?? 0} - ${awayScore ?? 0}',
                    style: AppTypography.scoreDisplay,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text('$homeTeam - $awayTeam',
                      style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text(
              'MAÇ ÖZETİ',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.secondaryGray,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    color: AppColors.secondaryGray,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Maç özeti ve oyuncu performansları doğrulandığında '
                      'burada yayınlanacak.',
                      style: TextStyle(color: AppColors.secondaryGray),
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
}
