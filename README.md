# ARCA TRİBÜN

ARCA TRİBÜN, Arca Çorum FK için geliştirilen dijital taraftar platformu
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
- Kullanıcı hesabı doğrulanmış Edge Function üzerinden kalıcı olarak silinebilir.
- Taraftar profili gerçek `fan_profiles` tablosundan okunmaktadır.
- Haber, fikstür, puan durumu, kadro ve maç merkezi ekranları repository
  katmanı üzerinden Supabase verisi okumaktadır.
- Remote veri boş olduğunda pilot sunuma uygun boş durum mesajları gösterilir.
- Google, Apple ve misafir girişleri yapılandırılana kadar bilgi durumundadır.

## Current MVP Scope

- Splash ve dört sayfalı onboarding
- E-posta ve şifre ile kayıt, giriş, şifre sıfırlama ve çıkış
- Home, haberler, fikstür, puan durumu, kadro ve maç merkezi
- Gerçek Supabase verisine bağlı taraftar profili
- Pilot bilgi alanı ve güvenli mağaza yönlendirmesi
- Remote veri boş olduğunda profesyonel loading, empty ve error durumları

## Not Included Yet

- Resmi kulüp onayı
- Bilet entegrasyonu
- Production push notification sistemi
- Admin panel
- Google ve Apple OAuth
- Gerçek maç veri sağlayıcısı
- Global leaderboard

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

Yerel geliştirme verisi `supabase/seed.sql` içindedir. Remote pilot proje için
aynı doğrulanmış kayıtlar `supabase/pilot_seed.sql` dosyasından yalnızca hedef
proje kontrol edildikten sonra manuel olarak çalıştırılmalıdır.

## İçerik Kaynakları ve Görsel İzinleri

- A takım kadrosu resmi kulüp sayfası ve TFF listesiyle doğrulanır:
  [corumfk.com.tr/futbol](https://corumfk.com.tr/futbol).
- Resmi kulüp sitesinde oyuncu fotoğrafları yer alsa da yeniden kullanım izni
  ayrıca netleştirilmeden uygulama paketine alınmaz.
- Oyuncu kartları bu nedenle kulüp arması ve forma numarasından oluşan yerel
  placeholder kullanır. Haber görseli de telifli ajans fotoğrafı yerine uygulama
  içinde çizilen kırmızı-siyah yükseliş grafiğidir.

Hesap silme akışının güvenlik sınırı ve deploy adımları:
[docs/account_deletion.md](docs/account_deletion.md)

## Pilot Tur

Kulüp sunumu için hazırlanan 5 dakikalık ürün turu:
[docs/demo_tour_script.md](docs/demo_tour_script.md)

Sunum öncesi operasyon kontrolleri:
[docs/demo_risk_checklist.md](docs/demo_risk_checklist.md)

Yedek görsel paket hazırlığı:
[docs/screenshots_checklist.md](docs/screenshots_checklist.md)

## Pilot Safety

- Mobil istemciye `secret` veya `service_role` key eklenmemelidir.
- Remote ortama plansız migration, RLS değişikliği veya seed uygulanmamalıdır.
- Mağaza ve gelecekteki bilet bağlantıları doğrulanmış URL olmadan
  etkinleştirilmemelidir.
- Doğrulanmamış maç verisi veya sahte içerik sunum için kullanılmamalıdır.

## Audio Pilot Notu

`assets/sounds` altındaki ses yolları pilot altyapı için korunmaktadır. Onaylı
ses dosyaları eklenene kadar 0-byte placeholder asset'ler oynatılmaz; ses
katmanı kullanıcı akışını bozmadan sessizce devam eder.

Ses servisi pilot build'de uygulama başlangıcına bağlanmamıştır. Onaylı ses
asset'leri ve ürün kararı tamamlandıktan sonra açıkça etkinleştirilmelidir.

## Brand Disclaimer

ARCA TRİBÜN bir dijital taraftar platformu pilot çalışmasıdır. Kulüp onayı
sonrası resmi kullanıma uygun hale getirilebilir. Mağaza, bilet ve üçüncü
taraf bağlantıları yalnızca doğrulanmış URL'lerle etkinleştirilmelidir.

> Bu uygulama pilot/prototip çalışmadır. Resmi kullanım için kulüp onayı
> gerektirir.

## Pilot Kontrol Listesi

Kulüp sunumu öncesi kontrol adımları için:
[docs/demo_checklist.md](docs/demo_checklist.md)
