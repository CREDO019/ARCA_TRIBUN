import 'package:arca_tribun/core/audio/sound_manager.dart';
import 'package:arca_tribun/core/constants/app_constants.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';

/// Gol olayı callback tipi.
typedef GoalEventCallback = void Function(GoalEvent event);

/// Gol anında ses + titreşim + UI tetikleme motorudur.
///
/// Firebase Firestore → Supabase Realtime geçişi.
/// `matches/live/current` dökümanı yerine `live_match_state` tablosu
/// Supabase Realtime Postgres Changes ile dinlenir.
class GoalSoundEngine {
  GoalSoundEngine._();

  static final GoalSoundEngine instance = GoalSoundEngine._();

  static final Logger _logger = Logger();

  final SupabaseClient _supabase = Supabase.instance.client;
  final SoundManager _soundManager = SoundManager.instance;

  /// Aktif maç ID'si
  String? _currentMatchId;

  /// Supabase Realtime channel
  RealtimeChannel? _channel;

  /// Son bilinen skor (tekrar tetiklemeyi önlemek için)
  String? _lastScore;

  /// Gol olayı dinleyicileri (UI widget'ları bağlanır)
  final List<GoalEventCallback> _goalCallbacks = [];

  /// Belirli bir maçı Supabase Realtime ile dinlemeye başla.
  ///
  /// Supabase Realtime Postgres Changes:
  /// - Tablo: `live_match_state`
  /// - Filtre: `match_id=eq.{matchId}`
  /// - Olay: UPDATE (skor değişimi)
  void startListening(String matchId) {
    if (_currentMatchId == matchId) return;

    stopListening();
    _currentMatchId = matchId;
    _lastScore = null;

    // Önce mevcut skoru yükle (snapshot)
    _fetchInitialScore(matchId);

    // Realtime channel oluştur
    _channel = _supabase
        .channel('live_match_$matchId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'live_match_state',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'match_id',
            value: matchId,
          ),
          callback: _onLiveMatchUpdate,
        )
        .subscribe((status, [error]) {
      if (error != null) {
        _logger.e('[GoalSoundEngine] Realtime error: $error');
      } else {
        _logger.i('[GoalSoundEngine] Realtime status: $status');
      }
    });

    _logger.i('[GoalSoundEngine] Listening to match: $matchId');
  }

  /// İlk yükleme — mevcut skoru al (stream başlamadan önce)
  Future<void> _fetchInitialScore(String matchId) async {
    try {
      final data = await _supabase
          .from('live_match_state')
          .select('score, last_scorer, last_scoring_team')
          .eq('match_id', matchId)
          .maybeSingle();

      if (data != null) {
        _lastScore = data['score'] as String?;
        _logger.d('[GoalSoundEngine] Initial score: $_lastScore');
      }
    } catch (e) {
      _logger.e('[GoalSoundEngine] Initial score fetch failed: $e');
    }
  }

  /// Mevcut maç dinlemesini durdur
  void stopListening() {
    if (_channel != null) {
      _supabase.removeChannel(_channel!);
      _channel = null;
    }
    _currentMatchId = null;
    _lastScore = null;
    _logger.d('[GoalSoundEngine] Stopped listening');
  }

  /// Gol olayı callback'i kaydet (UI bileşenlerinden çağrılır)
  void addGoalCallback(GoalEventCallback callback) {
    _goalCallbacks.add(callback);
  }

  /// Callback'i kaldır (dispose'da çağrılmalı)
  void removeGoalCallback(GoalEventCallback callback) {
    _goalCallbacks.remove(callback);
  }

  /// Supabase Realtime Postgres change callback'i
  void _onLiveMatchUpdate(PostgresChangePayload payload) {
    final newRecord = payload.newRecord;

    final newScore = newRecord['score'] as String?;
    if (newScore == null) return;

    // İlk yükleme — sadece skoru kaydet, ses çalma
    if (_lastScore == null) {
      _lastScore = newScore;
      return;
    }

    // Skor değişti mi?
    if (newScore != _lastScore) {
      _lastScore = newScore;
      final scorerName = newRecord['last_scorer'] as String? ?? '';
      final teamId = newRecord['last_scoring_team'] as String? ?? '';

      _logger
          .i('[GoalSoundEngine] GOAL! Score: $newScore, Scorer: $scorerName');

      _triggerGoalSequence(
        event: GoalEvent(
          score: newScore,
          scorerName: scorerName,
          teamId: teamId,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  /// Gol sekansını tetikle: ses + titreşim + UI callback
  Future<void> _triggerGoalSequence({required GoalEvent event}) async {
    // 1. Gol sesini çal
    await _soundManager.playGoalSound();

    // 2. Titreşim başlat (eş zamanlı)
    _triggerVibration();

    // 3. UI callback'lerini tetikle
    for (final callback in _goalCallbacks) {
      callback(event);
    }

    // 4. 800ms sonra kalabalık sesi ekle
    await Future<void>.delayed(AppConstants.goalSoundDelay);
    await _soundManager.playCrowdChant();
  }

  void _triggerVibration() {
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator ?? false) {
        Vibration.vibrate(pattern: AppConstants.vibrationGoal);
      }
    });
  }

  void dispose() {
    stopListening();
    _goalCallbacks.clear();
  }
}

/// Gol olayını temsil eden model
class GoalEvent {
  const GoalEvent({
    required this.score,
    required this.scorerName,
    required this.teamId,
    required this.timestamp,
  });

  final String score;
  final String scorerName;
  final String teamId;
  final DateTime timestamp;
}
