import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Canlı maç hero kart widget'ı.
/// Canlı maç varsa skor + pulsing badge, yoksa "yaklaşan maç" gösterir.
class LiveMatchHeroCard extends ConsumerStatefulWidget {
  const LiveMatchHeroCard({super.key});

  @override
  ConsumerState<LiveMatchHeroCard> createState() => _LiveMatchHeroCardState();
}

class _LiveMatchHeroCardState extends ConsumerState<LiveMatchHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Demo data — gerçekte matchProvider'dan gelir
    const matchId = 'demo_match_001';
    const homeTeam = 'Arca Çorum FK';
    const awayTeam = 'Rakip Takım';
    const homeScore = 2;
    const awayScore = 1;
    const minute = 67;

    return GestureDetector(
      onTap: () => context.push(RouteNames.matchCenterPath(matchId)),
      child: Container(
        height: AppSpacing.matchCardHeight,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.heroGradient,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(
            color: AppColors.primaryRed.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            children: [
              // ─── Header ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Süper Lig', style: AppTypography.labelSmall),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (_, __) => Opacity(
                      opacity: _pulseAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'CANLI',
                              style: AppTypography.labelSmall
                                  .copyWith(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ─── Score Row ─────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Text(
                      homeTeam,
                      style: AppTypography.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '$homeScore - $awayScore',
                        style: AppTypography.scoreDisplay,
                      ),
                      Text(
                        "$minute'",
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      awayTeam,
                      style: AppTypography.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // ─── CTA Button ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size.fromHeight(AppSpacing.smallButtonHeight),
                  ),
                  onPressed: () =>
                      context.push(RouteNames.matchCenterPath(matchId)),
                  child: const Text('MAÇ MERKEZİNE GİT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
