import 'package:equatable/equatable.dart';

/// Fan profili domain modeli
class FanProfileModel extends Equatable {
  const FanProfileModel({
    required this.uid,
    required this.displayName,
    required this.fanPoints,
    required this.fanLevel,
    required this.fanLevelTitle,
    required this.currentStreak,
    required this.longestStreak,
    required this.earnedBadgeIds,
    required this.totalPredictions,
    required this.correctPredictions,
    required this.lastCheckIn,
    required this.preferredLocale,
  });

  factory FanProfileModel.fromFirestore(Map<String, dynamic> data) =>
      FanProfileModel(
        uid: data['uid'] as String? ?? '',
        displayName: data['displayName'] as String? ?? '',
        fanPoints: (data['fanPoints'] as num?)?.toInt() ?? 0,
        fanLevel: (data['fanLevel'] as num?)?.toInt() ?? 1,
        fanLevelTitle: data['fanLevelTitle'] as String? ?? 'Bronz',
        currentStreak: (data['currentStreak'] as num?)?.toInt() ?? 0,
        longestStreak: (data['longestStreak'] as num?)?.toInt() ?? 0,
        earnedBadgeIds:
            List<String>.from(data['earnedBadgeIds'] as List? ?? []),
        totalPredictions: (data['totalPredictions'] as num?)?.toInt() ?? 0,
        correctPredictions: (data['correctPredictions'] as num?)?.toInt() ?? 0,
        lastCheckIn: (data['lastCheckIn'] as dynamic)?.toDate() as DateTime? ??
            DateTime(2000),
        preferredLocale: data['preferredLocale'] as String? ?? 'tr',
      );

  factory FanProfileModel.fromSupabase(Map<String, dynamic> data) =>
      FanProfileModel(
        uid: data['id'] as String? ?? '',
        displayName: data['display_name'] as String? ?? '',
        fanPoints: (data['points'] as num?)?.toInt() ?? 0,
        fanLevel: (data['level'] as num?)?.toInt() ?? 1,
        fanLevelTitle: _fanLevelTitle((data['level'] as num?)?.toInt() ?? 1),
        currentStreak: 0,
        longestStreak: 0,
        earnedBadgeIds: List<String>.from(
          data['earned_badge_ids'] as List? ?? const [],
        ),
        totalPredictions: 0,
        correctPredictions: 0,
        lastCheckIn: DateTime(2000),
        preferredLocale: 'tr',
      );

  final String uid;
  final String displayName;
  final int fanPoints;
  final int fanLevel;
  final String fanLevelTitle;
  final int currentStreak;
  final int longestStreak;
  final List<String> earnedBadgeIds;
  final int totalPredictions;
  final int correctPredictions;
  final DateTime lastCheckIn;
  final String preferredLocale;

  /// Tahmin başarı oranı
  double get predictionAccuracy =>
      totalPredictions == 0 ? 0 : correctPredictions / totalPredictions;

  /// Bugün check-in yapıldı mı?
  bool get hasCheckedInToday {
    final now = DateTime.now();
    return lastCheckIn.year == now.year &&
        lastCheckIn.month == now.month &&
        lastCheckIn.day == now.day;
  }

  @override
  List<Object?> get props => [
        uid,
        displayName,
        fanPoints,
        fanLevel,
        currentStreak,
      ];
}

String _fanLevelTitle(int level) {
  if (level >= 4) return 'Elmas';
  if (level == 3) return 'Altın';
  if (level == 2) return 'Gümüş';
  return 'Bronz';
}

/// Rozet model
class BadgeModel extends Equatable {
  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.tier,
    required this.iconName,
    this.earnedAt,
  });

  final String id;
  final String name;
  final String description;
  final int tier; // 1: Bronz, 2: Gümüş, 3: Altın
  final String iconName;
  final DateTime? earnedAt;

  bool get isEarned => earnedAt != null;

  @override
  List<Object?> get props => [id];
}
