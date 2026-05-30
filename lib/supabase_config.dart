/// Supabase ve gözlemlenebilirlik servislerinin çalışma zamanı ayarları.
///
/// Yerel geliştirme için:
/// flutter run --dart-define-from-file=config/supabase.dev.json
class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase proje URL'si - örn: https://xyzxyz.supabase.co
  static const String url = String.fromEnvironment('SUPABASE_URL');

  /// Mobil istemcide kullanılabilen publishable key.
  ///
  /// Supabase Flutter SDK geriye dönük uyumluluk nedeniyle bu değeri
  /// `anonKey` parametresiyle alır.
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  /// Firebase platform ayarlari tamamlandiginda etkinlestirilir.
  static const bool enablePushNotifications = bool.fromEnvironment(
    'ENABLE_PUSH_NOTIFICATIONS',
  );

  /// Sentry DSN (crash reporting) - https://sentry.io'dan alın.
  /// Boş bırakırsanız Sentry devre dışı kalır.
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');

  /// Mixpanel token - https://mixpanel.com'dan alın.
  /// Boş bırakırsanız analytics stub olarak çalışır.
  static const String mixpanelToken = String.fromEnvironment('MIXPANEL_TOKEN');

  static void validateSupabase() {
    if (url.isEmpty || publishableKey.isEmpty) {
      throw StateError(
        'Supabase configuration is missing. Start the app with '
        '--dart-define-from-file=config/supabase.dev.json',
      );
    }
  }
}
