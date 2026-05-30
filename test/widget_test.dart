import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/features/onboarding/presentation/onboarding_screen.dart';
import 'package:arca_tribun/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'test-publishable-key',
    );
  });

  testWidgets('app entry can be constructed', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('tr')],
        path: 'assets/translations',
        fallbackLocale: const Locale('tr'),
        child: const ProviderScope(
          child: ArcaTribunApp(),
        ),
      ),
    );

    expect(find.byType(ArcaTribunApp), findsOneWidget);
  });

  testWidgets('onboarding supports swipe and login CTA navigation', (
    WidgetTester tester,
  ) async {
    final router = _createOnboardingTestRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('ARCA TRİBÜN’E\nHOŞ GELDİN'), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('onboarding_page_view')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('MAÇ GÜNÜNÜ\nKAÇIRMA'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_primary_action')));
    await tester.pumpAndSettle();
    expect(find.text('TRİBÜNÜN\nDİJİTAL EVİ'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_primary_action')));
    await tester.pumpAndSettle();
    expect(find.text('KIRMIZI\nSİYAH RUH'), findsOneWidget);
    expect(find.text('GİRİŞ YAP'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_primary_action')));
    await tester.pumpAndSettle();
    expect(find.text('LOGIN DESTINATION'), findsOneWidget);
  });

  testWidgets('onboarding skip navigates to login', (
    WidgetTester tester,
  ) async {
    final router = _createOnboardingTestRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('onboarding_skip')));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN DESTINATION'), findsOneWidget);
  });
}

GoRouter _createOnboardingTestRouter() => GoRouter(
      initialLocation: RouteNames.onboarding,
      routes: [
        GoRoute(
          path: RouteNames.onboarding,
          builder: (_, __) => const OnboardingScreen(),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (_, __) => const Scaffold(
            body: Center(child: Text('LOGIN DESTINATION')),
          ),
        ),
      ],
    );
