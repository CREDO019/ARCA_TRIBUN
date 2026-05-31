import 'package:arca_tribun/core/notifications/topic_manager.dart';
import 'package:arca_tribun/core/pilot/pilot_data.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/notification_preferences/presentation/notification_prefs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bildirim ayarları ekranı
class NotificationPrefsScreen extends ConsumerWidget {
  const NotificationPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(notificationPrefsProvider);
    final colors = context.arcaColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Bildirim Ayarları')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text('BİLDİRİM MERKEZİ', style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          ...PilotData.notificationCards.map(
            (card) => _NotificationCard(
              title: card['title']!,
              body: card['body']!,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('BİLDİRİM AYARLARI', style: AppTypography.labelSmall),
          const SizedBox(height: AppSpacing.sm),
          _NotifSection(
            title: 'GOL BİLDİRİMLERİ',
            subtitle: 'Her gol için anlık bildirim al',
            value: prefs.goalAlerts,
            onChanged: (value) {
              ref.read(notificationPrefsProvider.notifier).setGoalAlerts(value);
              TopicManager.instance.setGoalAlertsEnabled(enabled: value);
            },
          ),
          _NotifSection(
            title: 'MAÇ BİLDİRİMLERİ',
            subtitle: 'Kırmızı kart ve önemli olaylar',
            value: prefs.matchAlerts,
            onChanged: (value) {
              ref
                  .read(notificationPrefsProvider.notifier)
                  .setMatchAlerts(value);
            },
          ),
          _NotifSection(
            title: 'HABER BİLDİRİMLERİ',
            subtitle: 'Kulüp haberleri ve duyurular',
            value: prefs.newsAlerts,
            onChanged: (value) {
              ref.read(notificationPrefsProvider.notifier).setNewsAlerts(value);
              TopicManager.instance.setNewsAlertsEnabled(enabled: value);
            },
          ),
          _NotifSection(
            title: 'MAÇ BAŞLANGICI',
            subtitle: 'Maç başlamadan önce hatırlatma',
            value: prefs.matchStartAlerts,
            onChanged: (value) {
              ref
                  .read(notificationPrefsProvider.notifier)
                  .setMatchStartAlerts(value);
              TopicManager.instance.setMatchStartAlertsEnabled(enabled: value);
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined, color: AppColors.primaryRed),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                Text(body, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifSection extends StatelessWidget {
  const _NotifSection({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.arcaColors;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium),
                Text(subtitle, style: AppTypography.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.primaryRed,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
