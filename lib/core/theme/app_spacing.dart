/// Uygulama boşluk sistemi — tüm padding/margin değerleri buradan gelir.
/// Magic number kullanımı yasak, her zaman AppSpacing sabitlerini kullan.
class AppSpacing {
  AppSpacing._();

  // ─── Base Units ──────────────────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;
  static const double massive = 64;

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
  static const double buttonHeight = 52;

  /// Küçük buton yüksekliği
  static const double smallButtonHeight = 40;

  /// Bottom nav yüksekliği
  static const double bottomNavHeight = 72;

  /// App bar yüksekliği
  static const double appBarHeight = 56;

  // ─── Border Radius ───────────────────────────────────────────────────
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusFull = 100;

  // ─── Icon Sizes ──────────────────────────────────────────────────────
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ─── Avatar Sizes ────────────────────────────────────────────────────
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 64;
  static const double avatarXl = 80;

  // ─── Card Dimensions ─────────────────────────────────────────────────
  static const double matchCardHeight = 180;
  static const double newsCardHeight = 200;
  static const double playerCardWidth = 120;
  static const double playerCardHeight = 160;
}
