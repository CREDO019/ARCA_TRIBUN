import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/match_model.dart';
import '../../../core/constants/supabase_tables.dart';

// ─── Live Match Stream Provider ───────────────────────────────────────────
/// Canlı maç verisi — Supabase Realtime stream (Postgres Changes).
///
/// Firebase: `FirebaseFirestore.instance.doc(path).snapshots()`
/// Supabase:  `supabase.from(table).stream(primaryKey: ['id']).eq('match_id', id)`
final liveMatchProvider = StreamProvider.family<LiveMatchModel?, String>(
  (ref, matchId) {
    final supabase = Supabase.instance.client;

    return supabase
        .from(SupabaseTables.liveMatchState)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colMatchId, matchId)
        .map((rows) {
          if (rows.isEmpty) return null;
          return LiveMatchModel.fromSupabase(rows.first);
        });
  },
);

// ─── Match Events Stream Provider ────────────────────────────────────────
/// Maç olayları stream'i (goller, kartlar vb.) — Supabase Realtime.
///
/// Dakika sırasına göre sıralı stream.
final matchEventsProvider =
    StreamProvider.family<List<MatchEventModel>, String>(
  (ref, matchId) {
    final supabase = Supabase.instance.client;

    return supabase
        .from(SupabaseTables.matchEvents)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colMatchId, matchId)
        .order(SupabaseTables.colMinute)
        .map((rows) =>
            rows.map((row) => MatchEventModel.fromSupabase(row)).toList());
  },
);

// ─── Match Status Provider ────────────────────────────────────────────────
/// Maç durumu (scheduled, live, postMatch vb.) — Supabase Realtime.
final matchStatusProvider = StreamProvider.family<MatchStatus, String>(
  (ref, matchId) {
    final supabase = Supabase.instance.client;

    return supabase
        .from(SupabaseTables.matches)
        .stream(primaryKey: [SupabaseTables.colId])
        .eq(SupabaseTables.colId, matchId)
        .map((rows) {
          if (rows.isEmpty) return MatchStatus.scheduled;
          final statusStr = rows.first[SupabaseTables.colStatus] as String?;
          return MatchStatus.values.firstWhere(
            (e) => e.name == statusStr,
            orElse: () => MatchStatus.scheduled,
          );
        });
  },
);
