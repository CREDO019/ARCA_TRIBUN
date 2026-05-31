import 'package:flutter/foundation.dart';

const _playerPhotoBasePath = 'assets/images/players/corum_fk';

const _availablePlayerPhotoAssets = <String>{
  '$_playerPhotoBasePath/ahmed_ildiz.jpg',
  '$_playerPhotoBasePath/ahmet_kivanc.jpg',
  '$_playerPhotoBasePath/arda_sengul.jpg',
  '$_playerPhotoBasePath/atakan_akkaynak.jpg',
  '$_playerPhotoBasePath/atakan_cangoz.jpg',
  '$_playerPhotoBasePath/braian_samudio.jpg',
  '$_playerPhotoBasePath/burak_coban.jpg',
  '$_playerPhotoBasePath/cemali_sertel.jpg',
  '$_playerPhotoBasePath/danijel_aleksic.jpg',
  '$_playerPhotoBasePath/efe_sarikaya.jpg',
  '$_playerPhotoBasePath/eren_karadag.jpg',
  '$_playerPhotoBasePath/erkan_kas.jpg',
  '$_playerPhotoBasePath/ferhat_yazgan.jpg',
  '$_playerPhotoBasePath/fredy.jpg',
  '$_playerPhotoBasePath/furkan_cetinkaya.jpg',
  '$_playerPhotoBasePath/hasan_huseyin_akinay.jpg',
  '$_playerPhotoBasePath/ibrahim_sehic.jpg',
  '$_playerPhotoBasePath/ibrahim_zubairu.jpg',
  '$_playerPhotoBasePath/joseph_attamah.jpg',
  '$_playerPhotoBasePath/kerem_kalafat.jpg',
  '$_playerPhotoBasePath/oguz_gurbulak.jpg',
  '$_playerPhotoBasePath/pedrinho.jpg',
  '$_playerPhotoBasePath/serdar_gurler.jpg',
  '$_playerPhotoBasePath/sinan_osmanoglu.jpg',
  '$_playerPhotoBasePath/uzeyir_ergun.jpg',
  '$_playerPhotoBasePath/yusuf_erdogan.jpg',
};

const _playerSlugAliases = <String, String>{
  'ahmet_said_kivanc': 'ahmet_kivanc',
  'fredy_ribeiro': 'fredy',
};

/// Returns a bundled Çorum FK player photo path when an approved local asset
/// exists. Missing photos intentionally fall back to the branded placeholder.
String? corumPlayerPhotoAsset(String playerName) {
  final normalizedName = _normalizePlayerName(playerName);
  final assetSlug = _playerSlugAliases[normalizedName] ?? normalizedName;
  final assetPath = '$_playerPhotoBasePath/$assetSlug.jpg';

  if (_availablePlayerPhotoAssets.contains(assetPath)) return assetPath;

  assert(
    () {
      debugPrint('Player photo missing: $playerName -> $assetPath');
      return true;
    }(),
    'Missing bundled player photo: $assetPath',
  );
  return null;
}

/// Uses a Supabase-provided local asset path first, then the bundled name
/// mapping. Remote image URLs are intentionally ignored to prevent hotlinks.
String? resolveCorumPlayerPhotoAsset({
  required String playerName,
  String? configuredPhotoUrl,
}) {
  if (configuredPhotoUrl?.startsWith('assets/') ?? false) {
    return configuredPhotoUrl;
  }
  return corumPlayerPhotoAsset(playerName);
}

String _normalizePlayerName(String playerName) {
  var normalized = playerName.trim().toLowerCase();
  const replacements = <String, String>{
    'ç': 'c',
    'ğ': 'g',
    'ı': 'i',
    'ö': 'o',
    'ş': 's',
    'ü': 'u',
    'ć': 'c',
  };

  for (final entry in replacements.entries) {
    normalized = normalized.replaceAll(entry.key, entry.value);
  }

  return normalized
      .replaceAll(RegExp('[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}
