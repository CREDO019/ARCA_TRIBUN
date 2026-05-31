import 'package:arca_tribun/features/home/presentation/widgets/matchday_assistant_card.dart';
import 'package:arca_tribun/features/match_center/domain/match_model.dart';
import 'package:arca_tribun/features/stadium/domain/weather_snapshot.dart';
import 'package:arca_tribun/features/stadium/presentation/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('matchday assistant renders matchday summary and opens maps', (
    tester,
  ) async {
    Uri? launchedUri;
    final upcoming = _upcomingMatch();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stadiumWeatherProvider.overrideWith(
            (ref) async => const WeatherSnapshot(
              temperature: 28,
              weatherCode: 0,
              windSpeed: 9,
            ),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 320,
                child: MatchdayAssistantCard(
                  upcomingMatch: upcoming,
                  recentMatch: _recentMatch(),
                  isConnectedOverride: true,
                  tipIndexOverride: 0,
                  launchMaps: (uri) async {
                    launchedUri = uri;
                    return true;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('MAÇ GÜNÜ ASİSTANI'), findsOneWidget);
    expect(find.text('Çorum Şehir Stadyumu'), findsOneWidget);
    expect(find.text('28°C · Açık'), findsOneWidget);
    expect(find.text('MAÇ GÜNÜ DURUMU'), findsOneWidget);
    expect(find.text('Rakip yakında açıklanacak'), findsOneWidget);
    expect(find.text('37’ Serdar Gürler · 53’ Mame Thiam'), findsOneWidget);
    expect(
      find.textContaining('Kırmızı-Siyah formayı unutma.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const Key('matchday_maps_button')));
    await tester.tap(find.byKey(const Key('matchday_maps_button')));
    await tester.pump();

    expect(launchedUri?.host, 'www.google.com');
    expect(launchedUri?.queryParameters['api'], '1');
    expect(launchedUri?.queryParameters['query'], '40.534444,34.922778');
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('matchday assistant shows safe offline state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatchdayAssistantCard(
              upcomingMatch: _upcomingMatch(),
              recentMatch: _recentMatch(),
              isConnectedOverride: false,
              tipIndexOverride: 1,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Hava durumu alınamıyor.'), findsOneWidget);
    expect(
      find.text('Maç bilgileri son senkronizasyondan gösteriliyor.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('matchday assistant shows live status', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatchdayAssistantCard(
              liveMatch: _liveMatch(),
              recentMatch: _recentMatch(),
              isConnectedOverride: false,
              tipIndexOverride: 2,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Bugün maç var. Karşılaşma canlı.'), findsOneWidget);
    expect(find.text('CANLI'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

MatchModel _upcomingMatch() {
  return MatchModel(
    id: 'upcoming',
    homeTeam: 'ARCA ÇORUM FK',
    awayTeam: 'Rakip açıklanacak',
    kickoffTime: DateTime.now().add(
      const Duration(days: 14, hours: 7, minutes: 18),
    ),
    status: MatchStatus.scheduled,
    venue: 'Çorum Şehir Stadyumu',
    competition: 'Trendyol Süper Lig',
  );
}

MatchModel _recentMatch() {
  return MatchModel(
    id: 'recent',
    homeTeam: 'Esenler Erokspor',
    awayTeam: 'Çorum FK',
    kickoffTime: DateTime(2026, 5, 24, 19),
    status: MatchStatus.postMatch,
    homeScore: 0,
    awayScore: 2,
    venue: 'Medaş Konya Büyükşehir Stadyumu',
    competition: 'Trendyol 1. Lig Play-Off Finali',
  );
}

MatchModel _liveMatch() {
  return MatchModel(
    id: 'live',
    homeTeam: 'ARCA ÇORUM FK',
    awayTeam: 'Rakip',
    kickoffTime: DateTime.now(),
    status: MatchStatus.live,
    homeScore: 1,
    awayScore: 0,
    minute: 54,
  );
}
