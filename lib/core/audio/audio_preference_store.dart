import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import '../constants/app_constants.dart';

/// Kullanıcının ses tercihlerini Hive ile yerel depolamada saklar.
class AudioPreferenceStore {
  AudioPreferenceStore._();

  static final AudioPreferenceStore instance = AudioPreferenceStore._();

  static final Logger _logger = Logger();

  late Box<dynamic> _box;
  bool _isInitialized = false;

  // ─── Keys ──────────────────────────────────────────────────────────────
  static const String _keyMuted = 'audio_muted';
  static const String _keyVolume = 'audio_volume';
  static const String _keyGoalSound = 'audio_goal_sound';
  static const String _keyCrowdSound = 'audio_crowd_sound';
  static const String _keyMatchSound = 'audio_match_sound';
  static const String _keyNotificationSound = 'audio_notification_sound';

  /// Hive box'ı aç ve değerleri yükle
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _box = await Hive.openBox<dynamic>(AppConstants.hiveBoxSettings);
      _isInitialized = true;
      _logger.d('[AudioPreferenceStore] Initialized');
    } catch (e) {
      _logger.e('[AudioPreferenceStore] Failed to initialize: $e');
    }
  }

  // ─── Getters ───────────────────────────────────────────────────────────
  bool get isMuted => _box.get(_keyMuted, defaultValue: false) as bool;
  double get volume =>
      (_box.get(_keyVolume, defaultValue: 1.0) as num).toDouble();
  bool get isGoalSoundEnabled =>
      _box.get(_keyGoalSound, defaultValue: true) as bool;
  bool get isCrowdSoundEnabled =>
      _box.get(_keyCrowdSound, defaultValue: true) as bool;
  bool get isMatchSoundEnabled =>
      _box.get(_keyMatchSound, defaultValue: true) as bool;
  bool get isNotificationSoundEnabled =>
      _box.get(_keyNotificationSound, defaultValue: true) as bool;

  // ─── Setters ───────────────────────────────────────────────────────────
  Future<void> setMuted({required bool value}) async {
    await _box.put(_keyMuted, value);
  }

  Future<void> setVolume(double value) async {
    await _box.put(_keyVolume, value);
  }

  Future<void> setGoalSoundEnabled({required bool value}) async {
    await _box.put(_keyGoalSound, value);
  }

  Future<void> setCrowdSoundEnabled({required bool value}) async {
    await _box.put(_keyCrowdSound, value);
  }

  Future<void> setMatchSoundEnabled({required bool value}) async {
    await _box.put(_keyMatchSound, value);
  }

  Future<void> setNotificationSoundEnabled({required bool value}) async {
    await _box.put(_keyNotificationSound, value);
  }

  /// Tüm ses tercihlerini varsayılana sıfırla
  Future<void> resetToDefaults() async {
    await _box.putAll({
      _keyMuted: false,
      _keyVolume: 1.0,
      _keyGoalSound: true,
      _keyCrowdSound: true,
      _keyMatchSound: true,
      _keyNotificationSound: true,
    });
  }
}
