import 'dart:async';

import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/core/theme/theme_preference_provider.dart';
import 'package:arca_tribun/features/auth/presentation/auth_provider.dart';
import 'package:arca_tribun/features/fan_profile/domain/fan_profile_model.dart';
import 'package:arca_tribun/features/fan_profile/presentation/fan_profile_provider.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:arca_tribun/shared/widgets/project_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Profil ekranı - yalnızca Supabase fan_profiles verisini gösterir.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(fanProfileProvider);
    final email = ref.watch(currentUserEmailProvider);
    final themePreference = ref.watch(themePreferenceProvider);
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
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
                _ThemePreferenceSection(
                  preference: themePreference,
                  onChanged: (preference) {
                    ref
                        .read(themePreferenceProvider.notifier)
                        .setPreference(preference);
                  },
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
                  tileKey: const Key('project_info_tile'),
                  icon: Icons.info_outline,
                  label: 'Uygulama Hakkında',
                  subtitle: 'Pilot çalışma ve sürüm bilgileri',
                  onTap: () => showProjectInfoDialog(context),
                ),
                const SizedBox(height: AppSpacing.sm),
                _QuickAccessTile(
                  tileKey: const Key('request_account_delete_tile'),
                  icon: Icons.delete_outline,
                  label: 'Hesabı Sil',
                  subtitle: 'Hesabını ve taraftar verilerini kalıcı olarak sil',
                  onTap: () => _deleteAccount(context, ref),
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
    final colors = context.arcaColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors.heroGradient),
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
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.displayName,
            style:
                AppTypography.headlineMedium.copyWith(color: AppColors.white),
          ),
          if (email != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              email!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.76),
              ),
            ),
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
              style: AppTypography.labelSmall.copyWith(color: AppColors.white),
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
    final colors = context.arcaColors;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: colors.border),
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

class _ThemePreferenceSection extends StatelessWidget {
  const _ThemePreferenceSection({
    required this.preference,
    required this.onChanged,
  });

  final ThemePreference preference;
  final ValueChanged<ThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tema', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Uygulama görünümünü sistem ayarına bırak veya elle seç.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final option in ThemePreference.values)
            _ThemePreferenceOption(
              key: Key('theme_${option.name}_option'),
              preference: option,
              isSelected: option == preference,
              description: _themePreferenceDescription(option),
              onTap: () => onChanged(option),
            ),
        ],
      ),
    );
  }

  String _themePreferenceDescription(ThemePreference preference) {
    switch (preference) {
      case ThemePreference.system:
        return 'Telefonun açık/koyu tema ayarını takip eder.';
      case ThemePreference.light:
        return 'Açık yüzeyler ve kırmızı marka aksanları kullanılır.';
      case ThemePreference.dark:
        return 'Koyu yüzeyler ve yüksek kontrastlı metinler kullanılır.';
    }
  }
}

class _ThemePreferenceOption extends StatelessWidget {
  const _ThemePreferenceOption({
    required this.preference,
    required this.description,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final ThemePreference preference;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primaryRed : colors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(preference.label),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall,
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
    final colors = context.arcaColors;

    return ListTile(
      key: tileKey,
      tileColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: colors.border),
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
    final colors = context.arcaColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: colors.textSecondary),
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
  final displayName = await showDialog<String>(
    context: context,
    builder: (_) => _EditDisplayNameDialog(
      initialDisplayName: profile.displayName,
    ),
  );

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

class _EditDisplayNameDialog extends StatefulWidget {
  const _EditDisplayNameDialog({required this.initialDisplayName});

  final String initialDisplayName;

  @override
  State<_EditDisplayNameDialog> createState() => _EditDisplayNameDialogState();
}

class _EditDisplayNameDialogState extends State<_EditDisplayNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDisplayName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Kullanıcı Adını Düzenle'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          key: const Key('display_name_field'),
          controller: _controller,
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
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(_controller.text.trim());
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
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

Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          key: const Key('delete_account_dialog'),
          title: const Text('Hesabı kalıcı olarak sil'),
          content: const Text(
            'Profilin, tahminlerin ve taraftar verilerin kalıcı olarak '
            'silinecek. Bu işlem geri alınamaz.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Vazgeç'),
            ),
            ElevatedButton(
              key: const Key('confirm_delete_account_button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('HESABIMI SİL'),
            ),
          ],
        ),
      ) ??
      false;

  if (!confirmed || !context.mounted) return;

  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        key: Key('delete_account_progress'),
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: AppSpacing.md),
            Expanded(child: Text('Hesabınız siliniyor...')),
          ],
        ),
      ),
    ),
  );

  await ref.read(authNotifierProvider.notifier).deleteAccount();
  if (!context.mounted) return;

  Navigator.of(context, rootNavigator: true).pop();
  final authState = ref.read(authNotifierProvider);
  if (authState.hasError) {
    _showInfo(
      context,
      'Hesabınız silinemedi. Lütfen tekrar deneyin.',
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
      backgroundColor: isError ? AppColors.errorRed : null,
    ),
  );
}
