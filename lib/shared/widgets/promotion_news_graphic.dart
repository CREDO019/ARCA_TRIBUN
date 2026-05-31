import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:flutter/material.dart';

class PromotionNewsGraphic extends StatelessWidget {
  const PromotionNewsGraphic({this.height = 88, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF090909), Color(0xFF421114)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -28,
            child: Icon(
              Icons.stadium_outlined,
              color: AppColors.white.withValues(alpha: 0.12),
              size: height * 1.35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ClubLogo(size: height * 0.58, showShadow: true),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'SÜPER LİG’E\nYÜKSELDİK',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: height * 0.18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
