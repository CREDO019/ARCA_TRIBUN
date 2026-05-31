import 'package:arca_tribun/core/constants/supabase_tables.dart';
import 'package:arca_tribun/features/auth/presentation/auth_provider.dart';
import 'package:arca_tribun/features/fan_profile/data/fan_profile_repository.dart';
import 'package:arca_tribun/features/fan_profile/domain/fan_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final fanProfileRepositoryProvider = Provider<FanProfileRepository>((ref) {
  return FanProfileRepository();
});

final currentUserEmailProvider = Provider<String?>((ref) {
  ref.watch(authNotifierProvider);
  return ref.watch(fanProfileRepositoryProvider).currentUserEmail;
});

/// Fan profili stream provider — Supabase Realtime.
///
/// Firebase: `FirebaseAuth.instance.currentUser?.uid` + `FirebaseFirestore...`
/// Supabase:  `supabase.auth.currentUser?.id` + `supabase.from(...).stream(...)`
///
/// RLS politikası: kullanıcı yalnızca kendi profilini okuyabilir.
/// Tablo: fan_profiles (id = auth.uid)
final fanProfileProvider = StreamProvider<FanProfileModel?>((ref) {
  ref.watch(authNotifierProvider);
  return ref.watch(fanProfileRepositoryProvider).watchCurrentProfile();
});

/// Leaderboard provider — en yüksek puanlı 50 taraftar.
///
/// Güvenlik gereği bu sprintte yalnızca kullanıcının kendi satırını döndürür.
final leaderboardProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;

  final rows = await supabase
      .from(SupabaseTables.leaderboard)
      .select('user_id, ${SupabaseTables.colDisplayName}, points, rank')
      .order('rank', ascending: true)
      .limit(50);

  return rows
      .map(
        (row) => <String, dynamic>{
          'userId': row[SupabaseTables.colUserId],
          'displayName': row[SupabaseTables.colDisplayName],
          'fanPoints': row[SupabaseTables.colPoints],
          'rank': row['rank'],
        },
      )
      .toList();
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
