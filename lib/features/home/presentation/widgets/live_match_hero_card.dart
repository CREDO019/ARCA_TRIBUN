import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/features/match_center/presentation/match_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1).animate(
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
    final liveMatchAsync = ref.watch(currentLiveMatchProvider);
    final upcomingMatchesAsync = ref.watch(upcomingMatchesProvider);
    final isLoading =
        liveMatchAsync.isLoading || upcomingMatchesAsync.isLoading;
    final hasError = liveMatchAsync.hasError && upcomingMatchesAsync.hasError;

    final liveMatch = liveMatchAsync.valueOrNull;
    final nextMatch = upcomingMatchesAsync.valueOrNull?.isNotEmpty ?? false
        ? upcomingMatchesAsync.valueOrNull!.first
        : null;
    final match = liveMatch ?? nextMatch;
    final isLive = liveMatch != null;

    return GestureDetector(
      onTap: match == null
          ? null
          : () => context.push(RouteNames.matchCenterPath(match.id)),
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
                  Text(
                    match?.competition ?? 'Maç Merkezi',
                    style: AppTypography.labelSmall,
                  ),
                  if (isLive) _buildLiveBadge() else _buildUpcomingBadge(),
                ],
              ),

              const Spacer(),

              // ─── Score Row ─────────────────────────────────────────
              if (match == null)
                Center(
                  child: Text(
                    hasError
                        ? 'İçerik yüklenemedi. Lütfen tekrar deneyin.'
                        : isLoading
                            ? 'Yükleniyor...'
                            : 'Maç verileri doğrulandığında burada yayınlanacak.',
                    style: const TextStyle(color: AppColors.secondaryGray),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        match.homeTeam,
                        style: AppTypography.titleMedium,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          _scoreText(match, isLive: isLive),
                          style: AppTypography.scoreDisplay,
                        ),
                        Text(
                          _statusText(match, isLive: isLive),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Text(
                        match.awayTeam,
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
                  onPressed: match == null
                      ? null
                      : () =>
                          context.push(RouteNames.matchCenterPath(match.id)),
                  child: Text(
                    match == null ? 'VERİ BEKLENİYOR' : 'MAÇ MERKEZİNE GİT',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return AnimatedBuilder(
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
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
                style: AppTypography.labelSmall.copyWith(fontSize: 9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg2,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'SIRADAKİ MAÇ',
        style: AppTypography.labelSmall.copyWith(fontSize: 9),
      ),
    );
  }

  String _scoreText(MatchModel match, {required bool isLive}) {
    if (isLive || (match.homeScore != null && match.awayScore != null)) {
      return '${match.homeScore ?? 0} - ${match.awayScore ?? 0}';
    }
    return _formattedTime(match.kickoffTime);
  }

  String _statusText(MatchModel match, {required bool isLive}) {
    if (isLive) return "${match.minute ?? 0}'";
    return _formattedDate(match.kickoffTime);
  }

  String _formattedTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formattedDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
