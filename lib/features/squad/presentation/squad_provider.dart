import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/squad_repository.dart';
import '../domain/player_model.dart';

final squadRepositoryProvider = Provider<SquadRepository>(
  (ref) => SquadRepository(),
);

final activeSquadProvider = FutureProvider<List<PlayerModel>>((ref) async {
  final repository = ref.watch(squadRepositoryProvider);
  return repository.fetchActivePlayers();
});

final groupedSquadProvider =
    FutureProvider<Map<String, List<PlayerModel>>>((ref) async {
  final repository = ref.watch(squadRepositoryProvider);
  return repository.fetchGroupedActivePlayers();
});

final playerDetailProvider =
    FutureProvider.family<PlayerModel?, String>((ref, playerId) async {
  final repository = ref.watch(squadRepositoryProvider);
  return repository.fetchPlayerDetail(playerId);
});
