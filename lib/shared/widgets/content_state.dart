import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// İçerik bekleyen ekranlarda tutarlı, markaya uygun boş durum gösterir.
class BrandedEmptyState extends StatelessWidget {
  const BrandedEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          compact ? AppSpacing.md : AppSpacing.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 42 : 58,
              height: compact ? 42 : 58,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: AppColors.primaryRed.withValues(alpha: 0.22),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryRedLight,
                size: compact ? AppSpacing.iconMd : AppSpacing.iconXl,
              ),
            ),
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.lg),
            Text(
              title,
              style: compact
                  ? AppTypography.titleMedium
                  : AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Teknik ayrıntıları kullanıcıya sızdırmadan yeniden deneme sunar.
class ContentErrorState extends StatelessWidget {
  const ContentErrorState({
    super.key,
    this.onRetry,
    this.compact = false,
  });

  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          compact ? AppSpacing.md : AppSpacing.screenPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh_rounded,
              color: AppColors.primaryRedLight,
              size: compact ? AppSpacing.iconLg : AppSpacing.iconXl,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'İçerik şu anda yüklenemedi.',
              style: compact
                  ? AppTypography.titleMedium
                  : AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Lütfen kısa süre sonra tekrar deneyin.',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('TEKRAR DENE'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
