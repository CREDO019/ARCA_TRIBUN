/// Uygulama boşluk sistemi — tüm padding/margin değerleri buradan gelir.
/// Magic number kullanımı yasak, her zaman AppSpacing sabitlerini kullan.
class AppSpacing {
  AppSpacing._();

  // ─── Base Units ──────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // ─── Semantic ────────────────────────────────────────────────────────
  /// Kart iç boşluğu
  static const double cardPadding = lg;

  /// Ekran kenar boşluğu
  static const double screenPadding = lg;

  /// Liste arası boşluk
  static const double listSpacing = md;

  /// Section arası boşluk
  static const double sectionSpacing = xxl;

  /// Widget iç boşluğu (küçük)
  static const double itemSpacing = sm;

  /// Buton yüksekliği
  static const double buttonHeight = 52.0;

  /// Küçük buton yüksekliği
  static const double smallButtonHeight = 40.0;

  /// Bottom nav yüksekliği
  static const double bottomNavHeight = 72.0;

  /// App bar yüksekliği
  static const double appBarHeight = 56.0;

  // ─── Border Radius ───────────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusFull = 100.0;

  // ─── Icon Sizes ──────────────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ─── Avatar Sizes ────────────────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 80.0;

  // ─── Card Dimensions ─────────────────────────────────────────────────
  static const double matchCardHeight = 180.0;
  static const double newsCardHeight = 200.0;
  static const double playerCardWidth = 120.0;
  static const double playerCardHeight = 160.0;
}
