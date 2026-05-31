import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/news/presentation/news_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Son haberler yatay kaydırmalı liste
class NewsHorizontalScroll extends ConsumerWidget {
  const NewsHorizontalScroll({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(latestNewsProvider);
    final colors = context.arcaColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SON HABERLER',
              style: AppTypography.labelSmall
                  .copyWith(color: colors.textSecondary),
            ),
            TextButton(
              onPressed: () => context.push(RouteNames.newsList),
              child: const Text('Tümünü Gör'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        newsAsync.when(
          loading: () => SizedBox(
            height: AppSpacing.newsCardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, __) => Container(
                width: 220,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: colors.border),
                ),
              ),
            ),
          ),
          error: (_, __) => Container(
            height: AppSpacing.newsCardHeight,
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: colors.border),
            ),
            child: const ContentErrorState(compact: true),
          ),
          data: (newsList) {
            if (newsList.isEmpty) {
              return Container(
                height: AppSpacing.newsCardHeight,
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: colors.border),
                ),
                child: const BrandedEmptyState(
                  icon: Icons.campaign_outlined,
                  title: 'Tribün gündemi hazırlanıyor',
                  message: 'İçerikler eklendiğinde burada görünecek.',
                  compact: true,
                ),
              );
            }

            return SizedBox(
              height: AppSpacing.newsCardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: newsList.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = newsList[index];
                  return GestureDetector(
                    onTap: () =>
                        context.push(RouteNames.newsDetailPath(item.id)),
                    child: Container(
                      width: 220,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: colors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryRed.withValues(alpha: 0.15),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusFull),
                            ),
                            child: Text(
                              item.category,
                              style: AppTypography.labelSmall
                                  .copyWith(color: AppColors.primaryRed),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              item.title,
                              style: AppTypography.titleMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            _relativeDate(item.publishedAt),
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _relativeDate(DateTime publishedAt) {
    final diff = DateTime.now().difference(publishedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk';
    if (diff.inHours < 24) return '${diff.inHours} sa';
    return '${diff.inDays} gün';
  }
}
