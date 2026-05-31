# ARCA TRİBÜN 5 Dakikalık Pilot Veri Turu

Bu akış kulüp sunumunda ürün değerini kısa ve net biçimde anlatmak için
hazırlanmıştır. Teknik mimari yalnızca soru gelirse açılmalıdır.

## Sunum Öncesi

- Test kullanıcısıyla giriş yapılabildiğini doğrulayın.
- `PILOT_DEMO_MODE=true` olan geliştirme build'ini kullanın.
- Remote veri boşsa boş durum mesajlarını ürünün kontrollü pilot davranışı
  olarak anlatın.
- İlk açılış akışını göstermek için simulator verisini temizleyin veya ayrı
  temiz simulator kullanın.

## 0:00 - 0:30 | Onboarding

**Ekran:** Splash ve onboarding sayfaları 1-4.

**Söylenecekler:**

> ARCA TRİBÜN, taraftarın kulüple dijital bağını güçlendirmek için hazırlanan
> bir pilot çalışmadır. İlk açılışta taraftarı haber, maç günü ve tribün
> deneyimi etrafında karşılayan kısa bir akış sunuyoruz.

**Vurgulanacak değer:** Marka hissi, taraftar aidiyeti ve profesyonel ilk
izlenim.

## 0:30 - 0:55 | Login ve Register

**Ekran:** Login, ardından Register ekranı kısa biçimde gösterilir.

**Söylenecekler:**

> Taraftar e-posta ve şifreyle hesabını oluşturabiliyor. Pilot kapsamda sade
> ve güvenli bir giriş akışı var. Sosyal giriş seçenekleri hazır olduklarında
> ayrıca etkinleştirilebilir.

**Vurgulanacak değer:** Taraftar profilini ve gelecekteki kişiselleştirmeyi
taşıyacak hesap altyapısı.

## 0:55 - 1:40 | Home

**Ekran:** Home üst alanı, `PİLOT VERİ` etiketi, yaklaşan maç ve içerik alanları.

**Söylenecekler:**

> Ana ekran taraftarın günlük başlangıç noktası. Yaklaşan karşılaşmalar,
> haberler, lig görünümü ve mağaza yönlendirmesi tek yerde toplanıyor. Pilot
> etiketi sunum sürümünü açıkça ayırıyor; production kullanımında gizleniyor.

**Remote veri boşsa:**

> İçerik yokken sahte veri göstermiyoruz. Yönetilen içerikler eklendiğinde bu
> alanlar gerçek verilerle dolacak şekilde hazır.

**Vurgulanacak değer:** Tek ekrandan erişim, kontrollü içerik yönetimi ve
sponsor görünürlüğü için temel alanlar.

## 1:40 - 2:10 | Haberler

**Ekran:** Haber listesi ve varsa haber detayı.

**Söylenecekler:**

> Haber alanı, taraftarı doğrulanmış kulüp gündemiyle uygulamada tutmak için
> tasarlandı. İçerikler yayınlandığında tarih sırasıyla listeleniyor; henüz
> içerik yoksa profesyonel bir bekleme durumu gösteriliyor.

**Vurgulanacak değer:** Taraftar iletişiminin tek kanalda düzenli sunulması.

## 2:10 - 2:35 | Fikstür

**Ekran:** Fikstür ekranı.

**Söylenecekler:**

> Taraftar yaklaşan ve geçmiş maçlara fikstür alanından erişebiliyor. Maç
> verileri doğrulandığında burada yayınlanacak.

**Vurgulanacak değer:** Maç günü öncesi geri dönüş alışkanlığı.

## 2:35 - 2:55 | Puan Durumu

**Ekran:** Puan durumu ekranı.

**Söylenecekler:**

> Lig tablosu, taraftarın sezonu uygulama içinde takip etmesini sağlıyor.
> Veri kaynağı hazır olduğunda sıralama doğrudan güncel tabloyla beslenecek.

**Vurgulanacak değer:** Uygulama içi takip süresini artıran temel spor verisi.

## 2:55 - 3:25 | Kadro ve Oyuncu Detayı

**Ekran:** Kadro listesi ve bir oyuncu detayı.

**Söylenecekler:**

> Kadro alanı oyuncuları tanımayı ve takım bağını güçlendirmeyi hedefliyor.
> Oyuncu detayları içerik üretimi ve gelecekteki sponsor alanları için
> genişletilebilir.

**Vurgulanacak değer:** Oyuncu odaklı içerik ve taraftar etkileşimi.

## 3:25 - 4:05 | Maç Merkezi

**Ekran:** Maç merkezi; veri varsa canlı olaylar, yoksa kontrollü empty state.

**Söylenecekler:**

> Maç merkezi, karşılaşma öncesi bilgileri, canlı gelişmeleri ve maç sonrası
> özeti aynı akışta birleştirecek çekirdek alan. Pilot sürüm doğrulanmamış
> skor veya performans verisi üretmiyor.

**Vurgulanacak değer:** Maç günü etkileşiminin ana merkezi.

## 4:05 - 4:35 | Profil ve About

**Ekran:** Profil, gerçek kullanıcı bilgileri ve Uygulama Hakkında diyaloğu.

**Söylenecekler:**

> Profil alanı gerçek taraftar hesabına bağlı. Kullanıcı adı, puan ve seviye
> bilgileri burada taşınıyor. Uygulama Hakkında alanında pilot kapsamı ve
> kulüp onayı gereksinimi açıkça belirtiliyor.

**Vurgulanacak değer:** Gelecekteki sadakat programı için kullanıcı temeli ve
şeffaf pilot konumlandırması.

## 4:35 - 5:00 | Mağaza ve Kontrollü Empty State

**Ekran:** Home mağaza kartı ve boş veri gösteren bir MVP ekranı.

**Söylenecekler:**

> Mağaza bağlantısı yalnızca doğrulanmış URL tanımlandığında harici tarayıcıda
> açılıyor. Bağlantı yoksa kullanıcı boş bir tıklamayla karşılaşmıyor. Aynı
> yaklaşım boş veri ekranlarında da uygulanıyor: sistem sahte içerik yerine
> kontrollü ve açıklayıcı durum gösteriyor.

**Kapanış:**

> Bu pilot; içerik, maç günü deneyimi, taraftar profili ve ticari
> yönlendirmeleri tek mobil merkezde birleştirmenin çalışan temelini sunuyor.
> Kulüp onayı ve doğrulanmış veri kaynaklarıyla üretim kapsamı planlanabilir.

## Soru Gelirse Kısa Yanıtlar

| Soru | Kısa yanıt |
| --- | --- |
| Bu uygulama yayında mı? | Hayır. Kulüp onayı gerektiren pilot/prototip çalışmadır. |
| Veriler nereden geliyor? | Pilot altyapı Supabase üzerinden gerçek tablo verisi okuyor. Production veri kaynağı kulüple birlikte netleştirilmeli. |
| Maçlar canlı güncellenebilir mi? | Maç merkezi buna uygun hazırlanmıştır; production spor veri sağlayıcısı ayrıca seçilmelidir. |
| Taraftar puanları aktif mi? | Profil temeli hazırdır. Puan kuralları ve ödül modeli kulüple birlikte belirlenmelidir. |
| Bilet entegrasyonu var mı? | Henüz yok. Doğrulanmış bağlantı veya sağlayıcı seçildikten sonra planlanmalıdır. |
