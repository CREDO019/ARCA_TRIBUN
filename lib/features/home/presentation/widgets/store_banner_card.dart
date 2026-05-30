import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Mağaza / Sponsor banner card
class StoreBannerCard extends StatelessWidget {
  const StoreBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [AppColors.primaryRed, AppColors.primaryRedDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        children: [
          const Icon(Icons.store_outlined,
              color: AppColors.white, size: AppSpacing.iconXl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Forma & Taraftar Ürünleri',
                    style: AppTypography.titleLarge),
                Text('Özel indirimler seni bekliyor!',
                    style: AppTypography.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: AppColors.white, size: AppSpacing.iconSm),
        ],
      ),
    );
  }
}
