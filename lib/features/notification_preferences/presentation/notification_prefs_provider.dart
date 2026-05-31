import 'package:arca_tribun/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Box<dynamic>? get _box => Hive.isBoxOpen(AppConstants.hiveBoxSettings)
      ? Hive.box<dynamic>(AppConstants.hiveBoxSettings)
      : null;

  @override
  NotificationPrefs build() => NotificationPrefs(
        goalAlerts: _read(_keyGoal),
        matchAlerts: _read(_keyMatch),
        newsAlerts: _read(_keyNews),
        matchStartAlerts: _read(_keyMatchStart),
      );

  Future<void> setGoalAlerts(bool value) async {
    await _write(_keyGoal, value);
    state = state.copyWith(goalAlerts: value);
  }

  Future<void> setMatchAlerts(bool value) async {
    await _write(_keyMatch, value);
    state = state.copyWith(matchAlerts: value);
  }

  Future<void> setNewsAlerts(bool value) async {
    await _write(_keyNews, value);
    state = state.copyWith(newsAlerts: value);
  }

  Future<void> setMatchStartAlerts(bool value) async {
    await _write(_keyMatchStart, value);
    state = state.copyWith(matchStartAlerts: value);
  }

  bool _read(String key) => _box?.get(key, defaultValue: true) as bool? ?? true;

  Future<void> _write(String key, bool value) async {
    final box = _box ??
        await Hive.openBox<dynamic>(
          AppConstants.hiveBoxSettings,
        );
    await box.put(key, value);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(
  NotificationPrefsNotifier.new,
);
