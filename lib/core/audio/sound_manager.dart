import 'package:logger/logger.dart';

import 'audio_preference_store.dart';
import 'audio_service.dart';

/// Ses yönetim katmanı — kullanıcı tercihlerini dikkate alarak ses çalar.
/// AudioService üzerinde soyutlama sağlar.
class SoundManager {
  SoundManager._();

  static final SoundManager instance = SoundManager._();

  static final Logger _logger = Logger();

  final AudioService _audioService = AudioService.instance;
  final AudioPreferenceStore _preferenceStore = AudioPreferenceStore.instance;

  bool _isMuted = false;
  double _volume = 1.0;

  /// SoundManager'ı başlat (preferences yükle)
  Future<void> initialize() async {
    await _preferenceStore.initialize();
    _isMuted = _preferenceStore.isMuted;
    _volume = _preferenceStore.volume;
    _logger.i('[SoundManager] Initialized. Muted: $_isMuted, Volume: $_volume');
  }

  /// Sessiz mod
  bool get isMuted => _isMuted;

  /// Ses seviyesi
  double get volume => _volume;

  /// Gol sesi çal (tercih kontrolü ile)
  Future<void> playGoalSound() async {
    if (_isMuted || !_preferenceStore.isGoalSoundEnabled) return;
    await _audioService.playSound(SoundType.goal);
  }

  /// Kalabalık sesi çal
  Future<void> playCrowdChant() async {
    if (_isMuted || !_preferenceStore.isCrowdSoundEnabled) return;
    await _audioService.playSound(SoundType.crowdChant);
  }

  /// Kırmızı kart sesi
  Future<void> playRedCardSound() async {
    if (_isMuted || !_preferenceStore.isMatchSoundEnabled) return;
    await _audioService.playSound(SoundType.redCard);
  }

  /// Final düdüğü
  Future<void> playFinalWhistle() async {
    if (_isMuted || !_preferenceStore.isMatchSoundEnabled) return;
    await _audioService.playSound(SoundType.finalWhistle);
  }

  /// Bildirim sesi
  Future<void> playNotificationSound() async {
    if (_isMuted || !_preferenceStore.isNotificationSoundEnabled) return;
    await _audioService.playSound(SoundType.notification);
  }

  /// Sessiz modu aç/kapat
  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _preferenceStore.setMuted(value: _isMuted);

    if (_isMuted) {
      await _audioService.stopAll();
    }

    _logger.d('[SoundManager] Muted: $_isMuted');
  }

  /// Ses seviyesini ayarla
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _preferenceStore.setVolume(_volume);

    for (final type in SoundType.values) {
      await _audioService.setVolume(type, _volume);
    }
  }

  /// Tüm sesleri durdur
  Future<void> stopAll() => _audioService.stopAll();
}
