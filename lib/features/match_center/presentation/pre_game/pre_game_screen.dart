import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Maç öncesi ekranı — kadro, stadyum, hava durumu bilgileri
class PreGameScreen extends StatelessWidget {
  const PreGameScreen({super.key, required this.matchId});

  final String matchId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Maç Öncesi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Maç bilgisi
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.heroGradient),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  Text('Arca Çorum FK vs Rakip Takım',
                      style: AppTypography.headlineMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text('20:45 • Atatürk Stadyumu',
                      style: AppTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Muhtemel 11
            Text('MUHTEMEL 11',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.secondaryGray)),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text('Kadro verisi bekleniyor...',
                    style: TextStyle(color: AppColors.secondaryGray)),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Hava durumu
            Text('HAVA DURUMU',
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
                  const Icon(Icons.wb_sunny_outlined,
                      color: AppColors.warning, size: 40),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('22°C · Açık', style: AppTypography.titleLarge),
                      Text('Nem: %45 · Rüzgar: 12 km/s',
                          style: AppTypography.bodySmall),
                    ],
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
