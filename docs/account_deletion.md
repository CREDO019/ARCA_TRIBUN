# Hesap Silme Akışı

Mobil istemci yalnızca oturum açmış kullanıcının JWT değeriyle
`delete-account` Edge Function çağrısı yapar. Mobil uygulamada `service_role`
anahtarı bulunmaz.

Edge Function:

1. İsteğin `POST` olduğunu doğrular.
2. JWT ile kullanıcıyı Supabase Auth üzerinden tekrar doğrular.
3. İstemciden kullanıcı kimliği kabul etmeden doğrulanan hesabı siler.
4. `fan_profiles`, `user_predictions` ve `user_devices` kayıtlarını mevcut
   `ON DELETE CASCADE` ilişkileriyle temizler.

Remote ortama dağıtım:

```sh
npx supabase functions deploy delete-account
```

Pilot cihaz testinde yeni bir test hesabı oluşturulmalı, silme diyaloğu
onaylanmalı ve aynı bilgilerle tekrar girişin başarısız olduğu doğrulanmalıdır.
