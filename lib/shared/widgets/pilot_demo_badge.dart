import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/supabase_config.dart';
import 'package:flutter/material.dart';

/// Pilot sunum build'lerinde görünen, production'da gizlenen ortam etiketi.
class PilotDemoBadge extends StatelessWidget {
  const PilotDemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.enablePilotDemo) return const SizedBox.shrink();

    return Container(
      key: const Key('pilot_demo_badge'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        'PİLOT VERİ',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primaryRedLight,
          fontSize: 9,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
