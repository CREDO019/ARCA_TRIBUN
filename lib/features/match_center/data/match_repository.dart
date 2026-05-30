import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/supabase_tables.dart';
import '../domain/match_model.dart';

class MatchRepository {
  MatchRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<MatchModel>> fetchUpcomingMatches({int limit = 20}) async {
    final rows = await _client
        .from(SupabaseTables.matches)
        .select()
        .gte('match_date', DateTime.now().toIso8601String())
        .or('status.eq.scheduled,status.eq.postponed')
        .order('match_date', ascending: true)
        .limit(limit);

    return rows.map((row) => MatchModel.fromSupabase(row)).toList();
  }

  Future<List<MatchModel>> fetchRecentMatches({int limit = 20}) async {
    final rows = await _client
        .from(SupabaseTables.matches)
        .select()
        .lte('match_date', DateTime.now().toIso8601String())
        .or('status.eq.finished,status.eq.cancelled,status.eq.live')
        .order('match_date', ascending: false)
        .limit(limit);

    return rows.map((row) => MatchModel.fromSupabase(row)).toList();
  }

  Future<MatchModel?> fetchCurrentLiveMatch() async {
    final row = await _client
        .from(SupabaseTables.matches)
        .select()
        .eq(SupabaseTables.colStatus, 'live')
        .order('match_date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (row == null) return null;
    return MatchModel.fromSupabase(row);
  }

  Future<MatchModel?> fetchMatchDetail(String matchId) async {
    final row = await _client
        .from(SupabaseTables.matches)
        .select()
        .eq(SupabaseTables.colId, matchId)
        .maybeSingle();

    if (row == null) return null;
    return MatchModel.fromSupabase(row);
  }

  Future<List<MatchEventModel>> fetchMatchEvents(String matchId) async {
    final rows = await _client
        .from(SupabaseTables.matchEvents)
        .select()
        .eq(SupabaseTables.colMatchId, matchId)
        .order(SupabaseTables.colMinute, ascending: true);

    return rows.map((row) => MatchEventModel.fromSupabase(row)).toList();
  }

  Stream<LiveMatchModel?> watchLiveMatch(String matchId) {
    return _client
        .from(SupabaseTables.liveMatchState)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colMatchId, matchId)
        .map((rows) {
          if (rows.isEmpty) return null;
          return LiveMatchModel.fromSupabase(rows.first);
        });
  }

  Stream<List<MatchEventModel>> watchMatchEvents(String matchId) {
    return _client
        .from(SupabaseTables.matchEvents)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colMatchId, matchId)
        .order(SupabaseTables.colMinute)
        .map((rows) =>
            rows.map((row) => MatchEventModel.fromSupabase(row)).toList());
  }

  Stream<MatchStatus> watchMatchStatus(String matchId) {
    return _client
        .from(SupabaseTables.matches)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colId, matchId)
        .map((rows) {
          if (rows.isEmpty) return MatchStatus.scheduled;
          final statusStr = rows.first[SupabaseTables.colStatus] as String?;
          return matchStatusFromSupabase(statusStr);
        });
  }
}
