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
    final assetPath = _assetPath(player.photoUrl);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF111111), Color(0xFF76171C)],
              ),
            ),
            child: assetPath == null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.78,
                        child: ClubLogo(size: size * 0.7, showShadow: true),
                      ),
                      Positioned(
                        left: size * 0.1,
                        bottom: size * 0.08,
                        child: Text(
                          _initials(player.name),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.white.withValues(alpha: 0.72),
                            fontSize: size * 0.14,
                          ),
                        ),
                      ),
                    ],
                  )
                : ClipOval(
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          ClubLogo(size: size * 0.7, showShadow: true),
                    ),
                  ),
          ),
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

  String? _assetPath(String? value) {
    if (value == null || !value.startsWith('assets/')) return null;
    return value;
  }

  String _initials(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0])
        .join()
        .toUpperCase();
  }
}
