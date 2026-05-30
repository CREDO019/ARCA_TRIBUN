import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../auth/presentation/auth_provider.dart';
import 'fan_profile_provider.dart';

/// Profil ekranı — fan puanı, seviye, streak, rozetler, sıralama
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(fanProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go(RouteNames.login);
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(
            child: Text('Profil yüklenemedi', style: AppTypography.bodyMedium)),
        data: (profile) {
          // Guest veya profil yoksa placeholder
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline,
                      size: 80, color: AppColors.secondaryGray),
                  const SizedBox(height: AppSpacing.md),
                  Text('Profil bulunamadı', style: AppTypography.bodyMedium),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => context.go(RouteNames.login),
                    child: const Text('Giriş Yap'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                // ─── Profil Header ──────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(colors: AppColors.heroGradient),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            AppColors.primaryRed.withValues(alpha: 0.3),
                        child: Text(
                          profile.displayName.isNotEmpty
                              ? profile.displayName[0].toUpperCase()
                              : 'T',
                          style: AppTypography.displayMedium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(profile.displayName,
                          style: AppTypography.headlineMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text('${profile.fanLevelTitle} Taraftar',
                            style: AppTypography.labelSmall),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ─── İstatistik Kartları ─────────────────────────────
                Row(
                  children: [
                    _StatCard(
                        label: 'Fan Puanı',
                        value: '${profile.fanPoints}',
                        icon: Icons.star),
                    const SizedBox(width: AppSpacing.md),
                    _StatCard(
                        label: 'Seviye',
                        value: '${profile.fanLevel}',
                        icon: Icons.emoji_events),
                    const SizedBox(width: AppSpacing.md),
                    _StatCard(
                        label: 'Streak',
                        value: '${profile.currentStreak}',
                        icon: Icons.local_fire_department),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // ─── Tahmin Başarısı ─────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStat(
                          label: 'Toplam\nTahmin',
                          value: '${profile.totalPredictions}'),
                      _ProfileStat(
                          label: 'Doğru\nTahmin',
                          value: '${profile.correctPredictions}'),
                      _ProfileStat(
                          label: 'Başarı\nOranı',
                          value:
                              '%${(profile.predictionAccuracy * 100).toStringAsFixed(0)}'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ─── Hızlı Erişim ────────────────────────────────────
                _QuickAccessTile(
                  icon: Icons.military_tech,
                  label: 'Rozetlerim',
                  subtitle: '${profile.earnedBadgeIds.length} rozet kazanıldı',
                  onTap: () => context.push(RouteNames.badges),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  icon: Icons.leaderboard,
                  label: 'Sıralama',
                  subtitle: 'Bu haftaki taraftar sıralaması',
                  onTap: () => context.push(RouteNames.leaderboard),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  icon: Icons.notifications_outlined,
                  label: 'Bildirim Ayarları',
                  subtitle: 'Gol ve maç bildirimlerini yönet',
                  onTap: () => context.push(RouteNames.notificationPrefs),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(
      {required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

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
            Icon(icon, color: AppColors.primaryRed, size: AppSpacing.iconXl),
            const SizedBox(height: AppSpacing.xs),
            Text(value,
                style: AppTypography.headlineMedium
                    .copyWith(color: AppColors.primaryRed)),
            Text(label,
                style: AppTypography.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.headlineMedium),
        Text(label,
            style: AppTypography.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: const BorderSide(color: AppColors.border),
      ),
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(label, style: AppTypography.titleMedium),
      subtitle: Text(subtitle, style: AppTypography.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios, size: AppSpacing.iconSm),
      onTap: onTap,
    );
  }
}
