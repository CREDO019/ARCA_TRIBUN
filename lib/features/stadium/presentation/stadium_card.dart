import 'package:arca_tribun/core/stadium/stadium_info.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/stadium/domain/weather_snapshot.dart';
import 'package:arca_tribun/features/stadium/presentation/weather_provider.dart';
import 'package:arca_tribun/shared/widgets/club_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StadiumCard extends ConsumerWidget {
  const StadiumCard({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.arcaColors;
    final weather = ref.watch(stadiumWeatherProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ClubLogo(size: 48, showShadow: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(StadiumInfo.name, style: AppTypography.titleLarge),
                    Text(
                      StadiumInfo.description,
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _StadiumFact(icon: Icons.location_city, label: StadiumInfo.city),
              _StadiumFact(
                icon: Icons.groups_outlined,
                label: '${StadiumInfo.capacity} kişi',
              ),
              _StadiumFact(icon: Icons.grass, label: StadiumInfo.surface),
              _StadiumFact(
                icon: Icons.straighten,
                label: StadiumInfo.pitchSize,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: colors.border, height: 1),
          const SizedBox(height: AppSpacing.md),
          weather.when(
            loading: () => const _WeatherMessage(
              icon: Icons.cloud_sync_outlined,
              message: 'Hava durumu alınıyor...',
            ),
            error: (_, __) => const _WeatherMessage(
              icon: Icons.cloud_off_outlined,
              message: 'Hava durumu şu anda alınamıyor.',
            ),
            data: (snapshot) => _WeatherContent(snapshot: snapshot),
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.directions_outlined),
                label: const Text('YOL TARİFİ YAKINDA'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StadiumFact extends StatelessWidget {
  const _StadiumFact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primaryRed, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.bodySmall),
        ],
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.snapshot});

  final WeatherSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_weatherIcon(snapshot.weatherCode), color: AppColors.primaryRed),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            '${snapshot.temperature.round()}°C · ${snapshot.conditionLabel}',
            style: AppTypography.titleMedium,
          ),
        ),
        Flexible(
          child: Text(
            'Rüzgar ${snapshot.windSpeed.round()} km/sa',
            style: AppTypography.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code <= 3) return Icons.cloud_outlined;
    if (code <= 48) return Icons.foggy;
    if (code <= 67) return Icons.water_drop_outlined;
    if (code <= 77) return Icons.ac_unit_outlined;
    return Icons.thunderstorm_outlined;
  }
}

class _WeatherMessage extends StatelessWidget {
  const _WeatherMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Row(
      children: [
        Icon(icon, color: colors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: AppTypography.bodySmall,
          ),
        ),
      ],
    );
  }
}
