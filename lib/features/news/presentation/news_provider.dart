import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/news_repository.dart';
import '../domain/news_model.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(),
);

/// Haber listesi provider — Supabase PostgREST ile sayfalı haber yükleme.
///
/// Firebase: `FirebaseFirestore.instance.collection(path).orderBy().limit().get()`
/// Supabase:  `supabase.from(table).select().order().limit()`
final newsListProvider = FutureProvider<List<NewsModel>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchPublishedNews(limit: 20);
});

final latestNewsProvider = FutureProvider<List<NewsModel>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchLatestNews(limit: 5);
});

/// Tek haber detay provider
final newsDetailProvider =
    FutureProvider.family<NewsModel?, String>((ref, newsId) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchNewsDetail(newsId);
});
