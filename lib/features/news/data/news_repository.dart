import 'package:arca_tribun/core/constants/supabase_tables.dart';
import 'package:arca_tribun/features/news/domain/news_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewsRepository {
  NewsRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<NewsModel>> fetchPublishedNews({int limit = 20}) async {
    final rows = await _client
        .from(SupabaseTables.news)
        .select()
        .eq(SupabaseTables.colStatus, 'published')
        .order(SupabaseTables.colPublishedAt, ascending: false)
        .limit(limit);

    return rows.map(NewsModel.fromSupabase).toList();
  }

  Future<List<NewsModel>> fetchLatestNews({int limit = 5}) {
    return fetchPublishedNews(limit: limit);
  }

  Future<NewsModel?> fetchNewsDetail(String newsId) async {
    final row = await _client
        .from(SupabaseTables.news)
        .select()
        .eq(SupabaseTables.colId, newsId)
        .eq(SupabaseTables.colStatus, 'published')
        .maybeSingle();

    if (row == null) return null;
    return NewsModel.fromSupabase(row);
  }
}
