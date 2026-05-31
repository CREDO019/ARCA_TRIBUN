import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/fan_profile_model.dart';
import 'fan_profile_provider.dart';

/// Profil ekranı - yalnızca Supabase fan_profiles verisini gösterir.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(fanProfileProvider);
    final email = ref.watch(currentUserEmailProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profilim')),
      body: profileAsync.when(
        loading: () => const LoadingShimmer(),
        error: (_, __) => _ProfileMessage(
          icon: Icons.cloud_off_outlined,
          title: 'Profil yüklenemedi',
          message:
              'Bilgilerinizi şu anda getiremiyoruz. Lütfen tekrar deneyin.',
          actionLabel: 'Tekrar Dene',
          onAction: () => ref.invalidate(fanProfileProvider),
        ),
        data: (profile) {
          if (profile == null) {
            return _ProfileMessage(
              icon: Icons.person_outline,
              title: 'Profil hazırlanıyor',
              message: 'Taraftar profiliniz kısa süre içinde hazır olacak.',
              actionLabel: 'Tekrar Dene',
              onAction: () => ref.invalidate(fanProfileProvider),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeader(profile: profile, email: email),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    _StatCard(
                      label: 'Fan Puanı',
                      value: '${profile.fanPoints}',
                      icon: Icons.star,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _StatCard(
                      label: 'Seviye',
                      value: '${profile.fanLevel}',
                      icon: Icons.emoji_events,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                _QuickAccessTile(
                  tileKey: const Key('edit_profile_tile'),
                  icon: Icons.edit_outlined,
                  label: 'Profil Bilgilerini Düzenle',
                  subtitle: 'Tribünde görünecek kullanıcı adını güncelle',
                  onTap: () => _editDisplayName(context, ref, profile),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  icon: Icons.military_tech,
                  label: 'Rozetlerim',
                  subtitle: 'Rozet sistemi yakında aktif olacak',
                  onTap: () => _showInfo(
                    context,
                    'Rozet sistemi yakında aktif olacak.',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  icon: Icons.leaderboard,
                  label: 'Sıralama',
                  subtitle: 'Taraftar sıralaması hazırlanıyor',
                  onTap: () => _showInfo(
                    context,
                    'Taraftar sıralaması yakında aktif olacak.',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  icon: Icons.notifications_outlined,
                  label: 'Bildirim Ayarları',
                  subtitle: 'Gol ve maç bildirimlerini yönet',
                  onTap: () => context.push(RouteNames.notificationPrefs),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  tileKey: const Key('request_account_delete_tile'),
                  icon: Icons.delete_outline,
                  label: 'Hesabı Sil',
                  subtitle: 'Hesap silme talebi hakkında bilgi al',
                  onTap: () => _showInfo(
                    context,
                    'Hesap silme işlemi yakında desteklenecek.',
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton.icon(
                  key: const Key('logout_button'),
                  onPressed: () => _logout(context, ref),
                  icon: const Icon(Icons.logout),
                  label: const Text('ÇIKIŞ YAP'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile, required this.email});

  final FanProfileModel profile;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.heroGradient),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryRed.withValues(alpha: 0.3),
            child: Text(
              profile.displayName.isNotEmpty
                  ? profile.displayName[0].toUpperCase()
                  : 'T',
              style: AppTypography.displayMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(profile.displayName, style: AppTypography.headlineMedium),
          if (email != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(email!, style: AppTypography.bodySmall),
          ],
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '${profile.fanLevelTitle} Taraftar',
              style: AppTypography.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

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
            Text(
              value,
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primaryRed,
              ),
            ),
            Text(
              label,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  const _QuickAccessTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.tileKey,
  });

  final Key? tileKey;
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: tileKey,
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

class _ProfileMessage extends StatelessWidget {
  const _ProfileMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.secondaryGray),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

Future<void> _editDisplayName(
  BuildContext context,
  WidgetRef ref,
  FanProfileModel profile,
) async {
  final controller = TextEditingController(text: profile.displayName);
  final formKey = GlobalKey<FormState>();

  final displayName = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Kullanıcı Adını Düzenle'),
      content: Form(
        key: formKey,
        child: TextFormField(
          key: const Key('display_name_field'),
          controller: controller,
          autofocus: true,
          maxLength: 40,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
          validator: (value) {
            final normalizedValue = value?.trim() ?? '';
            if (normalizedValue.length < 3) return 'En az 3 karakter olmalı';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          key: const Key('save_display_name_button'),
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Kaydet'),
        ),
      ],
    ),
  );
  controller.dispose();

  if (displayName == null || !context.mounted) return;

  try {
    await ref.read(fanProfileRepositoryProvider).updateDisplayName(displayName);
    ref.invalidate(fanProfileProvider);
    if (context.mounted) {
      _showInfo(context, 'Profil bilgileriniz güncellendi.');
    }
  } catch (_) {
    if (context.mounted) {
      _showInfo(
        context,
        'Profil bilgileriniz güncellenemedi. Lütfen tekrar deneyin.',
        isError: true,
      );
    }
  }
}

Future<void> _logout(BuildContext context, WidgetRef ref) async {
  await ref.read(authNotifierProvider.notifier).logout();
  if (!context.mounted) return;

  final authState = ref.read(authNotifierProvider);
  if (authState.hasError) {
    _showInfo(
      context,
      'Oturum kapatılamadı. Lütfen tekrar deneyin.',
      isError: true,
    );
    return;
  }

  context.go(RouteNames.login);
}

void _showInfo(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.errorRed : AppColors.cardBg2,
    ),
  );
}
