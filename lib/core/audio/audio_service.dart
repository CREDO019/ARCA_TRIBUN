import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

/// Ses tipleri enum — her event için ayrı ses oynatma
enum SoundType {
  goal,
  redCard,
  finalWhistle,
  notification,
  crowdChant,
}

/// Tüm ses oynatma işlemlerini yöneten singleton servis.
/// Her SoundType için ayrı AudioPlayer instance kullanılır (overlap desteği).
class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  static final Logger _logger = Logger();

  /// Her ses tipi için ayrı player (eş zamanlı çalma desteği)
  final Map<SoundType, AudioPlayer> _players = {};

  bool _isInitialized = false;

  /// Audio session ve player'ları başlat.
  /// main.dart'tan çağrılmalı.
  Future<void> initAudio() async {
    if (_isInitialized) return;

    try {
      // Audio Session konfigürasyonu
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.mixWithOthers,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.sonification,
            usage: AndroidAudioUsage.notificationRingtone,
          ),
          androidAudioFocusGainType:
              AndroidAudioFocusGainType.gainTransientMayDuck,
        ),
      );

      // Her ses tipi için player oluştur
      for (final type in SoundType.values) {
        _players[type] = AudioPlayer();
      }

      // Ses dosyalarını önceden yükle (low latency için)
      await _preloadSounds();

      _isInitialized = true;
      _logger.i('[AudioService] Audio initialized successfully');
    } catch (e, st) {
      _logger.e('[AudioService] Failed to initialize audio',
          error: e, stackTrace: st);
    }
  }

  Future<void> _preloadSounds() async {
    final soundPaths = _getSoundPaths();
    for (final entry in soundPaths.entries) {
      try {
        await _players[entry.key]?.setAsset(entry.value);
      } catch (e) {
        _logger.w('[AudioService] Could not preload ${entry.key}: $e');
      }
    }
  }

  Map<SoundType, String> _getSoundPaths() => {
        SoundType.goal: 'assets/sounds/goal_roar.mp3',
        SoundType.redCard: 'assets/sounds/red_card_whistle.mp3',
        SoundType.finalWhistle: 'assets/sounds/final_whistle.mp3',
        SoundType.notification: 'assets/sounds/notification_chime.mp3',
        SoundType.crowdChant: 'assets/sounds/crowd_chant.mp3',
      };

  /// Belirtilen ses tipini çal.
  /// Ses dosyası yoksa sessizce devam eder.
  Future<void> playSound(SoundType type) async {
    if (!_isInitialized) {
      _logger.w('[AudioService] playSound called before initialization');
      return;
    }

    final player = _players[type];
    if (player == null) return;

    try {
      await player.seek(Duration.zero);
      await player.play();
      _logger.d('[AudioService] Playing sound: $type');
    } catch (e) {
      _logger.w('[AudioService] Failed to play $type: $e');
    }
  }

  /// Tüm oynatıcıları durdur
  Future<void> stopAll() async {
    for (final player in _players.values) {
      try {
        await player.stop();
      } catch (_) {}
    }
    _logger.d('[AudioService] All sounds stopped');
  }

  /// Belirli bir ses tipini durdur
  Future<void> stop(SoundType type) async {
    try {
      await _players[type]?.stop();
    } catch (e) {
      _logger.w('[AudioService] Failed to stop $type: $e');
    }
  }

  /// Ses seviyesini ayarla (0.0 - 1.0)
  Future<void> setVolume(SoundType type, double volume) async {
    await _players[type]?.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Tüm kaynakları serbest bırak
  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _isInitialized = false;
  }
}
