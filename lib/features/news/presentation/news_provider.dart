import 'package:arca_tribun/features/news/data/news_repository.dart';
import 'package:arca_tribun/features/news/domain/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepository(),
);

/// Haber listesi provider — Supabase PostgREST ile sayfalı haber yükleme.
///
/// Firebase: `FirebaseFirestore.instance.collection(path).orderBy().limit().get()`
/// Supabase:  `supabase.from(table).select().order().limit()`
final newsListProvider = FutureProvider<List<NewsModel>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchPublishedNews();
});

final latestNewsProvider = FutureProvider<List<NewsModel>>((ref) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchLatestNews();
});

/// Tek haber detay provider
final newsDetailProvider =
    FutureProvider.family<NewsModel?, String>((ref, newsId) async {
  final repository = ref.watch(newsRepositoryProvider);
  return repository.fetchNewsDetail(newsId);
});
