# ARCA Tribün Pilot Demo Risk Kontrol Listesi

Bu liste kulüp sunumundan önce uygulanmalıdır. Amaç, 5 dakikalık ürün turunu
öngörülebilir ve kontrollü biçimde tamamlamaktır.

## Simulator ve Build

- [ ] Kullanılacak simulator açılıyor ve yeterli boş alana sahip.
- [ ] Splash, onboarding ve klavye davranışı simulator üzerinde kontrol edildi.
- [ ] İlk açılış gösterilecekse uygulama verisi temizlendi.
- [ ] Profil gösterilecekse onboarding tamamlanmış ve test kullanıcısı giriş
  yapmış durumda.
- [ ] Sunum öncesi son build şu komutla alındı:
  `flutter build ios --simulator --dart-define-from-file=config/supabase.dev.json`

## Config

- [ ] `config/supabase.dev.json` doğru pilot Supabase projesini gösteriyor.
- [ ] `PILOT_DEMO_MODE=true`; home ekranında `PİLOT DEMO` etiketi görünüyor.
- [ ] Mobil build içinde `secret` veya `service_role` key bulunmuyor.
- [ ] `STORE_URL` boşsa bilgi mesajı; doluysa yalnızca doğrulanmış `http/https`
  bağlantısı kullanılıyor.

## Supabase Bağlantısı

- [ ] Sunum yapılacak ağda internet bağlantısı var.
- [ ] Test kullanıcısıyla login başarılı.
- [ ] Profil ekranında kullanıcı adı, e-posta, puan ve seviye okunuyor.
- [ ] Remote içerik durumu sunumdan önce kontrol edildi.
- [ ] Remote'a sunum öncesi plansız migration, RLS veya seed uygulanmadı.

## Remote Veri Boşsa

Remote seed zorunlu değildir. Veri boşsa aşağıdaki ekranlar kontrollü empty
state gösterebilir:

- [ ] Home haber alanı
- [ ] Yaklaşan maç alanı
- [ ] Haberler
- [ ] Fikstür
- [ ] Puan durumu
- [ ] Kadro ve oyuncu detayı
- [ ] Maç merkezi

**Anlatım cümlesi:**

> Pilot sürüm doğrulanmamış veya sahte veri göstermiyor. Yönetilen içerikler ve
> doğrulanmış veri kaynağı bağlandığında bu alanlar gerçek içerikle dolacak.

## İnternet Yoksa

- [ ] Sunum mekânının Wi-Fi bağlantısı test edildi.
- [ ] Gerekirse telefon hotspot'u hazır.
- [ ] Uygulamadaki offline banner davranışı kontrol edildi.
- [ ] Offline durumda yeni login ve remote veri okuma adımlarına güvenilmiyor.

**Fallback anlatımı:**

> Şu anda ağ bağlantısı sınırlı. Uygulama offline durumu kullanıcıya bildiriyor.
> Veri akışını hazırlanan ekran görüntüleri üzerinden göstereceğim.

## Login Çalışmazsa

- [ ] Test kullanıcısının e-posta ve şifresi sunum öncesi doğrulandı.
- [ ] Şifre yöneticisi veya güvenli not üzerinden giriş bilgilerine erişilebiliyor.
- [ ] Login başarısız olursa önceden giriş yapılmış ikinci simulator hazır.
- [ ] Yedek olarak profil ve home ekran görüntüleri hazır.

**Fallback anlatımı:**

> Giriş servisine erişimde anlık ağ sorunu var. Hesap sonrası deneyimi hazır
> ekran görüntüleriyle göstereceğim.

## Görseller ve Marka

- [ ] Onboarding görsellerinin sunum kullanım izni kontrol edildi.
- [ ] Oyuncu, tribün, logo ve sponsor görsellerinin kullanım kapsamı not edildi.
- [ ] Uygulama hiçbir ekranda kulüp tarafından onaylanmış bir ürün gibi
  tanıtılmıyor.
- [ ] About diyaloğundaki pilot/prototip uyarısı görünüyor.
- [ ] Sunumda uygulamanın kulüp onayı gerektirdiği açıkça belirtiliyor.

## Teknik Son Kontrol

- [ ] `flutter analyze --no-fatal-infos`
- [ ] `flutter test`
- [ ] `flutter build ios --simulator --dart-define-from-file=config/supabase.dev.json`
- [ ] [Demo turu](demo_tour_script.md) bir kez kronometreyle prova edildi.
- [ ] [Screenshot listesi](screenshots_checklist.md) üzerinden yedek görseller
  hazırlandı.

## Go / No-Go

Sunuma başlamadan önce şu üç koşul sağlanmalıdır:

- [ ] Uygulama simulator üzerinde açılıyor.
- [ ] Pilot/prototip konumlandırması görünür.
- [ ] Login veya yedek ekran görüntüsü akışı hazır.
