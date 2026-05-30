import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Kadro ekranı — pozisyona göre gruplu oyuncu listesi
class SquadScreen extends ConsumerWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Demo oyuncular
    final positions = {
      'Kaleciler': [
        {'name': 'Kaleci 1', 'number': 1, 'age': 28},
        {'name': 'Kaleci 2', 'number': 13, 'age': 24},
      ],
      'Defans': [
        {'name': 'Defans 1', 'number': 2, 'age': 26},
        {'name': 'Defans 2', 'number': 5, 'age': 30},
        {'name': 'Defans 3', 'number': 6, 'age': 27},
      ],
      'Orta Saha': [
        {'name': 'Orta Saha 1', 'number': 8, 'age': 25},
        {'name': 'Orta Saha 2', 'number': 10, 'age': 22},
      ],
      'Forvet': [
        {'name': 'Forvet 1', 'number': 9, 'age': 23},
        {'name': 'Forvet 2', 'number': 11, 'age': 21},
      ],
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Kadro')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: positions.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(entry.key.toUpperCase(),
                    style: AppTypography.labelSmall
                        .copyWith(color: AppColors.secondaryGray)),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                ),
                itemCount: entry.value.length,
                itemBuilder: (context, index) {
                  final player = entry.value[index];
                  return GestureDetector(
                    onTap: () => context.push(RouteNames.playerDetailPath(
                        'player_${player['number']}')),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                AppColors.primaryRed.withValues(alpha: 0.2),
                            child: Text('${player['number']}',
                                style: AppTypography.headlineMedium
                                    .copyWith(color: AppColors.primaryRed)),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(player['name'] as String,
                              style: AppTypography.bodySmall,
                              textAlign: TextAlign.center,
                              maxLines: 2),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        }).toList(),
      ),
    );
  }
}
