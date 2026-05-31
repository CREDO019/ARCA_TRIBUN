import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/shared/widgets/pilot_demo_badge.dart';
import 'package:arca_tribun/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> showProjectInfoDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      key: const Key('project_info_dialog'),
      title: const Text('Uygulama Hakkında'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('ARCA TRİBÜN', style: AppTypography.headlineMedium),
                if (SupabaseConfig.enablePilotDemo) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const PilotDemoBadge(),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const _InfoRow(
              label: 'Proje',
              value: 'Dijital taraftar platformu pilot çalışması',
            ),
            FutureBuilder<String>(
              future: _appVersion(),
              builder: (context, snapshot) => _InfoRow(
                label: 'Sürüm',
                value: snapshot.data ?? 'Yükleniyor',
              ),
            ),
            const _InfoRow(label: 'Geliştirici', value: 'Emirhan Özkaya'),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.primaryRed.withValues(alpha: 0.24),
                ),
              ),
              child: Text(
                'Bu uygulama pilot/prototip çalışmadır. '
                'Resmi kullanım için kulüp onayı gerektirir.',
                style: AppTypography.bodyMedium,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Kulüp onayı sonrası resmi kullanıma uygun hale getirilebilir.',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('KAPAT'),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.secondaryGray,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }
}

Future<String> _appVersion() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  } catch (_) {
    return '1.0.0';
  }
}
