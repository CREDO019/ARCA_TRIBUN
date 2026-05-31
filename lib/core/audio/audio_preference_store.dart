import 'package:arca_tribun/core/constants/app_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

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
  bool get isMuted => _read(_keyMuted, fallback: false);
  double get volume => _read<num>(_keyVolume, fallback: 1).toDouble();
  bool get isGoalSoundEnabled => _read(_keyGoalSound, fallback: true);
  bool get isCrowdSoundEnabled => _read(_keyCrowdSound, fallback: true);
  bool get isMatchSoundEnabled => _read(_keyMatchSound, fallback: true);
  bool get isNotificationSoundEnabled =>
      _read(_keyNotificationSound, fallback: true);

  // ─── Setters ───────────────────────────────────────────────────────────
  Future<void> setMuted({required bool value}) async {
    await _write(_keyMuted, value);
  }

  Future<void> setVolume(double value) async {
    await _write(_keyVolume, value);
  }

  Future<void> setGoalSoundEnabled({required bool value}) async {
    await _write(_keyGoalSound, value);
  }

  Future<void> setCrowdSoundEnabled({required bool value}) async {
    await _write(_keyCrowdSound, value);
  }

  Future<void> setMatchSoundEnabled({required bool value}) async {
    await _write(_keyMatchSound, value);
  }

  Future<void> setNotificationSoundEnabled({required bool value}) async {
    await _write(_keyNotificationSound, value);
  }

  /// Tüm ses tercihlerini varsayılana sıfırla
  Future<void> resetToDefaults() async {
    if (!_isInitialized) return;

    try {
      await _box.putAll({
        _keyMuted: false,
        _keyVolume: 1.0,
        _keyGoalSound: true,
        _keyCrowdSound: true,
        _keyMatchSound: true,
        _keyNotificationSound: true,
      });
    } catch (e) {
      _logger.w('[AudioPreferenceStore] Failed to reset preferences: $e');
    }
  }

  T _read<T>(String key, {required T fallback}) {
    if (!_isInitialized) return fallback;

    try {
      return _box.get(key, defaultValue: fallback) as T;
    } catch (e) {
      _logger.w('[AudioPreferenceStore] Failed to read $key: $e');
      return fallback;
    }
  }

  Future<void> _write(String key, Object value) async {
    if (!_isInitialized) return;

    try {
      await _box.put(key, value);
    } catch (e) {
      _logger.w('[AudioPreferenceStore] Failed to write $key: $e');
    }
  }
}
