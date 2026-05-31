import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/squad/domain/player_model.dart';
import 'package:arca_tribun/features/squad/presentation/squad_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Oyuncu detay ekranı
class PlayerDetailScreen extends ConsumerWidget {
  const PlayerDetailScreen({super.key, required this.playerId});

  final String playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerDetailProvider(playerId));

    return playerAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingShimmer(itemCount: 4),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColors.background,
        body: ContentErrorState(),
      ),
      data: (player) {
        if (player == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: BrandedEmptyState(
              icon: Icons.person_search_outlined,
              title: 'Oyuncu bilgisi bulunamadı',
              message:
                  'Doğrulanmış kadro bilgileri yayınlandığında detaylar burada yer alacak.',
            ),
          );
        }
        return _PlayerDetailContent(player: player);
      },
    );
  }
}

class _PlayerDetailContent extends StatelessWidget {
  const _PlayerDetailContent({required this.player});

  final PlayerModel player;

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
                      child: const Icon(
                        Icons.person,
                        size: 56,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(player.name, style: AppTypography.headlineLarge),
                    Text(
                      '${_positionText(player.position)} · #${player.number}',
                      style: AppTypography.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // İstatistikler
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Row(
                children: [
                  _StatCard(label: 'Maç', value: '${player.appearances}'),
                  const SizedBox(width: AppSpacing.sm),
                  _StatCard(label: 'Gol', value: '${player.goals}'),
                  const SizedBox(width: AppSpacing.sm),
                  _StatCard(label: 'Asist', value: '${player.assists}'),
                ],
              ),
            ),

            // Profil bilgileri
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  _InfoRow(label: 'Yaş', value: '${player.age ?? '-'}'),
                  _InfoRow(
                    label: 'Milliyet',
                    value: player.nationality ?? '-',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _positionText(String raw) {
    switch (raw.toLowerCase()) {
      case 'goalkeeper':
        return 'Kaleci';
      case 'defender':
        return 'Defans';
      case 'midfielder':
        return 'Orta Saha';
      case 'forward':
        return 'Forvet';
      default:
        return raw;
    }
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
            Text(
              value,
              style: AppTypography.headlineLarge
                  .copyWith(color: AppColors.primaryRed),
            ),
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
