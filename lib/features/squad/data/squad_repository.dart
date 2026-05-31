import 'package:arca_tribun/core/constants/supabase_tables.dart';
import 'package:arca_tribun/features/squad/domain/player_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SquadRepository {
  SquadRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<PlayerModel>> fetchActivePlayers() async {
    final rows = await _client
        .from(SupabaseTables.squad)
        .select()
        .eq(SupabaseTables.colStatus, 'active')
        .order('position', ascending: true)
        .order('number', ascending: true);

    return rows.map(PlayerModel.fromSupabase).toList();
  }

  Future<Map<String, List<PlayerModel>>> fetchGroupedActivePlayers() async {
    final players = await fetchActivePlayers();
    final grouped = <String, List<PlayerModel>>{};

    for (final player in players) {
      final group = _positionGroupName(player.position);
      grouped.putIfAbsent(group, () => <PlayerModel>[]).add(player);
    }

    return grouped;
  }

  Future<PlayerModel?> fetchPlayerDetail(String playerId) async {
    final row = await _client
        .from(SupabaseTables.squad)
        .select()
        .eq(SupabaseTables.colId, playerId)
        .maybeSingle();

    if (row == null) return null;
    return PlayerModel.fromSupabase(row);
  }

  String _positionGroupName(String rawPosition) {
    switch (rawPosition.toLowerCase()) {
      case 'goalkeeper':
      case 'kaleci':
        return 'Kaleciler';
      case 'defender':
      case 'defans':
        return 'Defans';
      case 'midfielder':
      case 'orta saha':
      case 'ortasaha':
        return 'Orta Saha';
      case 'forward':
      case 'forvet':
        return 'Forvet';
      default:
        return 'Diğer';
    }
  }
}
