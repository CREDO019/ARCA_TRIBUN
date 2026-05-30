import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Fikstür ekranı — yaklaşan ve geçmiş maçlar
class FixturesScreen extends ConsumerWidget {
  const FixturesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Demo fixtures
    final fixtures = List.generate(
        8,
        (i) => {
              'homeTeam': 'Arca Çorum FK',
              'awayTeam': 'Takım ${i + 1}',
              'date': DateTime.now().add(Duration(days: (i + 1) * 7)),
              'competition': 'Süper Lig',
              'result': i < 3 ? '${2 - i} - $i' : null,
            });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Fikstür')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: fixtures.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final f = fixtures[index];
          final date = f['date'] as DateTime;
          final result = f['result'] as String?;

          return Container(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Column(
                    children: [
                      Text('${date.day}', style: AppTypography.headlineMedium),
                      Text(_monthStr(date.month),
                          style: AppTypography.labelSmall
                              .copyWith(color: AppColors.secondaryGray)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${f['homeTeam']} vs ${f['awayTeam']}',
                          style: AppTypography.titleMedium),
                      Text(f['competition'] as String,
                          style: AppTypography.bodySmall),
                    ],
                  ),
                ),
                if (result != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Text(result,
                        style: AppTypography.titleMedium
                            .copyWith(color: AppColors.primaryRed)),
                  )
                else
                  Text(
                      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                      style: AppTypography.bodyMedium),
              ],
            ),
          );
        },
      ),
    );
  }

  String _monthStr(int month) => [
        '',
        'Oca',
        'Şub',
        'Mar',
        'Nis',
        'May',
        'Haz',
        'Tem',
        'Ağu',
        'Eyl',
        'Eki',
        'Kas',
        'Ara'
      ][month];
}
