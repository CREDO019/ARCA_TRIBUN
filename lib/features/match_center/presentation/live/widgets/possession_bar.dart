import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Topa sahip olma yüzde çubuğu
class PossessionBar extends StatelessWidget {
  const PossessionBar({
    super.key,
    required this.homePossession,
    required this.awayPossession,
  });

  final int homePossession;
  final int awayPossession;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$homePossession%', style: AppTypography.titleMedium),
            Text('Topa Sahip Olma', style: AppTypography.bodySmall),
            Text('$awayPossession%', style: AppTypography.titleMedium),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: Row(
            children: [
              Flexible(
                flex: homePossession,
                child: Container(height: 8, color: AppColors.primaryRed),
              ),
              Flexible(
                flex: awayPossession,
                child: Container(height: 8, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
