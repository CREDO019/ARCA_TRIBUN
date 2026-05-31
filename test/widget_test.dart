import 'package:arca_tribun/core/router/route_names.dart';
import 'package:arca_tribun/core/storage/onboarding_preferences.dart';
import 'package:arca_tribun/core/theme/theme_preference_provider.dart';
import 'package:arca_tribun/features/auth/presentation/login_screen.dart';
import 'package:arca_tribun/features/fan_profile/domain/fan_profile_model.dart';
import 'package:arca_tribun/features/fan_profile/data/fan_profile_repository.dart';
import 'package:arca_tribun/features/fan_profile/presentation/fan_profile_provider.dart';
import 'package:arca_tribun/features/fan_profile/presentation/profile_screen.dart';
import 'package:arca_tribun/features/home/presentation/widgets/store_banner_card.dart';
import 'package:arca_tribun/features/home/presentation/widgets/next_match_countdown.dart';
import 'package:arca_tribun/features/notification_preferences/presentation/notification_prefs_screen.dart';
import 'package:arca_tribun/features/onboarding/presentation/onboarding_screen.dart';
import 'package:arca_tribun/features/splash/presentation/splash_screen.dart';
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

  setUp(() {
    SharedPreferences.setMockInitialValues({});
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
    expect(await OnboardingPreferences.hasSeenOnboarding(), isTrue);
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
    expect(await OnboardingPreferences.hasSeenOnboarding(), isTrue);
  });

  testWidgets('first launch routes from splash to onboarding', (
    WidgetTester tester,
  ) async {
    final router = _createSplashTestRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });

  testWidgets('seen onboarding routes from splash to login', (
    WidgetTester tester,
  ) async {
    await OnboardingPreferences.markAsSeen();
    final router = _createSplashTestRouter();
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN DESTINATION'), findsOneWidget);
  });

  testWidgets('login keeps unavailable auth methods in upcoming state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Yakında'), findsNWidgets(3));

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('guest_login_btn')));
    await tester.pump();

    expect(find.text('Misafir erişimi yakında aktif olacak.'), findsOneWidget);
  });

  testWidgets('profile shows real fields and account delete confirmation', (
    WidgetTester tester,
  ) async {
    final repository = _FakeFanProfileRepository();
    final profile = FanProfileModel(
      uid: 'user-id',
      displayName: 'Tribun Taraftari',
      fanPoints: 125,
      fanLevel: 2,
      fanLevelTitle: 'Gümüş',
      currentStreak: 0,
      longestStreak: 0,
      earnedBadgeIds: const [],
      totalPredictions: 0,
      correctPredictions: 0,
      lastCheckIn: DateTime(2000),
      preferredLocale: 'tr',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fanProfileProvider.overrideWith((ref) => Stream.value(profile)),
          fanProfileRepositoryProvider.overrideWithValue(repository),
          currentUserEmailProvider.overrideWith(
            (ref) => 'taraftar@example.com',
          ),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tribun Taraftari'), findsOneWidget);
    expect(find.text('taraftar@example.com'), findsOneWidget);
    expect(find.text('125'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Tema'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('theme_dark_option')),
      300,
    );
    await tester.tap(find.byKey(const Key('theme_dark_option')));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('theme_preference'),
      ThemePreference.dark.name,
    );

    await tester.ensureVisible(find.byKey(const Key('edit_profile_tile')));
    await tester.tap(find.byKey(const Key('edit_profile_tile')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('display_name_field')),
      'Yeni Taraftar',
    );
    await tester.tap(find.byKey(const Key('save_display_name_button')));
    await tester.pumpAndSettle();

    expect(repository.updatedDisplayName, 'Yeni Taraftar');
    expect(find.text('Profil bilgileriniz güncellendi.'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('project_info_tile')),
      300,
    );
    await tester.tap(find.byKey(const Key('project_info_tile')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Bu uygulama pilot/prototip çalışmadır. '
        'Resmi kullanım için kulüp onayı gerektirir.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('KAPAT'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('request_account_delete_tile')),
      300,
    );
    await tester.tap(find.byKey(const Key('request_account_delete_tile')));
    await tester.pumpAndSettle();

    expect(find.text('Hesabı kalıcı olarak sil'), findsOneWidget);
    expect(
      find.byKey(const Key('confirm_delete_account_button')),
      findsOneWidget,
    );

    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('delete_account_dialog')), findsNothing);
  });

  testWidgets('notification preferences render before Hive settings box opens',
      (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: NotificationPrefsScreen()),
      ),
    );

    expect(find.text('Bildirim Ayarları'), findsOneWidget);
    expect(find.text('GOL BİLDİRİMLERİ'), findsOneWidget);
    expect(find.text('MAÇ BİLDİRİMLERİ'), findsOneWidget);
    expect(find.text('Kadro bilgileri güncellendi'), findsOneWidget);
  });

  testWidgets('countdown scales down on a narrow screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 230,
            child: NextMatchCountdown(
              matchTime: DateTime.now().add(const Duration(days: 120)),
              title: 'Yeni Sezon Başlangıcı',
              description: 'Süper Lig 2026/2027 sezonu başlangıç haftası.',
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('store banner explains missing pilot link', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: StoreBannerCard())),
    );

    await tester.tap(find.byKey(const Key('store_banner_card')));
    await tester.pump();

    expect(
      find.text('Mağaza bağlantısı yakında eklenecek.'),
      findsOneWidget,
    );
  });
}

class _FakeFanProfileRepository extends FanProfileRepository {
  String? updatedDisplayName;

  @override
  Future<void> updateDisplayName(String displayName) async {
    updatedDisplayName = displayName;
  }
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

GoRouter _createSplashTestRouter() => GoRouter(
      initialLocation: RouteNames.splash,
      routes: [
        GoRoute(
          path: RouteNames.splash,
          builder: (_, __) => const SplashScreen(),
        ),
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
