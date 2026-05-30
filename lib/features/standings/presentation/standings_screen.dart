import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Puan durumu ekranı — Süper Lig tablosu
class StandingsScreen extends ConsumerWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Demo standings — gerçekte standingsProvider'dan gelir
    final teams = List.generate(
        10,
        (i) => {
              'name': i == 2 ? 'Arca Çorum FK' : 'Takım ${i + 1}',
              'played': 20,
              'won': 12 - i,
              'drawn': 4,
              'lost': i + 4,
              'gf': 35 - i * 2,
              'ga': 20 + i,
              'points': 40 - i * 3,
              'position': i + 1,
            });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Puan Durumu')),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding, vertical: AppSpacing.sm),
            child: Row(
              children: [
                const SizedBox(width: 30),
                Expanded(
                    child: Text('KULÜP',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.secondaryGray))),
                SizedBox(
                    width: 25,
                    child: Text('O',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.secondaryGray),
                        textAlign: TextAlign.center)),
                SizedBox(
                    width: 25,
                    child: Text('G',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.secondaryGray),
                        textAlign: TextAlign.center)),
                SizedBox(
                    width: 25,
                    child: Text('B',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.secondaryGray),
                        textAlign: TextAlign.center)),
                SizedBox(
                    width: 25,
                    child: Text('M',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.secondaryGray),
                        textAlign: TextAlign.center)),
                SizedBox(
                    width: 30,
                    child: Text('P',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.primaryRed),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          Expanded(
            child: ListView.separated(
              itemCount: teams.length,
              separatorBuilder: (_, __) =>
                  const Divider(color: AppColors.border, height: 1),
              itemBuilder: (context, index) {
                final team = teams[index];
                final isOurTeam = team['name'] == 'Arca Çorum FK';

                return Container(
                  color: isOurTeam
                      ? AppColors.primaryRed.withValues(alpha: 0.08)
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 30,
                          child: Text('${team['position']}',
                              style: AppTypography.bodyMedium)),
                      Expanded(
                        child: Text(
                          team['name'] as String,
                          style: isOurTeam
                              ? AppTypography.titleMedium
                                  .copyWith(color: AppColors.primaryRed)
                              : AppTypography.bodyMedium
                                  .copyWith(color: AppColors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                          width: 25,
                          child: Text('${team['played']}',
                              style: AppTypography.bodySmall,
                              textAlign: TextAlign.center)),
                      SizedBox(
                          width: 25,
                          child: Text('${team['won']}',
                              style: AppTypography.bodySmall,
                              textAlign: TextAlign.center)),
                      SizedBox(
                          width: 25,
                          child: Text('${team['drawn']}',
                              style: AppTypography.bodySmall,
                              textAlign: TextAlign.center)),
                      SizedBox(
                          width: 25,
                          child: Text('${team['lost']}',
                              style: AppTypography.bodySmall,
                              textAlign: TextAlign.center)),
                      SizedBox(
                          width: 30,
                          child: Text('${team['points']}',
                              style: AppTypography.titleMedium
                                  .copyWith(color: AppColors.white),
                              textAlign: TextAlign.center)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
