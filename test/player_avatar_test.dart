import 'package:arca_tribun/features/squad/domain/player_model.dart';
import 'package:arca_tribun/shared/widgets/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('player avatar uses premium placeholder without local photo', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayerAvatar(
          player: PlayerModel(
            id: 'serdar',
            name: 'Serdar Gürler',
            position: 'forward',
            number: 7,
            photoUrl: 'https://example.com/serdar.jpg',
          ),
        ),
      ),
    );

    expect(find.text('SG'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('player avatar centers local asset without cropping', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayerAvatar(
          player: PlayerModel(
            id: 'local',
            name: 'Local Player',
            position: 'forward',
            number: 9,
            photoUrl: 'assets/images/branding/arca_corum_fk_logo.png',
          ),
        ),
      ),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.fit, BoxFit.contain);
    expect(image.alignment, Alignment.center);
    expect(image.filterQuality, FilterQuality.high);
    expect(tester.takeException(), isNull);
  });

  testWidgets('player avatar falls back safely when local asset is missing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayerAvatar(
          player: PlayerModel(
            id: 'missing',
            name: 'Mame Thiam',
            position: 'forward',
            number: 17,
            photoUrl: 'assets/images/players/corum_fk/missing.jpg',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('MT'), findsOneWidget);
    expect(find.text('17'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
