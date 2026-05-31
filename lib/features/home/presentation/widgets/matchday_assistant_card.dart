import 'dart:async';
import 'dart:math';

import 'package:arca_tribun/core/offline/connectivity_service.dart';
import 'package:arca_tribun/core/pilot/pilot_data.dart';
import 'package:arca_tribun/core/stadium/stadium_info.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/features/stadium/domain/weather_snapshot.dart';
import 'package:arca_tribun/features/stadium/presentation/weather_provider.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:arca_tribun/shared/widgets/pilot_demo_badge.dart';
import 'package:arca_tribun/shared/widgets/team_crest.dart';
import 'package:arca_tribun/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

typedef ExternalUriLauncher = Future<bool> Function(Uri uri);

final matchdayConnectivityProvider = StreamProvider<bool>((ref) async* {
  yield ConnectivityService.instance.isConnected;
  yield* ConnectivityService.instance.connectivityStream;
});

class MatchdayAssistantCard extends ConsumerStatefulWidget {
  const MatchdayAssistantCard({
    this.upcomingMatch,
    this.liveMatch,
    this.recentMatch,
    this.isConnectedOverride,
    this.launchMaps,
    this.tipIndexOverride,
    super.key,
  });

  final MatchModel? upcomingMatch;
  final MatchModel? liveMatch;
  final MatchModel? recentMatch;
  final bool? isConnectedOverride;
  final ExternalUriLauncher? launchMaps;
  final int? tipIndexOverride;

  @override
  ConsumerState<MatchdayAssistantCard> createState() =>
      _MatchdayAssistantCardState();
}

class _MatchdayAssistantCardState extends ConsumerState<MatchdayAssistantCard> {
  static const _tips = [
    'Kırmızı-Siyah formayı unutma.',
    'Maçtan 45 dakika önce stadyumda ol.',
    'Hava durumunu kontrol etmeyi unutma.',
    'Stadyuma gelirken toplu taşıma planını önceden yap.',
    'Telefonunun şarjını maç öncesinde kontrol et.',
    'Tribün girişinde bilet bilgin hazır olsun.',
    'Takım atkını yanına al.',
    'Maç günü duyurularını bildirim merkezinden takip et.',
    'Stadyum kapıları bilgisini maç öncesinde yeniden kontrol et.',
    'Kırmızı-Siyah tribün ruhunu yanında getir.',
  ];

  Timer? _timer;
  late String _tip;

  @override
  void initState() {
    super.initState();
    final tipIndex = widget.tipIndexOverride ?? Random().nextInt(_tips.length);
    _tip = _tips[tipIndex % _tips.length];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isConnected = widget.isConnectedOverride ??
        ref.watch(matchdayConnectivityProvider).valueOrNull ??
        ConnectivityService.instance.isConnected;
    final weather = isConnected ? ref.watch(stadiumWeatherProvider) : null;
    final upcomingMatch = widget.upcomingMatch ?? _pilotMatch(isUpcoming: true);
    final recentMatch = widget.recentMatch ?? _pilotMatch(isUpcoming: false);
    final liveMatch = widget.liveMatch;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: child,
        ),
      ),
      child: Container(
        key: const Key('matchday_assistant_card'),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF18191D),
                    Color(0xFF08090B),
                    Color(0xFF3E090C),
                  ]
                : const [
                    Color(0xFFFFFFFF),
                    Color(0xFFF5F5F3),
                    Color(0xFFFFE9EA),
                  ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(
            color: AppColors.primaryRed.withValues(alpha: 0.52),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.primaryRed.withValues(alpha: isDark ? 0.18 : 0.1),
              blurRadius: 24,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -34,
              top: 18,
              child: Icon(
                Icons.stadium_outlined,
                color: AppColors.primaryRed.withValues(alpha: 0.1),
                size: 174,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AssistantHeader(),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _headline(liveMatch: liveMatch, upcomingMatch: upcomingMatch),
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                const _StadiumSummary(),
                const SizedBox(height: AppSpacing.lg),
                _MatchCountdown(
                  liveMatch: liveMatch,
                  upcomingMatch: upcomingMatch,
                  recentMatch: recentMatch,
                ),
                const SizedBox(height: AppSpacing.md),
                _WeatherSummary(isConnected: isConnected, weather: weather),
                if (!isConnected) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Maç bilgileri son senkronizasyondan gösteriliyor.',
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                const _MatchdayStatus(),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const Key('matchday_maps_button'),
                    onPressed: _openMaps,
                    icon: const Icon(Icons.directions_outlined),
                    label: const Text('STADYUMA GİT'),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PreviousMatchCard(match: recentMatch),
                const SizedBox(height: AppSpacing.sm),
                _UpcomingMatchCard(match: upcomingMatch),
                const SizedBox(height: AppSpacing.sm),
                _SeasonCounter(match: upcomingMatch),
                const SizedBox(height: AppSpacing.md),
                _MatchdayTip(tip: _tip),
              ],
            ),
          ],
        ),
      ),
    );
  }

  MatchModel? _pilotMatch({required bool isUpcoming}) {
    if (!SupabaseConfig.enablePilotDemo) return null;
    final id =
        isUpcoming ? PilotData.seasonStartMatchId : PilotData.finalMatchId;
    final row = PilotData.matchById(id);
    return row == null ? null : MatchModel.fromSupabase(row);
  }

  Future<void> _openMaps() async {
    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${StadiumInfo.latitude},${StadiumInfo.longitude}',
    });
    final launcher = widget.launchMaps ?? _launchExternal;
    try {
      if (await launcher(uri)) return;
    } catch (_) {
      // The user receives a concise UI message below.
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Harita uygulaması şu anda açılamıyor.')),
    );
  }

  Future<bool> _launchExternal(Uri uri) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _headline({
    required MatchModel? liveMatch,
    required MatchModel? upcomingMatch,
  }) {
    if (liveMatch != null) return 'Bugün maç var. Karşılaşma canlı.';
    final kickoff = upcomingMatch?.kickoffTime;
    if (kickoff != null) {
      final now = DateTime.now();
      if (kickoff.year == now.year &&
          kickoff.month == now.month &&
          kickoff.day == now.day) {
        return 'Bugün maç var.';
      }
    }
    return 'Sıradaki maç için hazırlık zamanı.';
  }
}

class _AssistantHeader extends StatelessWidget {
  const _AssistantHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome, color: AppColors.primaryRed),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'MAÇ GÜNÜ ASİSTANI',
            style:
                AppTypography.titleLarge.copyWith(color: AppColors.primaryRed),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const PilotDemoBadge(),
      ],
    );
  }
}

class _StadiumSummary extends StatelessWidget {
  const _StadiumSummary();

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Row(
      children: [
        const ClubLogo(size: 54, showShadow: true),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(StadiumInfo.name, style: AppTypography.titleLarge),
              Text(
                'Çorum · ${StadiumInfo.capacity} kişi · ${StadiumInfo.surface}',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatchCountdown extends StatelessWidget {
  const _MatchCountdown({
    required this.liveMatch,
    required this.upcomingMatch,
    required this.recentMatch,
  });

  final MatchModel? liveMatch;
  final MatchModel? upcomingMatch;
  final MatchModel? recentMatch;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    final remaining = upcomingMatch?.kickoffTime.difference(DateTime.now());
    final hasCountdown = remaining != null && !remaining.isNegative;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MAÇA GERİ SAYIM', style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          if (liveMatch != null)
            const _StatusBadge(label: 'CANLI', icon: Icons.circle)
          else if (hasCountdown)
            Row(
              children: [
                _TimeBlock(value: remaining.inDays, label: 'Gün'),
                const _TimeDivider(),
                _TimeBlock(
                  value: remaining.inHours.remainder(24),
                  label: 'Saat',
                ),
                const _TimeDivider(),
                _TimeBlock(
                  value: remaining.inMinutes.remainder(60),
                  label: 'Dakika',
                ),
              ],
            )
          else if (recentMatch != null)
            const _StatusBadge(
              label: 'TAMAMLANDI',
              icon: Icons.check_circle_outline,
            )
          else
            Text(
              'Maç bilgisi bekleniyor.',
              style: TextStyle(color: colors.textSecondary),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryRed, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.titleLarge.copyWith(color: AppColors.primaryRed),
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text('$value', style: AppTypography.headlineLarge),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

class _TimeDivider extends StatelessWidget {
  const _TimeDivider();

  @override
  Widget build(BuildContext context) {
    return Text(':', style: AppTypography.headlineLarge);
  }
}

class _WeatherSummary extends StatelessWidget {
  const _WeatherSummary({required this.isConnected, required this.weather});

  final bool isConnected;
  final AsyncValue<WeatherSnapshot>? weather;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Row(
      children: [
        Icon(
          _weatherIcon(),
          color: AppColors.primaryRed,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: !isConnected || weather == null
              ? Text(
                  'Hava durumu alınamıyor.',
                  style: TextStyle(color: colors.textSecondary),
                )
              : weather!.when(
                  loading: () => Text(
                    'Hava durumu alınıyor...',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  error: (_, __) => Text(
                    'Hava durumu alınamıyor.',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  data: (snapshot) => Text(
                    '${snapshot.temperature.round()}°C · '
                    '${snapshot.conditionLabel}',
                    style: AppTypography.titleMedium,
                  ),
                ),
        ),
      ],
    );
  }

  IconData _weatherIcon() {
    if (!isConnected) return Icons.cloud_off_outlined;
    final code = weather?.valueOrNull?.weatherCode;
    if (code == null) return Icons.cloud_sync_outlined;
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code <= 3) return Icons.cloud_outlined;
    if (code <= 48) return Icons.foggy;
    if (code <= 67) return Icons.water_drop_outlined;
    if (code <= 77) return Icons.ac_unit_outlined;
    return Icons.thunderstorm_outlined;
  }
}

class _MatchdayStatus extends StatelessWidget {
  const _MatchdayStatus();

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MAÇ GÜNÜ DURUMU', style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          const _StatusLine(label: 'Taraftar yoğunluğu', value: 'Normal'),
          const _StatusLine(
            label: 'Stadyum kapıları',
            value: 'Bilgi bekleniyor',
          ),
          const _StatusLine(label: 'Bilet durumu', value: 'Yakında'),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text('$label: $value', style: AppTypography.bodySmall),
    );
  }
}

class _PreviousMatchCard extends StatelessWidget {
  const _PreviousMatchCard({required this.match});

  final MatchModel? match;

  @override
  Widget build(BuildContext context) {
    return _AssistantMiniCard(
      title: 'SON MAÇ',
      child: match == null
          ? const Text('Son maç bilgisi bekleniyor.')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TeamScoreRow(match: match!),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '37’ Serdar Gürler · 53’ Mame Thiam',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
    );
  }
}

class _UpcomingMatchCard extends StatelessWidget {
  const _UpcomingMatchCard({required this.match});

  final MatchModel? match;

  @override
  Widget build(BuildContext context) {
    final opponentPending = match?.awayTeam == 'Rakip açıklanacak';
    return _AssistantMiniCard(
      title: 'SIRADAKİ MAÇ',
      child: match == null
          ? const Text('Yeni sezon fikstürü bekleniyor.')
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TeamScoreRow(match: match!),
                if (opponentPending) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Rakip yakında açıklanacak',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ],
            ),
    );
  }
}

class _TeamScoreRow extends StatelessWidget {
  const _TeamScoreRow({required this.match});

  final MatchModel match;

  @override
  Widget build(BuildContext context) {
    final hasScore = match.homeScore != null && match.awayScore != null;
    return Row(
      children: [
        TeamCrest(teamName: match.homeTeam, size: 28),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            match.homeTeam,
            style: AppTypography.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          hasScore ? match.scoreDisplay : 'vs',
          style:
              AppTypography.titleMedium.copyWith(color: AppColors.primaryRed),
        ),
        Expanded(
          child: Text(
            match.awayTeam,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        TeamCrest(teamName: match.awayTeam, size: 28),
      ],
    );
  }
}

class _AssistantMiniCard extends StatelessWidget {
  const _AssistantMiniCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _SeasonCounter extends StatelessWidget {
  const _SeasonCounter({required this.match});

  final MatchModel? match;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    final remaining = match?.kickoffTime.difference(DateTime.now());
    final hasStarted = remaining == null || remaining.isNegative;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            hasStarted ? 'YENİ SEZON BAŞLIYOR' : 'SÜPER LİG SEZONUNA',
            style: AppTypography.labelSmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (!hasStarted)
            Text(
              '${remaining.inDays} GÜN KALDI',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primaryRed,
              ),
            ),
        ],
      ),
    );
  }
}

class _MatchdayTip extends StatelessWidget {
  const _MatchdayTip({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_outline, color: AppColors.primaryRed),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            'MAÇ GÜNÜ İPUCU\n$tip',
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
