import 'package:arca_tribun/core/audio/audio_preference_store.dart';
import 'package:arca_tribun/core/audio/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('audio preferences use safe defaults before Hive initialization', () {
    final store = AudioPreferenceStore.instance;

    expect(store.isMuted, isFalse);
    expect(store.volume, 1);
    expect(store.isGoalSoundEnabled, isTrue);
    expect(store.isCrowdSoundEnabled, isTrue);
    expect(store.isMatchSoundEnabled, isTrue);
    expect(store.isNotificationSoundEnabled, isTrue);
  });

  test('audio writes are no-op before Hive initialization', () async {
    final store = AudioPreferenceStore.instance;

    await expectLater(store.setMuted(value: true), completes);
    await expectLater(store.setVolume(0.5), completes);
    await expectLater(store.resetToDefaults(), completes);
  });

  test('audio playback is no-op before service initialization', () async {
    await expectLater(
      AudioService.instance.playSound(SoundType.goal),
      completes,
    );
  });
}
