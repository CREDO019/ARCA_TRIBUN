# ARCA TRİBÜN — CLAUDE CODE MASTER PROMPT

---

## ROL VE GÖREV

Sen senior seviyede bir Flutter Architect ve Mobile Product Engineer olarak çalışıyorsun.

Görevin: **ARCA Tribün** adlı profesyonel futbol taraftar mobil uygulamasını sıfırdan, production-ready seviyede inşa etmek.

Bu bir demo, tutorial veya öğrenci projesi değil. Gerçek dünyada Çorum FK kulübüne sunulabilecek, Süper Lig seviyesinde bir mobil ürün.

---

## PROJE KİMLİĞİ

- **Uygulama Adı:** ARCA Tribün
- **Tür:** Football Fan Engagement Platform
- **Kulüp:** Arca Çorum FK
- **Platform:** Flutter (iOS + Android)
- **Backend:** Firebase (Firestore, Auth, FCM, Storage, Functions, Analytics, Crashlytics)

---

## TASARIM TOKEN'LARI — DEĞİŞTİRME

```dart
// Bunlar projenin DNA'sı. Hiçbir yerde hardcode renk kullanma.
static const Color primaryRed    = Color(0xFFCC0000);
static const Color deepBlack     = Color(0xFF0B0B0B);
static const Color background    = Color(0xFF090909);
static const Color cardBg        = Color(0xFF151515);
static const Color cardBg2       = Color(0xFF1E1E1E);
static const Color white         = Color(0xFFFFFFFF);
static const Color secondaryGray = Color(0xFFA3A3A3);
static const Color success       = Color(0xFF16A34A);
static const Color warning       = Color(0xFFFACC15);
static const Color border        = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
```

---

## TEKNİK STACK — KESİN LİSTE

### Flutter Paketleri (pubspec.yaml'a ekle)

```yaml
dependencies:
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Firebase
  firebase_core: ^2.27.1
  firebase_auth: ^4.17.9
  cloud_firestore: ^4.15.9
  firebase_messaging: ^14.7.19
  firebase_storage: ^11.6.10
  firebase_analytics: ^10.8.10
  firebase_crashlytics: ^3.4.19
  firebase_performance: ^0.9.3+19
  firebase_remote_config: ^4.3.19

  # Audio & Sound
  just_audio: ^0.9.38
  audio_session: ^0.1.18
  soundpool: ^2.3.0

  # Notifications
  flutter_local_notifications: ^17.1.2

  # Localization
  easy_localization: ^3.0.7
  intl: ^0.19.0

  # Local Storage & Cache
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0
  flutter_cache_manager: ^3.3.1

  # Connectivity
  connectivity_plus: ^6.0.3

  # UI & Animations
  lottie: ^3.1.0
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0

  # Auth Providers
  google_sign_in: ^6.2.1
  sign_in_with_apple: ^6.1.1

  # Utils
  dartz: ^0.10.1
  equatable: ^2.0.5
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  logger: ^2.3.0
  package_info_plus: ^8.0.0
  device_info_plus: ^10.1.0
  url_launcher: ^6.2.5
  share_plus: ^9.0.0
  vibration: ^1.9.0

dev_dependencies:
  build_runner: ^2.4.9
  freezed: ^2.4.7
  json_serializable: ^6.8.0
  riverpod_generator: ^2.3.11
  flutter_gen_runner: ^5.4.0
  very_good_analysis: ^6.0.0
```

---

## PROJE KLASÖR YAPISI — TAM HİYERARŞİ

Aşağıdaki yapıyı **eksiksiz** oluştur. Her dosya içi boş bırakılmayacak, her biri production-ready kod içerecek.

```
lib/
│
├── main.dart
├── app.dart
├── firebase_options.dart
│
├── core/
│   │
│   ├── audio/
│   │   ├── audio_service.dart
│   │   ├── sound_manager.dart
│   │   ├── goal_sound_engine.dart
│   │   └── audio_preference_store.dart
│   │
│   ├── l10n/
│   │   ├── app_localizations.dart
│   │   └── locale_provider.dart
│   │
│   ├── notifications/
│   │   ├── notification_service.dart
│   │   ├── foreground_handler.dart
│   │   ├── background_handler.dart
│   │   ├── terminated_handler.dart
│   │   ├── notification_channels.dart
│   │   ├── topic_manager.dart
│   │   └── notification_router.dart
│   │
│   ├── offline/
│   │   ├── hive_service.dart
│   │   ├── sync_queue.dart
│   │   ├── connectivity_service.dart
│   │   └── cache_policy.dart
│   │
│   ├── security/
│   │   ├── secure_storage_service.dart
│   │   └── device_check_service.dart
│   │
│   ├── analytics/
│   │   ├── analytics_service.dart
│   │   ├── event_names.dart
│   │   └── performance_traces.dart
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   └── app_theme.dart
│   │
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── firestore_paths.dart
│   │
│   ├── router/
│   │   ├── app_router.dart
│   │   ├── route_names.dart
│   │   └── route_guard.dart
│   │
│   └── error/
│       ├── failure.dart
│       ├── error_handler.dart
│       └── crashlytics_reporter.dart
│
├── features/
│   │
│   ├── splash/
│   │   └── presentation/
│   │       └── splash_screen.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── onboarding_screen.dart
│   │       └── widgets/
│   │           └── onboarding_page_widget.dart
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_remote_datasource.dart
│   │   │   └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── auth_repository.dart
│   │   │   ├── login_usecase.dart
│   │   │   └── user_model.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── auth_provider.dart
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── home_remote_datasource.dart
│   │   │   └── home_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── home_repository.dart
│   │   │   └── home_usecase.dart
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       ├── home_provider.dart
│   │       └── widgets/
│   │           ├── live_match_hero_card.dart
│   │           ├── next_match_countdown.dart
│   │           ├── news_horizontal_scroll.dart
│   │           ├── fan_prediction_strip.dart
│   │           ├── standings_mini_card.dart
│   │           └── store_banner_card.dart
│   │
│   ├── match_center/
│   │   ├── data/
│   │   │   ├── match_remote_datasource.dart
│   │   │   └── match_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── match_repository.dart
│   │   │   ├── match_model.dart
│   │   │   └── match_event_model.dart
│   │   └── presentation/
│   │       ├── match_center_screen.dart
│   │       ├── match_provider.dart
│   │       ├── pre_game/
│   │       │   ├── pre_game_screen.dart
│   │       │   └── widgets/
│   │       │       ├── probable_xi_widget.dart
│   │       │       ├── stadium_info_widget.dart
│   │       │       └── weather_widget.dart
│   │       ├── live/
│   │       │   ├── live_screen.dart
│   │       │   └── widgets/
│   │       │       ├── live_score_header.dart
│   │       │       ├── match_events_list.dart
│   │       │       ├── possession_bar.dart
│   │       │       └── live_stats_widget.dart
│   │       └── post_match/
│   │           ├── post_match_screen.dart
│   │           └── widgets/
│   │               ├── match_summary_widget.dart
│   │               ├── player_of_match_widget.dart
│   │               └── fan_voting_widget.dart
│   │
│   ├── news/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── news_model.dart
│   │   └── presentation/
│   │       ├── news_list_screen.dart
│   │       ├── news_detail_screen.dart
│   │       └── news_provider.dart
│   │
│   ├── fixtures/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── fixture_model.dart
│   │   └── presentation/
│   │       ├── fixtures_screen.dart
│   │       └── fixtures_provider.dart
│   │
│   ├── standings/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── standing_model.dart
│   │   └── presentation/
│   │       ├── standings_screen.dart
│   │       └── standings_provider.dart
│   │
│   ├── squad/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── player_model.dart
│   │   └── presentation/
│   │       ├── squad_screen.dart
│   │       ├── player_detail_screen.dart
│   │       └── squad_provider.dart
│   │
│   ├── predictions/
│   │   ├── data/
│   │   │   └── prediction_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── prediction_model.dart
│   │   │   └── prediction_repository.dart
│   │   └── presentation/
│   │       ├── prediction_provider.dart
│   │       └── widgets/
│   │           └── prediction_card_widget.dart
│   │
│   ├── fan_profile/
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── fan_profile_model.dart
│   │   │   └── badge_model.dart
│   │   └── presentation/
│   │       ├── profile_screen.dart
│   │       ├── fan_profile_provider.dart
│   │       ├── badges/
│   │       │   ├── badges_screen.dart
│   │       │   └── badge_detail_screen.dart
│   │       └── leaderboard/
│   │           ├── leaderboard_screen.dart
│   │           └── leaderboard_provider.dart
│   │
│   └── notification_preferences/
│       └── presentation/
│           ├── notification_prefs_screen.dart
│           └── notification_prefs_provider.dart
│
├── shared/
│   ├── widgets/
│   │   ├── app_scaffold.dart
│   │   ├── bottom_nav_bar.dart
│   │   ├── match_card.dart
│   │   ├── player_card.dart
│   │   ├── news_card.dart
│   │   ├── badge_widget.dart
│   │   ├── offline_banner.dart
│   │   ├── loading_shimmer.dart
│   │   ├── error_widget.dart
│   │   ├── goal_celebration_overlay.dart
│   │   └── badge_unlock_animation.dart
│   │
│   └── providers/
│       ├── auth_state_provider.dart
│       ├── connectivity_provider.dart
│       └── match_state_provider.dart

assets/
├── sounds/
│   ├── goal_roar.mp3
│   ├── crowd_chant.mp3
│   ├── final_whistle.mp3
│   ├── red_card_whistle.mp3
│   └── notification_chime.mp3
├── translations/
│   ├── tr.json
│   ├── en.json
│   ├── de.json
│   └── ar.json
└── lottie/
    ├── goal_celebration.json
    └── badge_unlock.json

functions/
├── src/
│   ├── match/
│   │   ├── liveMatchBridge.ts
│   │   └── matchStateManager.ts
│   ├── notifications/
│   │   ├── goalNotification.ts
│   │   └── localizedPush.ts
│   ├── gamification/
│   │   ├── predictionEvaluator.ts
│   │   ├── badgeEngine.ts
│   │   └── leaderboardSync.ts
│   └── security/
│       └── rateLimiter.ts
├── package.json
└── tsconfig.json
```

---

## YAZILACAK DOSYALAR — DETAYLI KURALLAR

### 1. main.dart

```dart
// Yapılacaklar:
// - WidgetsFlutterBinding.ensureInitialized()
// - Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
// - FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError
// - PlatformDispatcher.instance.onError ile unhandled async error yakalama
// - Hive.initFlutter() + adapter kayıtları
// - EasyLocalization.ensureInitialized()
// - NotificationService.initialize()
// - runApp(EasyLocalization(child: ProviderScope(child: ArcaTribunApp())))
```

### 2. core/audio/audio_service.dart

Şunları içermeli:
- `AudioService` singleton sınıfı
- `initAudio()` → AudioSession yapılandırması (iOS: AVAudioSessionCategory.playback)
- `playSound(SoundType type)` → just_audio Player ile ses çalma
- `stopAll()` → tüm oynatıcıları durdur
- `SoundType` enum: goal, redCard, finalWhistle, notification, crowdChant
- Her SoundType için ayrı AudioPlayer instance (overlap için)
- Telefon sessiz modda bile ses çalma için AVAudioSessionCategory.ambient fallback

### 3. core/audio/goal_sound_engine.dart

Şunları içermeli:
- `GoalSoundEngine` sınıfı
- Firestore `matches/{matchId}` dinleme
- `score` alanı değiştiğinde → `triggerGoalSequence()`
- `triggerGoalSequence()`: önce roar, 800ms sonra crowd_chant overlay
- Vibration pattern: [0, 200, 100, 200, 100, 400]
- `GoalCelebrationOverlay` widget'ını tetikleme
- Background isolate'de çalışma (uygulama arka planda olsa bile)

### 4. core/notifications/notification_service.dart

Şunları içermeli:
- `NotificationService` singleton
- `initialize()`: FCM token alma, channel oluşturma, permission isteme
- `setupForegroundHandler()` → FirebaseMessaging.onMessage
- `setupBackgroundHandler()` → FirebaseMessaging.onBackgroundMessage (top-level function)
- `setupTerminatedHandler()` → getInitialMessage()
- `onNotificationTapped()` → NotificationRouter'a yönlendir
- Her mesaj türü için `NotificationPayloadType` enum parse etme

### 5. core/notifications/notification_channels.dart

Android kanalları (Flutter Local Notifications):

```dart
// GOL_CHANNEL: importance: max, ses: goal_roar, vibration: [0,200,100,200]
// MACAYRINTISI_CHANNEL: importance: high, ses: red_card_whistle
// HABER_CHANNEL: importance: default, ses: notification_chime
// KAMPANYA_CHANNEL: importance: low, ses: yok
// MACSONU_CHANNEL: importance: high, ses: final_whistle
```

### 6. core/offline/sync_queue.dart

Şunları içermeli:
- `SyncQueue` sınıfı (Hive backed)
- `enqueue(SyncOperation operation)`: offline işlemi kuyruğa ekle
- `processQueue()`: bağlantı gelince tüm kuyruğu işle
- `SyncOperation` model: type, payload, timestamp, retryCount
- Max 3 retry, sonra dead letter queue
- ConnectivityService stream'ini dinle, bağlantıda otomatik tetikle

### 7. core/l10n/ — Lokalizasyon

`assets/translations/tr.json` içeriği (örnek):
```json
{
  "app_name": "ARCA Tribün",
  "home": {
    "live_match": "CANLI MAÇ",
    "next_match": "Sıradaki Maç",
    "news": "Son Haberler",
    "standings": "Puan Durumu",
    "prediction": "Taraftar Tahmini",
    "see_all": "Tümünü Gör"
  },
  "match": {
    "pre_game": "Maç Öncesi",
    "live": "Canlı",
    "post_match": "Maç Sonu",
    "minute": "{{minute}}'",
    "goal": "GOL!",
    "red_card": "Kırmızı Kart",
    "substitution": "Oyuncu Değişikliği"
  },
  "notification": {
    "goal_title": "GOL! ⚽",
    "goal_body": "{{player}} golü attı! Skor: {{score}}",
    "match_start": "Maç başlıyor!",
    "final_whistle": "Maç sona erdi. Sonuç: {{score}}"
  },
  "auth": {
    "login": "Giriş Yap",
    "register": "Kayıt Ol",
    "google": "Google ile Devam Et",
    "apple": "Apple ile Devam Et",
    "guest": "Misafir Olarak Devam Et"
  },
  "profile": {
    "fan_level": "Taraftar Seviyesi",
    "points": "Fan Puanı",
    "streak": "Gün Serisi",
    "badges": "Rozetler",
    "leaderboard": "Sıralama"
  },
  "errors": {
    "no_connection": "İnternet bağlantısı yok",
    "server_error": "Sunucu hatası, lütfen tekrar deneyin",
    "unknown": "Beklenmedik bir hata oluştu"
  }
}
```

Aynısını `en.json`, `de.json`, `ar.json` için de oluştur.

### 8. core/theme/app_colors.dart

```dart
// SADECE bu token'ları kullan, başka renk kabul edilmez:
// primaryRed, deepBlack, background, cardBg, cardBg2,
// white, secondaryGray, success, warning, border
// + semantic: errorRed, infoBlue, overlayDark
```

### 9. core/theme/app_typography.dart

```dart
// Font: Google Fonts - Barlow Condensed (başlıklar) + Barlow (body)
// displayLarge: BarlowCondensed, 800 weight, 48sp
// displayMedium: BarlowCondensed, 700 weight, 32sp
// headlineLarge: BarlowCondensed, 700 weight, 24sp
// headlineMedium: BarlowCondensed, 600 weight, 20sp
// titleLarge: Barlow, 600 weight, 18sp
// titleMedium: Barlow, 500 weight, 16sp
// bodyLarge: Barlow, 400 weight, 16sp
// bodyMedium: Barlow, 400 weight, 14sp
// labelSmall: Barlow, 700 weight, 10sp, letterSpacing: 1.2
```

### 10. core/router/app_router.dart (go_router)

Route'lar:
```
/ → SplashScreen
/onboarding → OnboardingScreen
/auth/login → LoginScreen
/auth/register → RegisterScreen
/home → HomeScreen (ShellRoute)
  /home/match-center/:matchId → MatchCenterScreen
  /home/news → NewsListScreen
  /home/news/:newsId → NewsDetailScreen
  /home/fixtures → FixturesScreen
  /home/standings → StandingsScreen
  /home/squad → SquadScreen
  /home/squad/:playerId → PlayerDetailScreen
  /home/profile → ProfileScreen
  /home/profile/badges → BadgesScreen
  /home/profile/leaderboard → LeaderboardScreen
  /home/notifications → NotificationPrefsScreen
```

- AuthGuard: kullanıcı login değilse /auth/login'e yönlendir
- `extra` parametresiyle model geçişi
- Notification tap → doğru route'a deep link

### 11. Firestore Veri Modelleri

`firestore_paths.dart`:
```dart
class FirestorePaths {
  static const String matches = 'matches';
  static String match(String id) => 'matches/$id';
  static String liveMatch(String id) => 'matches/$id/live/current';
  static String matchEvents(String id) => 'matches/$id/events';
  static const String news = 'news';
  static String newsItem(String id) => 'news/$id';
  static const String standings = 'standings/current';
  static const String fixtures = 'fixtures';
  static const String squad = 'squad';
  static String player(String id) => 'squad/$id';
  static String fanProfile(String uid) => 'fan_profiles/$uid';
  static String predictions(String matchId) => 'predictions/$matchId';
  static String userPrediction(String matchId, String uid) 
      => 'predictions/$matchId/user_predictions/$uid';
  static const String leaderboard = 'leaderboard/global';
  static const String weeklyLeaderboard = 'leaderboard/weekly';
}
```

Firestore döküman modelleri (freezed + json_serializable):
- `MatchModel`, `LiveMatchModel`, `MatchEventModel`
- `NewsModel`
- `FixtureModel`
- `StandingModel`
- `PlayerModel`
- `FanProfileModel`
- `BadgeModel`
- `PredictionModel`
- `LeaderboardEntryModel`

### 12. features/home/presentation/widgets/

Her widget kendi içinde Riverpod consumer, kendi provider'ından veri alır. Home screen sadece bunları sıralar, iş mantığı widget içinde.

**live_match_hero_card.dart:**
- Gradient arka plan (kırmızı → siyah)
- Pulsing "CANLI" badge (AnimationController)
- Takım isim + skor + dakika
- "Maç Merkezine Git" butonu → GoRouter.go()
- matchStatus: "upcoming" ise geri sayım göster

**next_match_countdown.dart:**
- Stream.periodic ile her saniye güncellenen sayaç
- Gün / Saat / Dakika / Saniye blokları
- dispose'da stream iptal

**fan_prediction_strip.dart:**
- Üç seçenek: Ev Sahibi / Beraberlik / Deplasman
- Seçilen seçenek highlight (kırmızı border)
- Yüzde barları diğer taraftarların tahminleri
- Seçim → PredictionRepository.submitPrediction()
- Zaten tahmin yapıldıysa sadece sonuç göster

### 13. features/match_center/

**MatchStatus enum:**
```dart
enum MatchStatus { scheduled, preGame, live, halfTime, postMatch, cancelled }
```

**match_provider.dart:**
- `matchStatusProvider`: Firestore `matches/{id}.status` dinler
- `liveMatchProvider`: `matches/{id}/live/current` stream
- `matchEventsProvider`: `matches/{id}/events` collection stream

**match_center_screen.dart:**
- `matchStatusProvider` dinle
- `MatchStatus.preGame` → `PreGameScreen`
- `MatchStatus.live || halfTime` → `LiveScreen`
- `MatchStatus.postMatch` → `PostMatchScreen`
- Geçiş animasyonu: FadeTransition

### 14. Gamification — fan_profile/

**FanProfileModel:**
```dart
@freezed
class FanProfileModel with _$FanProfileModel {
  factory FanProfileModel({
    required String uid,
    required String displayName,
    required int fanPoints,
    required int fanLevel,        // 1-5
    required String fanLevelTitle, // Bronz / Gümüş / Altın / Platin / Efsane
    required int currentStreak,
    required int longestStreak,
    required List<String> earnedBadgeIds,
    required int totalPredictions,
    required int correctPredictions,
    required DateTime lastCheckIn,
    required String preferredLocale,
  }) = _FanProfileModel;
}
```

**BadgeModel:**
```dart
// 25 rozet, 3 tier
// Örnek: badge_streak_7 (7 gün streak), badge_prediction_10 (10 doğru tahmin)
// badge_first_match (ilk maç takibi), badge_champion (şampiyonluk sezonu)
```

### 15. shared/widgets/offline_banner.dart

```dart
// connectivity_plus stream dinle
// Bağlantı kesilince üstten sarı banner slide-in
// "Çevrimdışı moddasınız" metni
// Bağlantı gelince otomatik slide-out + SyncQueue.processQueue() tetikle
// Animasyon: 300ms AnimatedContainer
```

### 16. shared/widgets/goal_celebration_overlay.dart

```dart
// GoalSoundEngine'den gelen event ile tetiklenir
// Tam ekran kırmızı flash (100ms)
// Lottie animasyon (goal_celebration.json)
// "GOL!" büyük yazı, oyuncu adı
// 3 saniye sonra otomatik kapanır
// Vibration pattern eşzamanlı çalışır
```

---

## CLOUD FUNCTIONS — TypeScript

### functions/src/notifications/goalNotification.ts

```typescript
// Firestore trigger: onDocumentUpdated('matches/{matchId}/live/current')
// Skor değişimini algıla (önceki vs yeni)
// Hangi takım attı belirle
// Topic: 'match_goal_alerts' ve 'match_{matchId}'
// FCM payload:
// {
//   notification: { title: 'GOL! ⚽', body: lokalize_metin },
//   data: { type: 'GOAL', matchId, scorer, newScore, teamId },
//   android: {
//     priority: 'high',
//     notification: { channelId: 'GOL_CHANNEL', sound: 'goal_roar' }
//   },
//   apns: { payload: { aps: { sound: 'goal_roar.mp3', badge: 1 } } }
// }
// 60 saniyede 5'ten fazla gol → batch notification
```

### functions/src/notifications/localizedPush.ts

```typescript
// Kullanıcının Firestore'daki preferredLocale bilgisini oku
// Mesaj şablonları: tr, en, de, ar
// FCM multicast: her locale grubu için ayrı gönderim
// Helper: getLocalizedMessage(key: string, params: object, locale: string)
```

### functions/src/gamification/predictionEvaluator.ts

```typescript
// Trigger: matches/{matchId} status → 'postMatch'
// predictions/{matchId}/user_predictions tüm dökümanları oku
// Her kullanıcı için: tahmin doğru mu?
// Puan hesapla: doğru sonuç = 100, doğru skor = 200
// fan_profiles/{uid} güncelle: fanPoints += puan
// Badge check tetikle
// Leaderboard sync tetikle
```

### functions/src/security/rateLimiter.ts

```typescript
// Her Cloud Function başında çalışır
// Firestore: rate_limits/{uid} dökümanı
// windowMs: 60000 (1 dakika)
// max: istek tipine göre (prediction: 1/maç, check-in: 1/gün, general: 10/dk)
// Aşımda: HTTP 429 dön, Flutter tarafı "Çok sık deniyorsunuz" gösterir
```

---

## FIRESTORE SECURITY RULES

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Kimlik doğrulama helper
    function isAuth() { return request.auth != null; }
    function isOwner(uid) { return request.auth.uid == uid; }
    function isAdmin() {
      return request.auth.token.admin == true;
    }

    // Maç verileri — herkes okuyabilir, sadece admin yazabilir
    match /matches/{matchId} {
      allow read: if true;
      allow write: if isAdmin();

      match /live/{doc} {
        allow read: if true;
        allow write: if isAdmin();
      }
      match /events/{eventId} {
        allow read: if true;
        allow write: if isAdmin();
      }
    }

    // Haberler — herkes okur
    match /news/{newsId} {
      allow read: if true;
      allow write: if isAdmin();
    }

    // Puan durumu, fikstür — herkes okur
    match /standings/{doc} { allow read: if true; allow write: if isAdmin(); }
    match /fixtures/{doc} { allow read: if true; allow write: if isAdmin(); }
    match /squad/{playerId} { allow read: if true; allow write: if isAdmin(); }

    // Fan profili — sadece kendi profilini okur/yazar
    match /fan_profiles/{uid} {
      allow read: if isAuth() && isOwner(uid);
      allow create: if isAuth() && isOwner(uid);
      allow update: if isAuth() && isOwner(uid)
        && !request.resource.data.diff(resource.data).affectedKeys()
          .hasAny(['fanPoints', 'fanLevel', 'earnedBadgeIds']);
      // fanPoints ve badges sadece Cloud Function (admin SDK) yazabilir
    }

    // Tahminler — kendi tahmini
    match /predictions/{matchId}/user_predictions/{uid} {
      allow read: if isAuth();
      allow create: if isAuth() && isOwner(uid)
        && request.time < get(/databases/$(database)/documents/matches/$(matchId)).data.kickoffTime;
      allow update: if false; // Gönderilen tahmin değiştirilemez
    }

    // Leaderboard — herkes okur
    match /leaderboard/{doc} { allow read: if isAuth(); allow write: if isAdmin(); }
  }
}
```

---

## GENEL KOD KURALLARI — SIKILIKLA UYGULA

### Mimari
- Her feature kendi içinde kapalı: data / domain / presentation
- Repository pattern zorunlu: presentation → usecase → repository → datasource
- Hiçbir widget doğrudan Firestore'a erişemez
- Tüm Firestore çağrıları repository impl içinde

### Hata Yönetimi
- `Either<Failure, T>` dönüş tipi (dartz)
- `Failure` alt sınıfları: NetworkFailure, ServerFailure, CacheFailure, AuthFailure
- Her hata Crashlytics'e raporlanır
- Kullanıcıya lokalize hata mesajı gösterilir

### State Management (Riverpod)
- `AsyncNotifierProvider` → async veri
- `NotifierProvider` → sync state
- `StreamProvider` → Firestore realtime
- `.when(data:, loading:, error:)` her yerde kullan
- Loading state: Shimmer widget
- Error state: retry butonlu ErrorWidget

### Analytics
- Her önemli kullanıcı aksiyonu `AnalyticsService.logEvent()` ile gönderilir
- Ekran geçişlerinde `AnalyticsService.logScreen()` çağrılır
- Asla direkt `FirebaseAnalytics.instance.logEvent()` çağırma

### Performance
- `const` constructor'lar her yerde
- `ListView.builder` / `SliverList` — asla `Column(children: list.map())`
- Görsel: `CachedNetworkImage` ile `placeholder` ve `errorWidget`
- Firestore: pagination (limit 20, startAfterDocument)
- `select()` ile gereksiz rebuild'leri engelle

### Kod Stili
- `very_good_analysis` lint kuralları aktif
- Her public class/method için dartdoc yorum
- Magic number yok: sabitler `AppConstants` veya `AppSpacing`'de
- String literal yok: tümü `tr()` lokalizasyon fonksiyonuyla

---

## BAŞLANGIÇ SIRASI — ADIM ADIM

Claude Code bu sırayla ilerleyecek:

```
Adım 1: pubspec.yaml oluştur, bağımlılıkları ekle
Adım 2: firebase_options.dart (placeholder, gerçek değerler sonra girilecek)
Adım 3: core/theme/ — AppColors, AppTypography, AppSpacing, AppTheme
Adım 4: core/constants/ — AppConstants, FirestorePaths
Adım 5: core/error/ — Failure, ErrorHandler, CrashlyticsReporter
Adım 6: core/audio/ — AudioService, SoundManager, GoalSoundEngine, AudioPreferenceStore
Adım 7: core/notifications/ — tüm dosyalar
Adım 8: core/offline/ — HiveService, SyncQueue, ConnectivityService, CachePolicy
Adım 9: core/security/ ve core/analytics/
Adım 10: core/router/ — AppRouter, RouteNames, RouteGuard
Adım 11: assets/ — klasörler ve placeholder ses dosyaları
Adım 12: assets/translations/ — tr.json, en.json, de.json, ar.json
Adım 13: features/auth/ — tam implementasyon
Adım 14: features/home/ — ekran + tüm widget'lar
Adım 15: features/match_center/ — pre_game, live, post_match
Adım 16: features/news/, fixtures/, standings/, squad/
Adım 17: features/predictions/ ve fan_profile/
Adım 18: shared/widgets/ — tüm paylaşılan bileşenler
Adım 19: main.dart ve app.dart
Adım 20: functions/ — Cloud Functions TypeScript kodu
Adım 21: firestore.rules
Adım 22: flutter pub run build_runner build --delete-conflicting-outputs
```

---

## SON NOTLAR

- Hiçbir dosyayı `// TODO` ile bırakma. Ya tam implementasyonu yaz ya da açıkça belirt.
- Placeholder veri (mock) kabul edilebilir, ancak gerçek veri akışı için altyapı hazır olmalı.
- Her dosya oluşturduktan sonra import'ların doğruluğunu kontrol et.
- `flutter analyze` çıktısı temiz olmalı: sıfır hata, sıfır warning.
- Ses dosyaları ve Lottie JSON'lar placeholder olabilir, ama `pubspec.yaml` assets bildirimi eksiksiz olmalı.
- Firebase bağlantısı için `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) kullanıcı tarafından sağlanacak — bu dosyaların yeri ve nasıl ekleneceğini README.md'ye yaz.
- `README.md` oluştur: kurulum, Firebase bağlantısı, çevre değişkenleri, build talimatları.

---

*Bu prompt ile Claude Code, ARCA Tribün uygulamasının tüm iskeletini, çekirdek sistemlerini ve temel ekranlarını production-ready seviyede oluşturacaktır.*
