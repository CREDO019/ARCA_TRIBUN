# ARCA TRİBÜN Mimari Yapısı

## Katmanlar

```mermaid
flowchart TB
  subgraph UI["UI Layer"]
    Screens["Feature Screens"]
    Widgets["Shared Widgets"]
    Theme["Light / Dark Theme"]
  end

  subgraph Providers["Provider Layer"]
    AuthProvider["Auth Provider"]
    MatchProvider["Match Provider"]
    ContentProviders["News / Squad / Standings Providers"]
    WeatherProvider["Weather Provider"]
    ThemeProvider["Theme Preference Provider"]
  end

  subgraph Repositories["Repository Layer"]
    AuthRepository["Auth Repository"]
    MatchRepository["Match Repository"]
    ContentRepositories["News / Squad / Standings Repositories"]
    WeatherRepository["Weather Repository"]
  end

  subgraph Backend["Supabase Layer"]
    Auth["Supabase Auth"]
    Postgres["PostgreSQL + RLS"]
    Edge["delete-account Edge Function"]
  end

  subgraph Local["Local Layer"]
    Hive["Hive Cache"]
    Preferences["SharedPreferences"]
    Secure["Secure Storage"]
    Assets["Bundled Local Assets"]
  end

  subgraph External["External Services"]
    OpenMeteo["Open-Meteo"]
    Maps["Google Maps"]
  end

  Screens --> AuthProvider
  Screens --> MatchProvider
  Screens --> ContentProviders
  Screens --> WeatherProvider
  Screens --> ThemeProvider
  Widgets --> Assets
  AuthProvider --> AuthRepository
  MatchProvider --> MatchRepository
  ContentProviders --> ContentRepositories
  WeatherProvider --> WeatherRepository
  AuthRepository --> Auth
  AuthRepository --> Edge
  MatchRepository --> Postgres
  ContentRepositories --> Postgres
  WeatherRepository --> OpenMeteo
  ThemeProvider --> Preferences
  Repositories --> Hive
  AuthRepository --> Secure
  Screens --> Maps
```

## Sorumluluk Dağılımı

| Katman | Sorumluluk |
| --- | --- |
| UI | Ekranlar, tema uyumu, loading/empty/error durumları |
| Provider | Riverpod üzerinden state üretimi ve bağımlılık bağlantısı |
| Repository | Supabase sorguları, fallback ve veri dönüşümü |
| Supabase | Auth, PostgreSQL, RLS, view ve Edge Function sözleşmeleri |
| Local | Cache, tercih, secure storage ve paketlenmiş asset yönetimi |

## Önemli Kararlar

- UI doğrudan Supabase istemcisine bağlanmaz; repository katmanı kullanılır.
- Pilot fallback verisi production davranışının yerine geçmez; yalnızca kontrollü
  demo modunda devreye girer.
- Oyuncu fotoğrafları çalışma anında dış URL üzerinden çekilmez.
- `service_role` anahtarı mobil istemciye girmez; hesap silme işlemi Edge
  Function sınırında yürütülür.
- Hava durumu ve bağlantı hataları kullanıcı akışını kırmadan fallback mesajına
  dönüşür.
