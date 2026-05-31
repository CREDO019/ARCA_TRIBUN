# Geliştirme Ortamı Kurulumu

## Gereksinimler

- Flutter SDK
- Xcode ve iOS Simulator
- Android Studio veya Android SDK
- Yerel geliştirme için Supabase proje URL'si ve publishable key

## Başlangıç

```sh
flutter pub get
cp config/supabase.dev.example.json config/supabase.dev.json
```

Yerel config dosyasını düzenleyin:

```json
{
  "SUPABASE_URL": "https://your-project-ref.supabase.co",
  "SUPABASE_PUBLISHABLE_KEY": "sb_publishable_your_key",
  "PILOT_DEMO_MODE": true
}
```

`config/supabase.dev.json` git'e eklenmez. Mobil uygulamaya `secret` veya
`service_role` key koymayın.

## Çalıştırma

```sh
flutter run --dart-define-from-file=config/supabase.dev.json
```

## Kalite Kontrolleri

```sh
flutter analyze --no-fatal-infos
flutter test
flutter build ios --simulator \
  --dart-define-from-file=config/supabase.dev.json
```

## Supabase Migration Yönetimi

```sh
npx supabase login
npx supabase link --project-ref <project-ref>
npx supabase migration list
```

Migration ve seed dosyalarını remote ortama uygulamadan önce hedef projeyi,
RLS politikalarını ve asset yollarını manuel olarak doğrulayın.

## Pilot Seed

- Yerel geliştirme: `supabase/seed.sql`
- Kontrollü pilot ortam: `supabase/pilot_seed.sql`

Pilot seed production ortamına otomatik basılmaz.
