# ARCA TRİBÜN Pilot Veri Kontrol Listesi

Bu liste kulüp sunumu öncesinde cihaz üzerinde sırayla uygulanmalıdır.

## Ortam

- [ ] `PILOT_DEMO_MODE=true` ile pilot etiketi görünür.
- [ ] Kullanılan build production secret veya `service_role` key içermiyor.
- [ ] Remote ortamda gösterilecek içerikler doğrulandı.

## İlk Açılış ve Auth

- [ ] Temiz kurulumda splash sonrası onboarding açılıyor.
- [ ] Onboarding sayfaları swipe ve Devam Et ile ilerliyor.
- [ ] Atla ve son sayfadaki Giriş Yap login ekranına yönlendiriyor.
- [ ] Uygulama yeniden açıldığında onboarding tekrar gösterilmiyor.
- [ ] Yeni kullanıcı e-posta ve şifre ile kayıt olabiliyor.
- [ ] Mevcut kullanıcı e-posta ve şifre ile giriş yapabiliyor.
- [ ] Hatalı şifre kullanıcı dostu mesaj gösteriyor.
- [ ] Şifremi Unuttum isteği kullanıcı dostu sonuç veriyor.
- [ ] Çıkış Yap login ekranına yönlendiriyor.

## Profil

- [ ] Profil ekranında kullanıcı adı, e-posta, puan ve seviye görünüyor.
- [ ] Kullanıcı adı güncellemesi profil ekranına yansıyor.
- [ ] Uygulama Hakkında alanında pilot açıklaması ve sürüm görünüyor.
- [ ] Hesabı Sil diyaloğu geri alınamaz işlem uyarısını gösteriyor.
- [ ] Test hesabı silindiğinde oturum kapanıyor ve tekrar giriş başarısız oluyor.

## MVP Ekranları

- [ ] Home üst alanı ve Pilot Veri etiketi düzgün görünüyor.
- [ ] Haberler dolu veya profesyonel boş state gösteriyor.
- [ ] Fikstür dolu veya profesyonel boş state gösteriyor.
- [ ] Puan durumu dolu veya profesyonel boş state gösteriyor.
- [ ] Kadro dolu veya profesyonel boş state gösteriyor.
- [ ] Maç merkezi dolu veya profesyonel boş state gösteriyor.
- [ ] Taraftar tahmini gerçek veri akışı yokken bekleme durumunda kalıyor.

## Harici Bağlantılar

- [ ] Mağaza URL'si yoksa bilgi mesajı gösteriliyor.
- [ ] Mağaza URL'si varsa yalnızca doğrulanmış bağlantı harici tarayıcıda açılıyor.
- [ ] Bilet bağlantısı eklenirse aynı güvenlik kontrolü uygulanıyor.

## Teknik Kontrol

- [ ] `flutter analyze --no-fatal-infos`
- [ ] `flutter test`
- [ ] `flutter build ios --simulator --dart-define-from-file=config/supabase.dev.json`
