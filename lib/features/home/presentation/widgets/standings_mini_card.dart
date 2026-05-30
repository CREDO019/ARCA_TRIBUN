import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Puan durumu mini kart widget'ı — home screen'de özet gösterir.
class StandingsMiniCard extends StatelessWidget {
  const StandingsMiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo data
    final teams = [
      {'name': 'Arca Çorum FK', 'played': 20, 'points': 42, 'position': 3},
      {'name': 'Rakip 1', 'played': 20, 'points': 45, 'position': 1},
      {'name': 'Rakip 2', 'played': 20, 'points': 44, 'position': 2},
    ];

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
              Text('PUAN DURUMU',
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.secondaryGray)),
              TextButton(onPressed: () {}, child: const Text('Tümü')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...teams.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text('${t['position']}',
                          style: AppTypography.bodyMedium),
                    ),
                    Expanded(
                      child: Text(
                        t['name'] as String,
                        style: t['name'] == 'Arca Çorum FK'
                            ? AppTypography.titleMedium
                                .copyWith(color: AppColors.primaryRed)
                            : AppTypography.bodyMedium
                                .copyWith(color: AppColors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('${t['played']} O', style: AppTypography.bodySmall),
                    const SizedBox(width: AppSpacing.md),
                    Text('${t['points']} P',
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.white)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
