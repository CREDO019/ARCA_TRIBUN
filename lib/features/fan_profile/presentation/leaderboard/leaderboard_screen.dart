import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../fan_profile_provider.dart';

/// Sıralama ekranı — global leaderboard
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Sıralama')),
      body: leaderboardAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(
            child:
                Text('Sıralama yüklenemedi', style: AppTypography.bodyMedium)),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.leaderboard,
                      size: 60, color: AppColors.secondaryGray),
                  const SizedBox(height: AppSpacing.md),
                  Text('Henüz sıralama yok', style: AppTypography.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final rank = index + 1;

              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: rank <= 3
                      ? AppColors.primaryRed.withValues(alpha: 0.1)
                      : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: rank <= 3
                        ? AppColors.primaryRed.withValues(alpha: 0.3)
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: Text(
                        rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : '$rank',
                        style: rank <= 3
                            ? const TextStyle(fontSize: 20)
                            : AppTypography.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        entry['displayName'] as String? ?? 'Taraftar',
                        style: AppTypography.titleMedium,
                      ),
                    ),
                    Text(
                      '${entry['fanPoints'] ?? 0} P',
                      style: AppTypography.titleMedium
                          .copyWith(color: AppColors.primaryRed),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
