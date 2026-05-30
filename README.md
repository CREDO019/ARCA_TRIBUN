# ARCA Tribun

Arca Corum FK taraftar platformu.

## Supabase

Yerel gelistirme ayarlarini olusturun:

```sh
cp config/supabase.dev.example.json config/supabase.dev.json
```

Ardindan `config/supabase.dev.json` icine Supabase Project URL ve publishable
key degerlerini ekleyin. Mobil istemciye `secret` veya `service_role` key
eklemeyin.

Uygulamayi gelistirme ayarlariyla baslatin:

```sh
flutter run --dart-define-from-file=config/supabase.dev.json
```

Remote Supabase projesiyle migration yonetimi:

```sh
npx supabase login
npx supabase link --project-ref <project-ref>
npx supabase migration list
```
