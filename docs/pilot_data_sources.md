# ARCA TRİBÜN Pilot Veri Kaynakları

Bu doküman pilot sunumda kullanılan doğrulanmış veri kaynaklarını ve görsel
kullanım sınırlarını kayıt altına alır. Remote production projesine otomatik
seed uygulanmaz.

## Trendyol 1. Lig 2025/26 Final Puan Durumu

- TFF sezon cetveli:
  [tff.org](https://www.tff.org/Default.aspx?hafta=38&pageID=142)
- Karşılaştırmalı final tablo:
  [Mackolik](https://www.mackolik.com/puan-durumu/trendyol-1-lig/2o9svokc5s7diish3ycrzk7jm)
- Karşılaştırmalı beIN Sports görünümü:
  [beIN Sports](https://beinsports.com.tr/takim/bsb-erzurumspor/puan-durumu)

Pilot seed, 38 maçlık final tabloyu içerir. Adana Demirspor'un doğrulanmış
ceza puanı nedeniyle final puanı `-57` olarak saklanır.

## Play-Off Finali

- Final sonucu ve maç bağlamı:
  [DHA](https://www.dha.com.tr/yerel-haberler/konya/esenler-erokspor-corum-fk-0-2-2879801)
- Karşılaştırmalı maç akışı:
  [Sahadan](https://www.sahadan.com/ekranlar/mac-merkezi/mac-detay?matchId=4476455)

Guélor Kanga'nın kırmızı kart dakikası bazı haber özetlerinde `90+3`, maç
akışı kaynaklarında `90+2` görünür. Pilot veri, maç akışıyla uyumlu `90+2`
değerini kullanır.

## Kadro ve Görseller

- A takım kadrosu:
  [Çorum FK resmi futbol sayfası](https://corumfk.com.tr/futbol)

Harici oyuncu fotoğrafları hotlink edilmez ve otomatik indirilmez. Yeniden
kullanım izni açıkça verilmiş veya kullanıcı tarafından sağlanmış yerel asset
varsa kullanılabilir. Diğer oyuncular kulüp arması, forma numarası ve initials
içeren yerel placeholder ile gösterilir.

## Çorum Şehir Stadyumu

- Resmi stat detayları:
  [TFF Stat Arama Detay](https://www.tff.org/Default.aspx?pageId=394&stadId=6898)
- Koordinat karşılaştırması:
  [KÜRE Ansiklopedi](https://kureansiklopedi.com/en/detay/corum-city-stadium-268a8)

Pilot kartta TFF verileri kullanılır: `15.000` kapasite, `Çim` zemin ve
`105x68` oyun alanı. Koordinatlar yalnızca hava durumu sorgusu içindir.

## Hava Durumu

- API sözleşmesi:
  [Open-Meteo Forecast API](https://open-meteo.com/en/docs)

Open-Meteo API key gerektirmeden güncel sıcaklık, WMO hava kodu ve 10 metre
rüzgar hızını döndürür. Ağ veya servis hatasında uygulama kırılmaz; kartta
kontrollü fallback mesajı gösterilir.
