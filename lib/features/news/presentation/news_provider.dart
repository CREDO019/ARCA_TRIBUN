import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_tables.dart';
import '../domain/news_model.dart';

/// Haber listesi provider — Supabase PostgREST ile sayfalı haber yükleme.
///
/// Firebase: `FirebaseFirestore.instance.collection(path).orderBy().limit().get()`
/// Supabase:  `supabase.from(table).select().order().limit()`
final newsListProvider = FutureProvider<List<NewsModel>>((ref) async {
  final supabase = Supabase.instance.client;

  final rows = await supabase
      .from(SupabaseTables.news)
      .select()
      .order(SupabaseTables.colPublishedAt, ascending: false)
      .limit(20);

  return rows.map((row) => NewsModel.fromSupabase(row)).toList();
});

/// Tek haber detay provider
final newsDetailProvider =
    FutureProvider.family<NewsModel?, String>((ref, newsId) async {
  final supabase = Supabase.instance.client;

  final row = await supabase
      .from(SupabaseTables.news)
      .select()
      .eq(SupabaseTables.colId, newsId)
      .maybeSingle();

  if (row == null) return null;
  return NewsModel.fromSupabase(row);
});
