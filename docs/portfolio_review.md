# ARCA TRİBÜN Portföy Denetimi

## Güçlü Yönler

- Ürün problemi net: maç günü bilgi yoğunluğunu tek hero modülünde topluyor.
- Flutter feature klasörleri okunabilir ve repository/provider ayrımı var.
- Supabase migration, RLS ve Edge Function sınırları repository içinde.
- Açık/koyu tema ve kalıcı tema tercihi tamamlanmış.
- Offline ve servis hataları kontrollü fallback davranışına dönüşüyor.
- Oyuncu fotoğrafları hotlink yerine local asset olarak paketleniyor.
- Hedefli widget ve repository testleri temel kullanıcı risklerini kapsıyor.

## Eksik Yönler

- Gerçek uygulama screenshot paketi yok.
- CI pipeline yok.
- Android release build doğrulaması raporlanmıyor.
- Integration veya end-to-end test yok.
- Remote Supabase deploy kanıtı ve environment matrisi yok.
- Production gözlemlenebilirlik dashboard'u yok.
- Beş ses asset'i 0-byte placeholder; ürün kararı bekliyor.
- Global leaderboard read model veya RPC henüz tasarlanmadı.
- Üçüncü taraf görsel izinleri resmi yayın öncesinde ayrıca doğrulanmalı.

## İlk İzlenim

### LinkedIn Ziyaretçisi

Ürün fikri anlaşılır ve görsel anlatım potansiyeli yüksek. Screenshot eksikliği
ilk etkiyi ciddi biçimde düşürür. README artık teknik derinliği gösterir ancak
paylaşım öncesi en az üç gerçek ekran görüntüsü gerekir.

### İşveren

Repository junior seviyenin üzerinde: state management, repository katmanı,
RLS, Edge Function, offline fallback ve test farkındalığı görülüyor. Eksik CI,
integration test ve release otomasyonu nedeniyle production olgunluğu henüz
kanıtlanmış değil.

### CTO

Kod tabanı pilot için makul, production için eksik. En kritik boşluklar:
tekrarlanabilir CI, environment yönetimi, uçtan uca test, gözlemlenebilirlik,
veri kaynağı SLA'sı ve görsel haklarının yazılı doğrulanması.

## Seviye Değerlendirmesi

Bu repository **mid-level Flutter geliştirici** portföyüne daha yakındır.
Junior seviyeyi aşan noktalar katmanlı yapı, backend güvenlik farkındalığı,
offline davranış ve test disiplinidir. Senior seviyeye geçiş için production
operasyonu ve otomasyon kanıtı gerekir.

## LinkedIn İçin En Güçlü 10 Teknik Özellik

1. Flutter ve Riverpod tabanlı feature odaklı mimari
2. Supabase Auth ve PostgreSQL entegrasyonu
3. Row Level Security politika seti
4. Edge Function üzerinden güvenli hesap silme akışı
5. Gerçek zamanlı Matchday Assistant geri sayımı
6. Open-Meteo entegrasyonu ve offline fallback
7. Local asset oyuncu fotoğrafları ve premium placeholder
8. Sistem, açık ve koyu tema ile kalıcı tercih
9. Maç önü, canlı ve maç sonu merkez akışları
10. Widget, repository ve asset decode testleri

## En Etkileyici 5 Mühendislik Kararı

1. Mobil istemciye `service_role` anahtarı koymamak
2. Üçüncü taraf oyuncu fotoğraflarını hotlink etmemek
3. UI katmanını repository/provider sınırlarıyla backend'den ayırmak
4. Ağ hatalarını crash yerine kontrollü kullanıcı mesajına dönüştürmek
5. Pilot fallback verisini açıkça etiketlemek ve production verisi gibi
   sunmamak

## En Güçlü 3 Ekran

1. **Maç Günü Asistanı:** ürün değerini tek bakışta gösterir.
2. **Kadro:** local fotoğraf, fallback ve kart kalitesini gösterir.
3. **Maç Merkezi:** durum tabanlı UI tasarımını gösterir.

## Puanlama

| Alan | Puan |
| --- | ---: |
| Genel | 76 / 100 |
| Teknik | 81 / 100 |
| UI/UX | 74 / 100 |
| Mimari | 79 / 100 |
| Güvenlik | 80 / 100 |
| Portföy değeri | 72 / 100 |

Screenshot paketi, CI ve integration test tamamlandığında portföy değeri
belirgin biçimde yükselir.
