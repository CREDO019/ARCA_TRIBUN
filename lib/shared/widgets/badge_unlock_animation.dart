import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Rozet açılma animasyon overlay'i
class BadgeUnlockAnimation extends StatefulWidget {
  const BadgeUnlockAnimation({
    super.key,
    required this.badgeName,
    required this.badgeIcon,
    required this.onDismiss,
  });

  final String badgeName;
  final String badgeIcon;
  final VoidCallback onDismiss;

  @override
  State<BadgeUnlockAnimation> createState() => _BadgeUnlockAnimationState();
}

class _BadgeUnlockAnimationState extends State<BadgeUnlockAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 4), widget.onDismiss);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.85),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/badge_unlock.json',
                width: 200,
                height: 200,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.military_tech,
                  size: 80,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'YENİ ROZET AÇILDI!',
                style:
                    AppTypography.labelSmall.copyWith(color: AppColors.warning),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(widget.badgeIcon, style: const TextStyle(fontSize: 50)),
              Text(widget.badgeName, style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.xl),
              Text('Devam etmek için dokun', style: AppTypography.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
