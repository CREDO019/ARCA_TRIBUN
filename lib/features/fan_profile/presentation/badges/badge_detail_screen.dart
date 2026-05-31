import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Rozet detay ekranı
class BadgeDetailScreen extends StatelessWidget {
  const BadgeDetailScreen({super.key, required this.badgeId});

  final String badgeId;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Rozet Detayı')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏆', style: TextStyle(fontSize: 80)),
              const SizedBox(height: AppSpacing.xl),
              Text('Rozet Adı', style: AppTypography.headlineLarge),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Bu rozeti kazanmak için görev koşulunu tamamlamanız gerekir.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
