import 'package:flutter/material.dart';

/// Design token renk paleti — projenin DNA'sı.
/// Hiçbir yerde hardcode renk kullanma, her zaman bu sınıftan al.
class AppColors {
  AppColors._();

  // ─── Primary ────────────────────────────────────────────────────────────
  /// Ana kırmızı — marka rengi
  static const Color primaryRed = Color(0xFFCC0000);

  /// Koyu kırmızı — hover/pressed state
  static const Color primaryRedDark = Color(0xFF990000);

  /// Açık kırmızı — subtle vurgu
  static const Color primaryRedLight = Color(0xFFE53535);

  // ─── Backgrounds ────────────────────────────────────────────────────────
  /// Ana arka plan rengi
  static const Color background = Color(0xFF090909);

  /// Kart arka planı — birincil
  static const Color cardBg = Color(0xFF151515);

  /// Kart arka planı — ikincil (daha açık)
  static const Color cardBg2 = Color(0xFF1E1E1E);

  /// Derin siyah
  static const Color deepBlack = Color(0xFF0B0B0B);

  // ─── Text ───────────────────────────────────────────────────────────────
  /// Beyaz metin
  static const Color white = Color(0xFFFFFFFF);

  /// İkincil gri metin
  static const Color secondaryGray = Color(0xFFA3A3A3);

  /// Üçüncül gri metin (disabled)
  static const Color tertiaryGray = Color(0xFF666666);

  // ─── Semantic ───────────────────────────────────────────────────────────
  /// Başarı yeşil
  static const Color success = Color(0xFF16A34A);

  /// Uyarı sarı
  static const Color warning = Color(0xFFFACC15);

  /// Hata kırmızı
  static const Color errorRed = Color(0xFFDC2626);

  /// Bilgi mavi
  static const Color infoBlue = Color(0xFF3B82F6);

  // ─── UI Elements ────────────────────────────────────────────────────────
  /// Border rengi — rgba(255,255,255,0.08)
  static const Color border = Color(0x14FFFFFF);

  /// Koyu overlay — modal, sheet arka planları
  static const Color overlayDark = Color(0xCC000000);

  /// Glassmorphism overlay
  static const Color glassOverlay = Color(0x0DFFFFFF);

  // ─── Live/Status ────────────────────────────────────────────────────────
  /// Canlı maç kırmızı (pulsing badge)
  static const Color liveRed = Color(0xFFFF0000);

  // ─── Gradients ──────────────────────────────────────────────────────────
  /// Ana gradient — kırmızıdan siyaha
  static const List<Color> primaryGradient = [primaryRed, deepBlack];

  /// Kart gradient
  static const List<Color> cardGradient = [cardBg2, cardBg];

  /// Hero gradient — maç kartı
  static const List<Color> heroGradient = [
    Color(0xFF3D0000),
    Color(0xFF090909),
  ];
}
