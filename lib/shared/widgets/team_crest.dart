import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:flutter/material.dart';

class TeamCrest extends StatelessWidget {
  const TeamCrest({
    required this.teamName,
    this.size = 36,
    super.key,
  });

  final String teamName;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (isArcaCorumFk(teamName)) {
      return ClubLogo(size: size, showShadow: true);
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryRed.withValues(alpha: 0.42),
        ),
      ),
      child: Text(
        _initials(teamName),
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primaryRed,
          fontSize: size * 0.25,
        ),
      ),
    );
  }

  String _initials(String value) {
    if (value == 'Rakip açıklanacak') return '?';
    final words = value
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .toList();
    return words.map((word) => word[0]).join().toUpperCase();
  }
}

bool isArcaCorumFk(String teamName) {
  final normalized = teamName.toLowerCase();
  return normalized.contains('çorum fk') || normalized.contains('corum fk');
}
