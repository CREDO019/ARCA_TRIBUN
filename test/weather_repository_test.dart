import 'package:arca_tribun/core/pilot/pilot_data.dart';
import 'package:arca_tribun/features/stadium/data/weather_repository.dart';
import 'package:arca_tribun/features/stadium/presentation/stadium_card.dart';
import 'package:arca_tribun/features/stadium/presentation/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weather repository parses Open-Meteo current response', () async {
    Uri? requestedUri;
    final repository = WeatherRepository(
      fetchJson: (uri) async {
        requestedUri = uri;
        return {
          'current': {
            'temperature_2m': 18.4,
            'weather_code': 2,
            'wind_speed_10m': 11.2,
          },
        };
      },
    );

    final snapshot = await repository.fetchCurrentStadiumWeather();

    expect(snapshot.temperature, 18.4);
    expect(snapshot.conditionLabel, 'Parçalı bulutlu');
    expect(snapshot.windSpeed, 11.2);
    expect(requestedUri?.host, 'api.open-meteo.com');
    expect(
      requestedUri?.queryParameters['current'],
      'temperature_2m,weather_code,wind_speed_10m',
    );
  });

  testWidgets('stadium card shows safe weather fallback', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stadiumWeatherProvider.overrideWith(
            (ref) => Future.error(Exception('offline')),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: StadiumCard(compact: true)),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Çorum Şehir Stadyumu'), findsOneWidget);
    expect(find.text('Hava durumu şu anda alınamıyor.'), findsOneWidget);
  });

  test('pilot standings contain verified 20-team final table', () {
    expect(PilotData.standingsRows, hasLength(20));

    final ourTeam = PilotData.standingsRows[3];
    expect(ourTeam['team_name'], 'ARCA ÇORUM FK');
    expect(ourTeam['position'], 4);
    expect(ourTeam['points'], 71);

    final adanaDemirspor = PilotData.standingsRows.last;
    expect(adanaDemirspor['team_name'], 'Adana Demirspor');
    expect(adanaDemirspor['points'], -57);
  });
}
