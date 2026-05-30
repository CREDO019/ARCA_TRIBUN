import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Sıradaki maç geri sayım widget'ı.
/// Stream.periodic ile her saniye güncellenir.
class NextMatchCountdown extends StatefulWidget {
  const NextMatchCountdown({super.key, this.matchTime});

  final DateTime? matchTime;

  @override
  State<NextMatchCountdown> createState() => _NextMatchCountdownState();
}

class _NextMatchCountdownState extends State<NextMatchCountdown> {
  late DateTime _targetTime;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Demo: 3 gün sonrası
    _targetTime = widget.matchTime ??
        DateTime.now().add(const Duration(days: 3, hours: 14, minutes: 30));
    _updateRemaining();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final diff = _targetTime.difference(now);
    if (mounted) {
      setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sıradaki Maç'.toUpperCase(),
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.secondaryGray),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CountdownBlock(value: days, label: 'GÜN'),
              _Divider(),
              _CountdownBlock(value: hours, label: 'SAAT'),
              _Divider(),
              _CountdownBlock(value: minutes, label: 'DAK'),
              _Divider(),
              _CountdownBlock(value: seconds, label: 'SN'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(':',
        style: AppTypography.countdown.copyWith(color: AppColors.primaryRed));
  }
}

class _CountdownBlock extends StatelessWidget {
  const _CountdownBlock({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: AppTypography.countdown,
        ),
        Text(label, style: AppTypography.countdownLabel),
      ],
    );
  }
}
