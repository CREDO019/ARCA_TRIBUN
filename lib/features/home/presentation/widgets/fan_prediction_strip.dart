import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Pilot sürümde gerçek veri akışı tamamlanana kadar bilgilendirme gösterir.
class FanPredictionStrip extends StatelessWidget {
  const FanPredictionStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.how_to_vote_outlined,
              color: AppColors.primaryRedLight,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TARAFTAR TAHMİNİ',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.secondaryGray,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tahmin deneyimi pilot veri akışı tamamlandığında '
                  'aktif olacak.',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
