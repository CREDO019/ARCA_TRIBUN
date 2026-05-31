import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/squad/domain/player_model.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    required this.player,
    this.size = 64,
    super.key,
  });

  final PlayerModel player;
  final double size;

  @override
  Widget build(BuildContext context) {
    final number = player.number > 0 ? '${player.number}' : '-';

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClubLogo(size: size, showShadow: true),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              constraints: BoxConstraints(minWidth: size * 0.34),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(size),
                border: Border.all(color: AppColors.white),
              ),
              child: Text(
                number,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.white,
                  fontSize: size * 0.16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
