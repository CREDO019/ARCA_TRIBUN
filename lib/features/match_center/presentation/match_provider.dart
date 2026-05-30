import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/match_repository.dart';
import '../domain/match_model.dart';

final matchRepositoryProvider = Provider<MatchRepository>(
  (ref) => MatchRepository(),
);

final upcomingMatchesProvider = FutureProvider<List<MatchModel>>((ref) async {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.fetchUpcomingMatches(limit: 20);
});

final recentMatchesProvider = FutureProvider<List<MatchModel>>((ref) async {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.fetchRecentMatches(limit: 20);
});

final currentLiveMatchProvider = FutureProvider<MatchModel?>((ref) async {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.fetchCurrentLiveMatch();
});

final matchDetailProvider =
    FutureProvider.family<MatchModel?, String>((ref, matchId) async {
  final repository = ref.watch(matchRepositoryProvider);
  return repository.fetchMatchDetail(matchId);
});

// ─── Live Match Stream Provider ───────────────────────────────────────────
/// Canlı maç verisi — Supabase Realtime stream (Postgres Changes).
///
/// Firebase: `FirebaseFirestore.instance.doc(path).snapshots()`
/// Supabase:  `supabase.from('matches').stream(primaryKey: ['id']).eq('id', id)`
final liveMatchProvider = StreamProvider.family<LiveMatchModel?, String>(
  (ref, matchId) {
    final repository = ref.watch(matchRepositoryProvider);
    return repository.watchLiveMatch(matchId);
  },
);

// ─── Match Events Stream Provider ────────────────────────────────────────
/// Maç olayları stream'i (goller, kartlar vb.) — Supabase Realtime.
///
/// Dakika sırasına göre sıralı stream.
final matchEventsProvider =
    StreamProvider.family<List<MatchEventModel>, String>(
  (ref, matchId) {
    final repository = ref.watch(matchRepositoryProvider);
    return repository.watchMatchEvents(matchId);
  },
);

// ─── Match Status Provider ────────────────────────────────────────────────
/// Maç durumu (scheduled, live, postMatch vb.) — Supabase Realtime.
final matchStatusProvider = StreamProvider.family<MatchStatus, String>(
  (ref, matchId) {
    final repository = ref.watch(matchRepositoryProvider);
    return repository.watchMatchStatus(matchId);
  },
);
