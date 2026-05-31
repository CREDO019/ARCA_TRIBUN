import 'package:arca_tribun/features/standings/data/standings_repository.dart';
import 'package:arca_tribun/features/standings/domain/standing_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final standingsRepositoryProvider = Provider<StandingsRepository>(
  (ref) => StandingsRepository(),
);

final seasonStandingsProvider =
    FutureProvider<List<StandingModel>>((ref) async {
  final repository = ref.watch(standingsRepositoryProvider);
  return repository.fetchSeasonStandings();
});
