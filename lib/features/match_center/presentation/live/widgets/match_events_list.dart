import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:flutter/material.dart';

/// Maç olayları listesi — goller, kartlar, değişiklikler
class MatchEventsList extends StatelessWidget {
  const MatchEventsList({super.key, required this.events});

  final List<MatchEventModel> events;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            'Doğrulanmış maç olayları yayınlandığında burada görünecek.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (_, __) => Divider(color: colors.border),
      itemBuilder: (context, index) {
        final event = events[index];
        return _EventTile(event: event);
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final MatchEventModel event;

  IconData get _icon {
    switch (event.type) {
      case MatchEventType.goal:
      case MatchEventType.penaltyGoal:
        return Icons.sports_soccer;
      case MatchEventType.yellowCard:
        return Icons.square;
      case MatchEventType.redCard:
        return Icons.square;
      case MatchEventType.substitution:
        return Icons.swap_horiz;
      default:
        return Icons.sports;
    }
  }

  Color _iconColor(BuildContext context) {
    switch (event.type) {
      case MatchEventType.goal:
      case MatchEventType.penaltyGoal:
        return AppColors.success;
      case MatchEventType.yellowCard:
        return AppColors.warning;
      case MatchEventType.redCard:
        return AppColors.errorRed;
      case MatchEventType.substitution:
        return AppColors.infoBlue;
      default:
        return context.arcaColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            "${event.minute}'",
            style:
                AppTypography.labelSmall.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(_icon, color: _iconColor(context), size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.playerName, style: AppTypography.bodyLarge),
                if (event.assistPlayerName != null)
                  Text(
                    'Asist: ${event.assistPlayerName}',
                    style: AppTypography.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
