import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/standings_repository.dart';
import '../domain/standing_model.dart';

final standingsRepositoryProvider = Provider<StandingsRepository>(
  (ref) => StandingsRepository(),
);

final seasonStandingsProvider = FutureProvider<List<StandingModel>>((ref) async {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.fetchSeasonStandings();
});
