import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';

/// Bildirim tercihleri modeli
class NotificationPrefs {
  const NotificationPrefs({
    this.goalAlerts = true,
    this.matchAlerts = true,
    this.newsAlerts = true,
    this.matchStartAlerts = true,
  });

  final bool goalAlerts;
  final bool matchAlerts;
  final bool newsAlerts;
  final bool matchStartAlerts;

  NotificationPrefs copyWith({
    bool? goalAlerts,
    bool? matchAlerts,
    bool? newsAlerts,
    bool? matchStartAlerts,
  }) =>
      NotificationPrefs(
        goalAlerts: goalAlerts ?? this.goalAlerts,
        matchAlerts: matchAlerts ?? this.matchAlerts,
        newsAlerts: newsAlerts ?? this.newsAlerts,
        matchStartAlerts: matchStartAlerts ?? this.matchStartAlerts,
      );
}

/// Bildirim tercihleri notifier — Hive'a persistently kayıt
class NotificationPrefsNotifier extends Notifier<NotificationPrefs> {
  static const String _keyGoal = 'notif_goal';
  static const String _keyMatch = 'notif_match';
  static const String _keyNews = 'notif_news';
  static const String _keyMatchStart = 'notif_match_start';

  Box<dynamic> get _box => Hive.box<dynamic>(AppConstants.hiveBoxSettings);

  @override
  NotificationPrefs build() => NotificationPrefs(
        goalAlerts: _box.get(_keyGoal, defaultValue: true) as bool,
        matchAlerts: _box.get(_keyMatch, defaultValue: true) as bool,
        newsAlerts: _box.get(_keyNews, defaultValue: true) as bool,
        matchStartAlerts: _box.get(_keyMatchStart, defaultValue: true) as bool,
      );

  Future<void> setGoalAlerts(bool value) async {
    await _box.put(_keyGoal, value);
    state = state.copyWith(goalAlerts: value);
  }

  Future<void> setMatchAlerts(bool value) async {
    await _box.put(_keyMatch, value);
    state = state.copyWith(matchAlerts: value);
  }

  Future<void> setNewsAlerts(bool value) async {
    await _box.put(_keyNews, value);
    state = state.copyWith(newsAlerts: value);
  }

  Future<void> setMatchStartAlerts(bool value) async {
    await _box.put(_keyMatchStart, value);
    state = state.copyWith(matchStartAlerts: value);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(
  NotificationPrefsNotifier.new,
);
