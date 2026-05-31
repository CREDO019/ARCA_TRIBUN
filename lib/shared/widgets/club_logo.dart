import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Arca Çorum FK armasını uygulama içinde tutarlı ölçü ve gölgeyle gösterir.
class ClubLogo extends StatelessWidget {
  const ClubLogo({
    required this.size,
    this.showShadow = false,
    super.key,
  });

  static const String assetPath =
      'assets/images/branding/arca_corum_fk_logo.png';

  final double size;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.primaryRed.withValues(alpha: 0.18),
                  blurRadius: size * 0.24,
                  spreadRadius: size * 0.02,
                ),
              ]
            : null,
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        semanticLabel: 'Arca Çorum FK arması',
        errorBuilder: (_, __, ___) => DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield_outlined,
            color: AppColors.primaryRed,
            size: size * 0.58,
          ),
        ),
      ),
    );
  }
}
