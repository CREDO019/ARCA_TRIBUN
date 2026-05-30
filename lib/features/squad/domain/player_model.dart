import 'package:equatable/equatable.dart';

/// Oyuncu domain modeli
class PlayerModel extends Equatable {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.position,
    required this.number,
    this.photoUrl,
    this.nationality,
    this.age,
    this.goals = 0,
    this.assists = 0,
    this.appearances = 0,
    this.bio,
  });

  factory PlayerModel.fromFirestore(String id, Map<String, dynamic> data) =>
      PlayerModel(
        id: id,
        name: data['name'] as String? ?? '',
        position: data['position'] as String? ?? '',
        number: (data['number'] as num?)?.toInt() ?? 0,
        photoUrl: data['photoUrl'] as String?,
        nationality: data['nationality'] as String?,
        age: (data['age'] as num?)?.toInt(),
        goals: (data['goals'] as num?)?.toInt() ?? 0,
        assists: (data['assists'] as num?)?.toInt() ?? 0,
        appearances: (data['appearances'] as num?)?.toInt() ?? 0,
        bio: data['bio'] as String?,
      );

  final String id;
  final String name;
  final String position;
  final int number;
  final String? photoUrl;
  final String? nationality;
  final int? age;
  final int goals;
  final int assists;
  final int appearances;
  final String? bio;

  @override
  List<Object?> get props => [id, name, number];
}
