# ARCA Tribün

ARCA Tribün, Arca Çorum FK için geliştirilen dijital taraftar platformu
konseptidir. Mobil uygulama; haberler, fikstür, puan durumu, kadro, maç
merkezi ve taraftar profili akışlarını tek bir deneyimde birleştirmeyi
amaçlar.

> Bu uygulama pilot/prototip çalışmadır. Resmi kullanım için kulüp onayı
> gerektirir.

## Teknoloji

- Flutter
- Riverpod
- go_router
- Supabase Auth
- Supabase PostgreSQL ve Row Level Security
- Supabase Realtime
- SharedPreferences

## Mevcut Durum

- İlk açılış onboarding akışı hazırdır.
- E-posta ve şifre ile kayıt, giriş ve çıkış akışları çalışmaktadır.
- Taraftar profili gerçek `fan_profiles` tablosundan okunmaktadır.
- Haber, fikstür, puan durumu, kadro ve maç merkezi ekranları repository
  katmanı üzerinden Supabase verisi okumaktadır.
- Remote veri boş olduğunda pilot sunuma uygun boş durum mesajları gösterilir.
- Google, Apple ve misafir girişleri yapılandırılana kadar bilgi durumundadır.

## Kurulum

Yerel çalışma zamanı ayarlarını oluşturun:

```sh
cp config/supabase.dev.example.json config/supabase.dev.json
```

`config/supabase.dev.json` içine Supabase Project URL ve publishable key
değerlerini ekleyin. Mobil istemciye `secret` veya `service_role` key
eklemeyin.

Bağımlılıkları yükleyin:

```sh
flutter pub get
```

Uygulamayı geliştirme ayarlarıyla başlatın:

```sh
flutter run --dart-define-from-file=config/supabase.dev.json
```

Pilot etiketi geliştirme ortamında aşağıdaki ayarla açılabilir:

```json
{
  "PILOT_DEMO_MODE": true
}
```

Production build'lerinde bu değer kaldırılmalı veya `false` yapılmalıdır.

## Supabase

Remote Supabase projesiyle migration yönetimi:

```sh
npx supabase login
npx supabase link --project-ref <project-ref>
npx supabase migration list
```

Migration ve RLS değişiklikleri kod incelemesi olmadan remote ortama
uygulanmamalıdır. Seed verileri production ortamına otomatik basılmamalıdır.

## Marka ve Güvenlik Notu

ARCA Tribün bir dijital taraftar platformu pilot çalışmasıdır. Kulüp onayı
sonrası resmi kullanıma uygun hale getirilebilir. Mağaza, bilet ve üçüncü
taraf bağlantıları yalnızca doğrulanmış URL'lerle etkinleştirilmelidir.

## Demo Kontrol Listesi

Kulüp sunumu öncesi kontrol adımları için:
[docs/demo_checklist.md](docs/demo_checklist.md)
