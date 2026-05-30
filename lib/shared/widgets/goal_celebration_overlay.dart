import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/audio/goal_sound_engine.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Gol kutlama overlay'i.
/// GoalSoundEngine'den gelen event ile tetiklenir.
/// Tam ekran kırmızı flash + Lottie animasyon + GOL yazısı.
class GoalCelebrationOverlay extends StatefulWidget {
  const GoalCelebrationOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<GoalCelebrationOverlay> createState() => _GoalCelebrationOverlayState();
}

class _GoalCelebrationOverlayState extends State<GoalCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flashAnimation;

  GoalEvent? _currentEvent;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _flashAnimation = Tween<double>(begin: 0, end: 0.4).animate(_controller);

    // GoalSoundEngine'e callback ekle
    GoalSoundEngine.instance.addGoalCallback(_onGoalEvent);
  }

  void _onGoalEvent(GoalEvent event) {
    if (!mounted) return;

    setState(() {
      _currentEvent = event;
      _isVisible = true;
    });

    // Flash animasyonu
    _controller.forward().then((_) => _controller.reverse());

    // 3 saniye sonra kapat
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

  @override
  void dispose() {
    GoalSoundEngine.instance.removeGoalCallback(_onGoalEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isVisible) ...[
          // Flash overlay
          AnimatedBuilder(
            animation: _flashAnimation,
            builder: (_, __) => Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: AppColors.primaryRed
                      .withValues(alpha: _flashAnimation.value),
                ),
              ),
            ),
          ),

          // Kutlama içeriği
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isVisible = false),
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lottie animasyon
                    Lottie.asset(
                      'assets/lottie/goal_celebration.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.sports_soccer,
                        size: 80,
                        color: AppColors.white,
                      ),
                    ),

                    // GOL yazısı
                    Text('GOL!', style: AppTypography.goalDisplay),

                    // Gol atan oyuncu
                    if (_currentEvent?.scorerName.isNotEmpty == true)
                      Text(
                        _currentEvent!.scorerName,
                        style: AppTypography.headlineLarge,
                      ),

                    // Skor
                    Text(
                      _currentEvent?.score ?? '',
                      style: AppTypography.scoreDisplay,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
