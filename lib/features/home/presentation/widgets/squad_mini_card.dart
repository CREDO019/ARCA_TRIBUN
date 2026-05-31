import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SquadMiniCard extends StatelessWidget {
  const SquadMiniCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return InkWell(
      onTap: () => context.push(RouteNames.squad),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            const ClubLogo(size: 48, showShadow: true),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KADRO', style: AppTypography.labelSmall),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Doğrulanmış A takım kadrosunu incele',
                    style: AppTypography.titleMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.primaryRed,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
