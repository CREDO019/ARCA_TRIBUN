# Supabase Şema Dokümantasyonu

Kaynak migration:
[`001_initial_mvp_schema.sql`](../supabase/migrations/001_initial_mvp_schema.sql)

## Tablolar

| Tablo | Amaç | Ana kolonlar | İlişkiler | RLS durumu |
| --- | --- | --- | --- | --- |
| `news` | Yayınlanabilir haber içerikleri | `title`, `summary`, `content`, `image_url`, `status`, `published_at` | Yok | Açık. `anon` ve `authenticated` yalnızca `published` kayıtları okuyabilir. |
| `matches` | Fikstür ve maç durumu kaydı | `home_team`, `away_team`, `match_date`, `status`, skor ve dakika alanları | `match_events`, `user_predictions` tarafından referans edilir | Açık. Okuma herkese açık; istemci yazma izni yok. |
| `match_events` | Maç akışı olayları | `match_id`, `minute`, `event_type`, `team`, `player_name` | `match_id -> matches.id`, silmede cascade | Açık. Okuma herkese açık; istemci yazma izni yok. |
| `standings` | Sezon puan durumu | `season`, `team_name`, `position`, maç ve puan alanları | Yok | Açık. Okuma herkese açık; istemci yazma izni yok. |
| `squad` | A takım oyuncuları | `name`, `number`, `position`, `nationality`, `image_url`, `status` | Yok | Açık. Yalnızca `active` oyuncular okunabilir. |
| `fan_profiles` | Kullanıcı taraftar profili | `id`, `display_name`, `avatar_url`, `points`, `level` | `id -> auth.users.id`, silmede cascade | Açık. Kullanıcı yalnızca kendi profilini okuyabilir ve güncelleyebilir. |
| `user_predictions` | Kullanıcı skor tahminleri | `user_id`, `match_id`, skorlar, `points_awarded`, `locked` | `user_id -> auth.users.id`, `match_id -> matches.id` | Açık. Kullanıcı yalnızca kendi kaydını okuyabilir; yalnızca kilitsiz gelecek maç tahmini yazılabilir. |
| `user_devices` | Bildirim cihaz kayıtları | `user_id`, `device_token`, `platform`, `notification_enabled` | `user_id -> auth.users.id`, silmede cascade | Açık. Kullanıcı yalnızca kendi cihaz kayıtlarını yönetebilir. |

## View'lar

| View | Amaç | Güvenlik notu |
| --- | --- | --- |
| `fixtures` | `matches` tablosu için geçici uyumluluk görünümü | `security_invoker = true` |
| `live_match_state` | Canlı maç state sözleşmesi | `security_invoker = true` |
| `leaderboard` | Profil puanlarından sıralama görünümü | Global leaderboard değildir; çağıranın `fan_profiles` RLS kapsamını miras alır. |

## Fonksiyonlar

| Fonksiyon | Amaç |
| --- | --- |
| `handle_new_user()` | Yeni Auth kullanıcısı için `fan_profiles` kaydı oluşturur. |
| `set_updated_at()` | Güncellenen tablolarda `updated_at` değerini yeniler. |

## Migration Notu

[`005_allow_negative_standings_points.sql`](../supabase/migrations/005_allow_negative_standings_points.sql),
doğrulanmış ceza puanı senaryoları için `standings.points` alanındaki pozitif
değer kısıtını kaldırır.

## Güvenlik Sınırı

- Mobil istemci yalnızca publishable key kullanır.
- `service_role` yetkileri migration içinde tanımlıdır ancak mobil pakete
  eklenmez.
- Remote migration ve seed işlemleri hedef proje kontrol edilmeden otomatik
  uygulanmaz.
