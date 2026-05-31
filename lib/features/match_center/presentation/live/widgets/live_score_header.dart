import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:flutter/material.dart';

/// Canlı skor başlık widget'ı — gradient arka plan, büyük skor
class LiveScoreHeader extends StatelessWidget {
  const LiveScoreHeader({super.key, required this.liveMatch});

  final LiveMatchModel liveMatch;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors.heroGradient,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CANLI badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                "● CANLI · ${liveMatch.minute}'",
                style:
                    AppTypography.labelSmall.copyWith(color: AppColors.white),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Skor
            Text(liveMatch.score, style: AppTypography.scoreDisplay),

            const SizedBox(height: AppSpacing.sm),
            Text(
              'Arca Çorum FK vs Rakip',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.white.withValues(alpha: 0.76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
