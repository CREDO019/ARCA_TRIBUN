import 'package:equatable/equatable.dart';

class StandingModel extends Equatable {
  const StandingModel({
    required this.id,
    required this.season,
    required this.teamName,
    required this.position,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
  });

  factory StandingModel.fromSupabase(Map<String, dynamic> data) {
    return StandingModel(
      id: data['id'] as String,
      season: data['season'] as String? ?? '',
      teamName: data['team_name'] as String? ?? '',
      position: (data['position'] as num?)?.toInt() ?? 0,
      played: (data['played'] as num?)?.toInt() ?? 0,
      won: (data['won'] as num?)?.toInt() ?? 0,
      drawn: (data['drawn'] as num?)?.toInt() ?? 0,
      lost: (data['lost'] as num?)?.toInt() ?? 0,
      goalsFor: (data['goals_for'] as num?)?.toInt() ?? 0,
      goalsAgainst: (data['goals_against'] as num?)?.toInt() ?? 0,
      goalDifference: (data['goal_difference'] as num?)?.toInt() ?? 0,
      points: (data['points'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String season;
  final String teamName;
  final int position;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;

  @override
  List<Object?> get props => [id, season, teamName, position, points];
}
