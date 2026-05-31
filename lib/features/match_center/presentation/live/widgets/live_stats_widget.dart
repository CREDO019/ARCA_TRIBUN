import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:flutter/material.dart';

/// Maç istatistikleri widget'ı — şutlar, kornerler vb.
class LiveStatsWidget extends StatelessWidget {
  const LiveStatsWidget({super.key, required this.liveMatch});

  final LiveMatchModel liveMatch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          _StatRow(
            label: 'Şut',
            home: liveMatch.homeShots,
            away: liveMatch.awayShots,
          ),
          const Divider(color: AppColors.border),
          _StatRow(
            label: 'Korner',
            home: liveMatch.homeCorners,
            away: liveMatch.awayCorners,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.home, required this.away});

  final String label;
  final int home;
  final int away;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Text('$home', style: AppTypography.titleMedium),
          Expanded(
            child: Center(child: Text(label, style: AppTypography.bodySmall)),
          ),
          Text('$away', style: AppTypography.titleMedium),
        ],
      ),
    );
  }
}
