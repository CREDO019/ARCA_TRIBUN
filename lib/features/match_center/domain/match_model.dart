import 'package:equatable/equatable.dart';

/// Maç durumu enum
enum MatchStatus { scheduled, preGame, live, halfTime, postMatch, cancelled }

/// Maç domain modeli
class MatchModel extends Equatable {
  const MatchModel({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.kickoffTime,
    required this.status,
    this.homeScore,
    this.awayScore,
    this.venue,
    this.competition,
  });

  factory MatchModel.fromSupabase(Map<String, dynamic> data) => MatchModel(
        id: data['id'] as String,
        homeTeam: data['home_team'] as String? ?? '',
        awayTeam: data['away_team'] as String? ?? '',
        kickoffTime: _dateTimeFromSupabase(data['match_date']),
        status: matchStatusFromSupabase(data['status'] as String?),
        homeScore: (data['home_score'] as num?)?.toInt(),
        awayScore: (data['away_score'] as num?)?.toInt(),
        venue: data['stadium'] as String?,
        competition: data['competition'] as String?,
      );

  final String id;
  final String homeTeam;
  final String awayTeam;
  final DateTime kickoffTime;
  final MatchStatus status;
  final int? homeScore;
  final int? awayScore;
  final String? venue;
  final String? competition;

  bool get isLive =>
      status == MatchStatus.live || status == MatchStatus.halfTime;

  String get scoreDisplay => '${homeScore ?? 0} - ${awayScore ?? 0}';

  @override
  List<Object?> get props =>
      [id, homeTeam, awayTeam, kickoffTime, status, homeScore, awayScore];
}

/// Canlı maç durumu
class LiveMatchModel extends Equatable {
  const LiveMatchModel({
    required this.matchId,
    required this.minute,
    required this.homeScore,
    required this.awayScore,
    this.lastScorer,
    this.lastScoringTeam,
    this.homePossession = 50,
    this.awayPossession = 50,
    this.homeShots = 0,
    this.awayShots = 0,
    this.homeCorners = 0,
    this.awayCorners = 0,
  });

  factory LiveMatchModel.fromFirestore(Map<String, dynamic> data) =>
      LiveMatchModel(
        matchId: data['matchId'] as String? ?? '',
        minute: data['minute'] as int? ?? 0,
        homeScore: data['homeScore'] as int? ?? 0,
        awayScore: data['awayScore'] as int? ?? 0,
        lastScorer: data['lastScorer'] as String?,
        lastScoringTeam: data['lastScoringTeam'] as String?,
        homePossession: (data['homePossession'] as num?)?.toInt() ?? 50,
        awayPossession: (data['awayPossession'] as num?)?.toInt() ?? 50,
        homeShots: (data['homeShots'] as num?)?.toInt() ?? 0,
        awayShots: (data['awayShots'] as num?)?.toInt() ?? 0,
        homeCorners: (data['homeCorners'] as num?)?.toInt() ?? 0,
        awayCorners: (data['awayCorners'] as num?)?.toInt() ?? 0,
      );

  factory LiveMatchModel.fromSupabase(Map<String, dynamic> data) =>
      LiveMatchModel(
        matchId: data['match_id'] as String? ?? data['id'] as String? ?? '',
        minute: (data['minute'] as num?)?.toInt() ?? 0,
        homeScore: (data['home_score'] as num?)?.toInt() ?? 0,
        awayScore: (data['away_score'] as num?)?.toInt() ?? 0,
        lastScorer: data['last_scorer'] as String?,
        lastScoringTeam: data['last_scoring_team'] as String?,
        homePossession: (data['home_possession'] as num?)?.toInt() ?? 50,
        awayPossession: (data['away_possession'] as num?)?.toInt() ?? 50,
        homeShots: (data['home_shots'] as num?)?.toInt() ?? 0,
        awayShots: (data['away_shots'] as num?)?.toInt() ?? 0,
        homeCorners: (data['home_corners'] as num?)?.toInt() ?? 0,
        awayCorners: (data['away_corners'] as num?)?.toInt() ?? 0,
      );

  final String matchId;
  final int minute;
  final int homeScore;
  final int awayScore;
  final String? lastScorer;
  final String? lastScoringTeam;
  final int homePossession;
  final int awayPossession;
  final int homeShots;
  final int awayShots;
  final int homeCorners;
  final int awayCorners;

  String get score => '$homeScore - $awayScore';

  @override
  List<Object?> get props => [matchId, minute, homeScore, awayScore];
}

/// Maç olayı (gol, kart, değişiklik)
class MatchEventModel extends Equatable {
  const MatchEventModel({
    required this.id,
    required this.type,
    required this.minute,
    required this.playerName,
    this.teamId,
    this.assistPlayerName,
    this.detail,
  });

  factory MatchEventModel.fromFirestore(String id, Map<String, dynamic> data) =>
      MatchEventModel(
        id: id,
        type: MatchEventType.values.firstWhere(
          (e) => e.name == data['type'],
          orElse: () => MatchEventType.other,
        ),
        minute: data['minute'] as int? ?? 0,
        playerName: data['playerName'] as String? ?? '',
        teamId: data['teamId'] as String?,
        assistPlayerName: data['assistPlayerName'] as String?,
        detail: data['detail'] as String?,
      );

  factory MatchEventModel.fromSupabase(Map<String, dynamic> data) =>
      MatchEventModel(
        id: data['id'] as String,
        type: _matchEventTypeFromSupabase(
          data['event_type'] as String? ?? data['type'] as String?,
        ),
        minute: (data['minute'] as num?)?.toInt() ?? 0,
        playerName: data['player_name'] as String? ?? '',
        teamId: data['team'] as String? ?? data['team_id'] as String?,
        assistPlayerName: data['assist_player_name'] as String?,
        detail: data['description'] as String? ?? data['detail'] as String?,
      );

  final String id;
  final MatchEventType type;
  final int minute;
  final String playerName;
  final String? teamId;
  final String? assistPlayerName;
  final String? detail;

  @override
  List<Object?> get props => [id, type, minute, playerName];
}

enum MatchEventType {
  goal,
  ownGoal,
  yellowCard,
  redCard,
  substitution,
  penaltyGoal,
  kickoff,
  fullTime,
  other
}

MatchStatus matchStatusFromSupabase(String? value) {
  switch (value) {
    case 'live':
      return MatchStatus.live;
    case 'finished':
      return MatchStatus.postMatch;
    case 'cancelled':
      return MatchStatus.cancelled;
    case 'scheduled':
    case 'postponed':
    default:
      return MatchStatus.scheduled;
  }
}

MatchEventType _matchEventTypeFromSupabase(String? value) {
  switch (value) {
    case 'goal':
      return MatchEventType.goal;
    case 'own_goal':
      return MatchEventType.ownGoal;
    case 'yellow_card':
      return MatchEventType.yellowCard;
    case 'red_card':
      return MatchEventType.redCard;
    case 'substitution':
      return MatchEventType.substitution;
    case 'penalty_goal':
      return MatchEventType.penaltyGoal;
    case 'kickoff':
      return MatchEventType.kickoff;
    case 'fulltime':
      return MatchEventType.fullTime;
    default:
      return MatchEventType.other;
  }
}

DateTime _dateTimeFromSupabase(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}
