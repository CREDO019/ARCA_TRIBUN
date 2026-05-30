import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import 'news_provider.dart';

/// Haber detay ekranı
class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.newsId});

  final String newsId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsDetailProvider(newsId));

    return newsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: LoadingShimmer(),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'İçerik yüklenemedi. Lütfen tekrar deneyin.',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (news) {
        if (news == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(),
            body: const Center(
                child: Text('Haber bulunamadı',
                    style: TextStyle(color: AppColors.white))),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(news.category),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () =>
                    Share.share('${news.title}\n\nARCA Tribün uygulamasından'),
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
                  '${news.authorName ?? 'ARCA Tribün'} · ${_formatDate(news.publishedAt)}',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(news.content,
                    style: AppTypography.bodyLarge
                        .copyWith(color: AppColors.white, height: 1.7)),
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
