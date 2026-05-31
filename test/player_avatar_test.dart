import 'dart:ui' as ui;

import 'package:arca_tribun/core/assets/corum_player_photo_assets.dart';
import 'package:arca_tribun/core/pilot/pilot_data.dart';
import 'package:arca_tribun/features/squad/domain/player_model.dart';
import 'package:arca_tribun/shared/widgets/player_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('player photo mapping normalizes Turkish characters and aliases', () {
    expect(
      corumPlayerPhotoAsset('SERDAR GÜRLER'),
      'assets/images/players/corum_fk/serdar_gurler.jpg',
    );
    expect(
      corumPlayerPhotoAsset('  Ahmet Said Kıvanç '),
      'assets/images/players/corum_fk/ahmet_kivanc.jpg',
    );
    expect(
      corumPlayerPhotoAsset('Fredy Ribeiro'),
      'assets/images/players/corum_fk/fredy.jpg',
    );
  });

  test('player photo mapping logs and returns null for a missing photo', () {
    final messages = <String>[];
    final originalDebugPrint = debugPrint;
    debugPrint = (message, {wrapWidth}) {
      if (message != null) messages.add(message);
    };
    addTearDown(() => debugPrint = originalDebugPrint);

    expect(corumPlayerPhotoAsset('Mame Thiam'), isNull);
    expect(
      messages,
      contains(
        'Player photo missing: Mame Thiam -> '
        'assets/images/players/corum_fk/mame_thiam.jpg',
      ),
    );
  });

  test('pilot squad wires every available local player photo', () {
    final rowsWithPhoto =
        PilotData.squadRows.where((row) => row['image_url'] != null).toList();
    final rowsWithoutPhoto =
        PilotData.squadRows.where((row) => row['image_url'] == null).toList();

    expect(rowsWithPhoto, hasLength(26));
    expect(rowsWithoutPhoto, hasLength(1));
    expect(rowsWithoutPhoto.single['name'], 'Mame Thiam');
  });

  testWidgets('every wired pilot photo is packaged and decodable', (
    tester,
  ) async {
    final rowsWithPhoto = PilotData.squadRows.where(
      (row) => row['image_url'] != null,
    );

    await tester.runAsync(() async {
      for (final row in rowsWithPhoto) {
        final playerName = row['name'] as String;
        final assetPath = row['image_url'] as String;
        expect(corumPlayerPhotoAsset(playerName), assetPath);

        final data = await rootBundle.load(assetPath);
        final bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();

        expect(frame.image.width, 591, reason: assetPath);
        expect(frame.image.height, 709, reason: assetPath);

        frame.image.dispose();
        codec.dispose();
      }
    });
  });

  testWidgets('player avatar uses premium placeholder without local photo', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayerAvatar(
          player: PlayerModel(
            id: 'mame',
            name: 'Mame Thiam',
            position: 'forward',
            number: 17,
            photoUrl: 'https://example.com/mame.jpg',
          ),
        ),
      ),
    );

    expect(find.text('MT'), findsOneWidget);
    expect(find.text('17'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('player avatar maps local photo when image url is empty', (
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
          ),
        ),
      ),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    final assetImage = image.image as AssetImage;
    expect(
      assetImage.assetName,
      'assets/images/players/corum_fk/serdar_gurler.jpg',
    );
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
