import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

/// Oyuncu detay ekranı
class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key, required this.playerId});

  final String playerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Oyuncu Profili')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero bölümü
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: AppColors.heroGradient),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor:
                          AppColors.primaryRed.withValues(alpha: 0.3),
                      child: const Icon(Icons.person,
                          size: 56, color: AppColors.white),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Oyuncu Adı', style: AppTypography.headlineLarge),
                    Text('Orta Saha · #10', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),

            // İstatistikler
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Row(
                children: [
                  _StatCard(label: 'Maç', value: '18'),
                  const SizedBox(width: AppSpacing.sm),
                  _StatCard(label: 'Gol', value: '7'),
                  const SizedBox(width: AppSpacing.sm),
                  _StatCard(label: 'Asist', value: '5'),
                ],
              ),
            ),

            // Profil bilgileri
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  _InfoRow(label: 'Yaş', value: '24'),
                  _InfoRow(label: 'Milliyet', value: '🇹🇷 Türkiye'),
                  _InfoRow(label: 'Boy', value: '182 cm'),
                  _InfoRow(label: 'Ayak', value: 'Sağ'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value,
                style: AppTypography.headlineLarge
                    .copyWith(color: AppColors.primaryRed)),
            Text(label, style: AppTypography.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.titleMedium),
        ],
      ),
    );
  }
}
