import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Taraftar tahmin strip widget'ı.
/// Ev sahibi / Beraberlik / Deplasman seçenekleri.
class FanPredictionStrip extends ConsumerStatefulWidget {
  const FanPredictionStrip({super.key});

  @override
  ConsumerState<FanPredictionStrip> createState() => _FanPredictionStripState();
}

class _FanPredictionStripState extends ConsumerState<FanPredictionStrip> {
  int? _selectedOption; // 0: Ev, 1: Ber, 2: Dep
  bool _submitted = false;

  // Demo data — gerçekte predictionProvider'dan gelir
  final Map<int, double> _percentages = {0: 0.45, 1: 0.25, 2: 0.30};

  void _selectOption(int option) {
    if (_submitted) return;
    setState(() => _selectedOption = option);
  }

  Future<void> _submitPrediction() async {
    if (_selectedOption == null) return;
    setState(() => _submitted = true);
    // predictionProvider.submitPrediction(matchId, _selectedOption!)
  }

  @override
  Widget build(BuildContext context) {
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
            'TARAFTAR TAHMİNİ',
            style: AppTypography.labelSmall
                .copyWith(color: AppColors.secondaryGray),
          ),
          const SizedBox(height: AppSpacing.md),

          // ─── Seçenek Butonları ────────────────────────────────────
          Row(
            children: [
              _PredictionOption(
                label: 'Ev\nSahibi',
                percentage: _percentages[0]!,
                isSelected: _selectedOption == 0,
                isSubmitted: _submitted,
                onTap: () => _selectOption(0),
              ),
              const SizedBox(width: AppSpacing.sm),
              _PredictionOption(
                label: 'Bera-\nberlik',
                percentage: _percentages[1]!,
                isSelected: _selectedOption == 1,
                isSubmitted: _submitted,
                onTap: () => _selectOption(1),
              ),
              const SizedBox(width: AppSpacing.sm),
              _PredictionOption(
                label: 'Dep-\nlasman',
                percentage: _percentages[2]!,
                isSelected: _selectedOption == 2,
                isSubmitted: _submitted,
                onTap: () => _selectOption(2),
              ),
            ],
          ),

          if (_selectedOption != null && !_submitted) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPrediction,
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(AppSpacing.smallButtonHeight),
                ),
                child: const Text('TAHMİNİ GÖNDER'),
              ),
            ),
          ],

          if (_submitted) ...[
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                '✓ Tahminin kaydedildi!',
                style:
                    AppTypography.bodyMedium.copyWith(color: AppColors.success),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PredictionOption extends StatelessWidget {
  const _PredictionOption({
    required this.label,
    required this.percentage,
    required this.isSelected,
    required this.isSubmitted,
    required this.onTap,
  });

  final String label;
  final double percentage;
  final bool isSelected;
  final bool isSubmitted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryRed.withValues(alpha: 0.15)
                : AppColors.cardBg2,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isSelected ? AppColors.primaryRed : AppColors.border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? AppColors.white : AppColors.secondaryGray,
                ),
                textAlign: TextAlign.center,
              ),
              if (isSubmitted) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                  style: AppTypography.titleMedium.copyWith(
                    color: isSelected ? AppColors.primaryRed : AppColors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSelected ? AppColors.primaryRed : AppColors.secondaryGray,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
