import 'package:arca_tribun/core/notifications/notification_service.dart';
import 'package:arca_tribun/core/offline/hive_service.dart';
import 'package:arca_tribun/core/router/app_router.dart';
import 'package:arca_tribun/core/theme/app_theme.dart';
import 'package:arca_tribun/core/theme/theme_preference_provider.dart';
import 'package:arca_tribun/supabase_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uygulama giriş noktası.
///
/// Başlatma sırası:
/// 1. Flutter binding
/// 2. Supabase
/// 3. Sentry (crash reporting)
/// 4. Hive (yerel depolama)
/// 5. EasyLocalization
/// 6. NotificationService (FCM)
/// 7. runApp → ProviderScope → EasyLocalization → ArcaTribunApp
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase başlat ────────────────────────────────────────────────────
  SupabaseConfig.validateSupabase();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.publishableKey,
    debug: false, // Production'da false
  );

  // ── Hive (yerel önbellek) başlat ───────────────────────────────────────
  await Hive.initFlutter();
  await HiveService.instance.initialize();
  // Adapter kayıtları buraya eklenir:
  // Hive.registerAdapter(SyncOperationAdapter());

  // ── EasyLocalization ───────────────────────────────────────────────────
  await EasyLocalization.ensureInitialized();

  // ── Bildirim servisi ───────────────────────────────────────────────────
  if (SupabaseConfig.enablePushNotifications) {
    await NotificationService.instance.initialize();
  }

  // ── Sentry ile uygulamayı başlat ───────────────────────────────────────
  await SentryFlutter.init(
    (options) {
      options.dsn = SupabaseConfig.sentryDsn;
      options.tracesSampleRate = 0.2;
      options.environment = 'production';
    },
    appRunner: _runApp,
  );
}

void _runApp() {
  AppRouter.setupNotificationRouting();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('de'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
      child: const ProviderScope(
        child: ArcaTribunApp(),
      ),
    ),
  );
}

/// Uygulama kök widget'ı.
class ArcaTribunApp extends ConsumerWidget {
  const ArcaTribunApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themePreference = ref.watch(themePreferenceProvider);

    return MaterialApp.router(
      title: 'ARCA TRİBÜN',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themePreference.themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
