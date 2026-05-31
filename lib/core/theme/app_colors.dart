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
  /// Ana arka plan rengi — açık temada sıcak beyaz
  static const Color background = Color(0xFFF7F7F5);

  /// Kart arka planı — birincil beyaz yüzey
  static const Color cardBg = Color(0xFFFFFFFF);

  /// Kart arka planı — ikincil nötr yüzey
  static const Color cardBg2 = Color(0xFFF0F1F3);

  /// Derin siyah
  static const Color deepBlack = Color(0xFF0B0B0B);

  // ─── Text ───────────────────────────────────────────────────────────────
  /// Beyaz metin
  static const Color white = Color(0xFFFFFFFF);

  /// Açık yüzeyler üzerindeki birincil metin
  static const Color textPrimary = Color(0xFF171717);

  /// İkincil gri metin
  static const Color secondaryGray = Color(0xFF62666D);

  /// Üçüncül gri metin (disabled)
  static const Color tertiaryGray = Color(0xFF8A8F98);

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
  /// Açık yüzeyler üzerindeki border rengi
  static const Color border = Color(0x1A171717);

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

@immutable
class AppColorPalette extends ThemeExtension<AppColorPalette> {
  const AppColorPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.heroGradient,
    required this.cardGradient,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final List<Color> heroGradient;
  final List<Color> cardGradient;
  final Color shimmerBase;
  final Color shimmerHighlight;

  static const light = AppColorPalette(
    background: AppColors.background,
    surface: AppColors.cardBg,
    surfaceAlt: AppColors.cardBg2,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.secondaryGray,
    textTertiary: AppColors.tertiaryGray,
    border: AppColors.border,
    heroGradient: AppColors.heroGradient,
    cardGradient: AppColors.cardGradient,
    shimmerBase: AppColors.cardBg,
    shimmerHighlight: AppColors.cardBg2,
  );

  static const dark = AppColorPalette(
    background: Color(0xFF08090B),
    surface: Color(0xFF121419),
    surfaceAlt: Color(0xFF1D2027),
    textPrimary: Color(0xFFF7F7F5),
    textSecondary: Color(0xFFC4C7CF),
    textTertiary: Color(0xFF9097A3),
    border: Color(0x33FFFFFF),
    heroGradient: [
      Color(0xFF5A0000),
      Color(0xFF07080A),
    ],
    cardGradient: [
      Color(0xFF1D2027),
      Color(0xFF121419),
    ],
    shimmerBase: Color(0xFF1D2027),
    shimmerHighlight: Color(0xFF2A2F38),
  );

  @override
  AppColorPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    List<Color>? heroGradient,
    List<Color>? cardGradient,
    Color? shimmerBase,
    Color? shimmerHighlight,
  }) {
    return AppColorPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      heroGradient: heroGradient ?? this.heroGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
    );
  }

  @override
  AppColorPalette lerp(ThemeExtension<AppColorPalette>? other, double t) {
    if (other is! AppColorPalette) return this;

    return AppColorPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      heroGradient: [
        Color.lerp(heroGradient.first, other.heroGradient.first, t)!,
        Color.lerp(heroGradient.last, other.heroGradient.last, t)!,
      ],
      cardGradient: [
        Color.lerp(cardGradient.first, other.cardGradient.first, t)!,
        Color.lerp(cardGradient.last, other.cardGradient.last, t)!,
      ],
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight:
          Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
    );
  }
}

extension AppThemeColors on BuildContext {
  AppColorPalette get arcaColors =>
      Theme.of(this).extension<AppColorPalette>() ?? AppColorPalette.light;
}
