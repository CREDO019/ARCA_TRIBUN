import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_tables.dart';
import '../domain/standing_model.dart';

class StandingsRepository {
  StandingsRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<StandingModel>> fetchSeasonStandings({String? season}) async {
    final targetSeason = season ?? await _fetchLatestSeason();
    if (targetSeason == null) return const <StandingModel>[];

    final rows = await _client
        .from(SupabaseTables.standings)
        .select()
        .eq('season', targetSeason)
        .order('position', ascending: true);

    return rows.map((row) => StandingModel.fromSupabase(row)).toList();
  }

  Future<String?> _fetchLatestSeason() async {
    final row = await _client
        .from(SupabaseTables.standings)
        .select('season')
        .order('season', ascending: false)
        .limit(1)
        .maybeSingle();
    return row?['season'] as String?;
  }
}
