# Katkı Rehberi

ARCA TRİBÜN bağımsız bir portföy/pilot çalışmasıdır. Katkı göndermeden önce
ürünün resmi kulüp uygulaması olmadığını ve üçüncü taraf asset sınırlarını
dikkate alın.

## Geliştirme Akışı

1. Küçük ve tek amaçlı branch oluşturun.
2. Secret içeren config dosyalarını commit etmeyin.
3. UI değişikliğinde açık ve koyu temayı kontrol edin.
4. Yeni davranış için hedefli test ekleyin.
5. Migration değişikliğinde RLS etkisini belgeleyin.

## Kalite Kontrolleri

```sh
flutter analyze --no-fatal-infos
flutter test
flutter build ios --simulator \
  --dart-define-from-file=config/supabase.dev.json
```

## Asset Politikası

- Harici oyuncu fotoğrafı hotlink edilmez.
- Otomatik scraping yapılmaz.
- Görsel yalnızca izin kapsamı doğrulandıktan sonra local asset olarak eklenir.
- Kulüp markaları ve oyuncu fotoğrafları kaynak kod lisansının parçası değildir.

## Pull Request İçeriği

- Değişikliğin amacı
- Etkilenen ekran veya veri sözleşmesi
- Çalıştırılan testler
- Kalan riskler
- UI değişikliği varsa gerçek uygulama ekran görüntüsü
