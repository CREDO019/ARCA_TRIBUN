import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Rozetler ekranı — kazanılan ve kilitli rozetler
class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo rozetler
    final badges = [
      {
        'id': 'badge_first',
        'name': 'İlk Adım',
        'desc': 'İlk maçını takip et',
        'earned': true,
        'icon': '🏆'
      },
      {
        'id': 'badge_streak_7',
        'name': '7 Gün Serisi',
        'desc': '7 gün üst üste giriş yap',
        'earned': true,
        'icon': '🔥'
      },
      {
        'id': 'badge_prediction_10',
        'name': 'Tahminci',
        'desc': '10 doğru tahmin yap',
        'earned': false,
        'icon': '🎯'
      },
      {
        'id': 'badge_champion',
        'name': 'Efsane',
        'desc': 'Şampiyonluk sezonunu izle',
        'earned': false,
        'icon': '👑'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Rozetlerim')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          final isEarned = badge['earned'] as bool;

          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isEarned ? AppColors.cardBg : AppColors.deepBlack,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: isEarned
                    ? AppColors.primaryRed.withValues(alpha: 0.5)
                    : AppColors.border,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  badge['icon'] as String,
                  style: TextStyle(
                      fontSize: 40,
                      color: isEarned ? null : const Color(0x44FFFFFF)),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  badge['name'] as String,
                  style: AppTypography.titleMedium.copyWith(
                    color: isEarned ? AppColors.white : AppColors.secondaryGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  badge['desc'] as String,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                if (!isEarned) ...[
                  const SizedBox(height: AppSpacing.xs),
                  const Icon(Icons.lock,
                      color: AppColors.secondaryGray, size: 16),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
