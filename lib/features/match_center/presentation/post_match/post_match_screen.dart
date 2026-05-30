import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Maç sonu ekranı — özet, oyunun adamı, fan oylaması
class PostMatchScreen extends StatelessWidget {
  const PostMatchScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Maç Sonu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Final skor
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.heroGradient),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  Text('MAÇ SONA ERDİ',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.secondaryGray)),
                  const SizedBox(height: AppSpacing.sm),
                  Text('2 - 1', style: AppTypography.scoreDisplay),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Arca Çorum FK - Rakip Takım',
                      style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Maçın Adamı
            Text('MAÇIN ADAMI',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.secondaryGray)),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        AppColors.primaryRed.withValues(alpha: 0.2),
                    child: const Icon(Icons.person,
                        color: AppColors.primaryRed, size: 30),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Oyuncu Adı', style: AppTypography.titleLarge),
                      Text('1 Gol · 1 Asist', style: AppTypography.bodySmall),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: const Icon(Icons.star,
                        color: AppColors.white, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Oyunun Adamı Oylaması
            Text('TARAFTAR OYLAMASI',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.secondaryGray)),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Text('Maçın Adamını Seç', style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('OY VER'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
