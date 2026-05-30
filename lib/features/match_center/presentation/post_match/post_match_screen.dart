import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
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
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Maç Sonu')),
        body: const Center(
          child: Text(
            'İçerik yüklenemedi. Lütfen tekrar deneyin.',
            style: TextStyle(color: AppColors.secondaryGray),
          ),
        ),
      ),
      data: (match) {
        if (match == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(title: const Text('Maç Sonu')),
            body: const Center(
              child: Text(
                'Maç bilgisi bulunamadı.',
                style: TextStyle(color: AppColors.secondaryGray),
              ),
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
                  Text('$homeTeam - $awayTeam', style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Maçın Adamı
            Text('MAÇIN ADAMI',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.secondaryGray)),
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
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        AppColors.primaryRed.withValues(alpha: 0.2),
                    child: const Icon(Icons.person,
                        color: AppColors.primaryRed, size: 30),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Oyuncu Adı', style: AppTypography.titleLarge),
                      Text('1 Gol · 1 Asist', style: AppTypography.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: const Icon(Icons.star,
                        color: AppColors.white, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Oyunun Adamı Oylaması
            Text('TARAFTAR OYLAMASI',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.secondaryGray)),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('Maçın Adamını Seç', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('OY VER'),
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
