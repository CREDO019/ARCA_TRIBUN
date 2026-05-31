import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Mağaza / Sponsor banner card
class StoreBannerCard extends StatelessWidget {
  const StoreBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('store_banner_card'),
      onTap: () => _openStore(context),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryRed, AppColors.primaryRedDark],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            const Icon(
              Icons.store_outlined,
              color: AppColors.white,
              size: AppSpacing.iconXl,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forma & Taraftar Ürünleri',
                    style: AppTypography.titleLarge,
                  ),
                  Text(
                    'Mağaza bağlantısı kulüp onayı sonrası eklenecek.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.white,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openStore(BuildContext context) async {
    final uri = Uri.tryParse(SupabaseConfig.storeUrl);
    final canOpenStore = uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        await canLaunchUrl(uri);

    if (canOpenStore) {
      final didOpen = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (didOpen) return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mağaza bağlantısı yakında eklenecek.')),
    );
  }
}
