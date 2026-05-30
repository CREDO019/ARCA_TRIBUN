import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_tables.dart';
import '../domain/fan_profile_model.dart';

/// Fan profili stream provider — Supabase Realtime.
///
/// Firebase: `FirebaseAuth.instance.currentUser?.uid` + `FirebaseFirestore...`
/// Supabase:  `supabase.auth.currentUser?.id` + `supabase.from(...).stream(...)`
///
/// RLS politikası: kullanıcı yalnızca kendi profilini okuyabilir.
/// Tablo: fan_profiles (id = auth.uid)
final fanProfileProvider = StreamProvider<FanProfileModel?>((ref) {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return Stream.value(null);

  return supabase
      .from(SupabaseTables.fanProfiles)
      .stream(primaryKey: [SupabaseTables.colId])
      .eq(SupabaseTables.colId, userId)
      .map((rows) {
        if (rows.isEmpty) return null;
        return FanProfileModel.fromSupabase(rows.first);
      });
});

/// Leaderboard provider — en yüksek puanlı 50 taraftar.
///
/// Supabase Realtime stream ile canlı güncellenir.
final leaderboardProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;

  final rows = await supabase
      .from(SupabaseTables.leaderboard)
      .select('user_id, ${SupabaseTables.colDisplayName}, total_points, rank')
      .order('rank', ascending: true)
      .limit(50);

  return List<Map<String, dynamic>>.from(rows);
});

/// Kullanıcının sıralama pozisyonu provider
final userRankProvider = FutureProvider<int?>((ref) async {
  final supabase = Supabase.instance.client;
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) return null;

  final row = await supabase
      .from(SupabaseTables.leaderboard)
      .select('rank')
      .eq(SupabaseTables.colUserId, userId)
      .maybeSingle();

  return row?['rank'] as int?;
});
