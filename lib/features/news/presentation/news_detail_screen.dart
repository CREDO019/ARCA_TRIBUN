import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:arca_tribun/features/news/presentation/news_provider.dart';
import 'package:arca_tribun/shared/widgets/content_state.dart';
import 'package:arca_tribun/shared/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

/// Haber detay ekranı
class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final String newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsDetailProvider(newsId));
    final colors = context.arcaColors;

    return newsAsync.when(
      loading: () => Scaffold(
        backgroundColor: colors.background,
        body: const LoadingShimmer(),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: colors.background,
        body: const ContentErrorState(),
      ),
      data: (news) {
        if (news == null) {
          return Scaffold(
            backgroundColor: colors.background,
            body: const BrandedEmptyState(
              icon: Icons.article_outlined,
              title: 'Haber bulunamadı',
              message:
                  'Bu içerik kaldırılmış veya henüz yayınlanmamış olabilir.',
            ),
          );
        }

        return Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            title: Text(news.category),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () =>
                    Share.share('${news.title}\n\nARCA TRİBÜN uygulamasından'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(news.title, style: AppTypography.headlineLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${news.authorName ?? 'ARCA TRİBÜN'} · ${_formatDate(news.publishedAt)}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  news.content,
                  style: AppTypography.bodyLarge
                      .copyWith(color: colors.textPrimary, height: 1.7),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
