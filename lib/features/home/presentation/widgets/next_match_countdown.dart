import 'dart:async';

import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Sıradaki maç geri sayım widget'ı.
/// Stream.periodic ile her saniye güncellenir.
class NextMatchCountdown extends StatefulWidget {
  const NextMatchCountdown({
    super.key,
    this.matchTime,
    this.title = 'Sıradaki Maç',
    this.description,
  });

  final DateTime? matchTime;
  final String title;
  final String? description;

  @override
  State<NextMatchCountdown> createState() => _NextMatchCountdownState();
}

class _NextMatchCountdownState extends State<NextMatchCountdown> {
  DateTime? _targetTime;
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _targetTime = widget.matchTime;
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant NextMatchCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.matchTime != widget.matchTime) {
      _targetTime = widget.matchTime;
      _timer?.cancel();
      _timer = null;
      _remaining = Duration.zero;
      _startTimerIfNeeded();
    }
  }

  void _updateRemaining() {
    final targetTime = _targetTime;
    if (targetTime == null) return;
    final now = DateTime.now();
    final diff = targetTime.difference(now);
    if (mounted) {
      setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
    }
  }

  void _startTimerIfNeeded() {
    if (_targetTime == null) return;
    _updateRemaining();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateRemaining(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    if (_targetTime == null) {
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
            Text(
              widget.title.toUpperCase(),
              style: AppTypography.labelSmall
                  .copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Maç verileri doğrulandığında burada yayınlanacak.',
              style: TextStyle(color: colors.textSecondary),
            ),
          ],
        ),
      );
    }

    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

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
          Text(
            widget.title.toUpperCase(),
            style:
                AppTypography.labelSmall.copyWith(color: colors.textSecondary),
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
          if (widget.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.description!,
              style: TextStyle(color: colors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      ':',
      style: AppTypography.countdown.copyWith(color: AppColors.primaryRed),
    );
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
