import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Uygulama tipografi sistemi.
/// Font: Barlow Condensed (başlıklar) + Barlow (body)
class AppTypography {
  AppTypography._();

  // ─── Barlow Condensed ─────────────────────────────────────────────────
  /// Büyük ekran başlığı — 48sp, 800 weight
  static TextStyle get displayLarge => GoogleFonts.barlowCondensed(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  /// Orta ekran başlığı — 32sp, 700 weight
  static TextStyle get displayMedium => GoogleFonts.barlowCondensed(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      );

  /// Küçük ekran başlığı — 24sp, 700 weight
  static TextStyle get headlineLarge => GoogleFonts.barlowCondensed(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  /// Alt başlık — 20sp, 600 weight
  static TextStyle get headlineMedium => GoogleFonts.barlowCondensed(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  /// Skorbord büyük — 64sp, 800 weight (canlı skor)
  static TextStyle get scoreDisplay => GoogleFonts.barlowCondensed(
        fontSize: 64,
        fontWeight: FontWeight.w800,
        color: AppColors.white,
        letterSpacing: -1,
      );

  /// GOL! başlığı — 72sp, 800 weight
  static TextStyle get goalDisplay => GoogleFonts.barlowCondensed(
        fontSize: 72,
        fontWeight: FontWeight.w800,
        color: AppColors.primaryRed,
        letterSpacing: -2,
      );

  // ─── Barlow ───────────────────────────────────────────────────────────
  /// Büyük başlık — 18sp, 600 weight
  static TextStyle get titleLarge => GoogleFonts.barlow(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  /// Orta başlık — 16sp, 500 weight
  static TextStyle get titleMedium => GoogleFonts.barlow(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  /// Büyük body — 16sp, 400 weight
  static TextStyle get bodyLarge => GoogleFonts.barlow(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  /// Orta body — 14sp, 400 weight
  static TextStyle get bodyMedium => GoogleFonts.barlow(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  /// Küçük body — 12sp, 400 weight
  static TextStyle get bodySmall => GoogleFonts.barlow(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  /// Etiket — 10sp, 700 weight, geniş letter spacing
  static TextStyle get labelSmall => GoogleFonts.barlow(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );

  /// Buton metin — 14sp, 700 weight, uppercase
  static TextStyle get button => GoogleFonts.barlowCondensed(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 1,
      );

  /// Sayaç rakamı — Barlow Condensed, 800 weight
  static TextStyle get countdown => GoogleFonts.barlowCondensed(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      );

  /// Sayaç etiketi — 10sp, uppercase
  static TextStyle get countdownLabel => GoogleFonts.barlow(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      );

  /// Üretilen TextTheme (ThemeData'ya uyumlu)
  static TextTheme get textTheme => textThemeFor(
        primary: AppColors.textPrimary,
        secondary: AppColors.secondaryGray,
      );

  static TextTheme textThemeFor({
    required Color primary,
    required Color secondary,
  }) =>
      TextTheme(
        displayLarge: displayLarge.copyWith(color: primary),
        displayMedium: displayMedium.copyWith(color: primary),
        headlineLarge: headlineLarge.copyWith(color: primary),
        headlineMedium: headlineMedium.copyWith(color: primary),
        titleLarge: titleLarge.copyWith(color: primary),
        titleMedium: titleMedium.copyWith(color: primary),
        bodyLarge: bodyLarge.copyWith(color: primary),
        bodyMedium: bodyMedium.copyWith(color: secondary),
        bodySmall: bodySmall.copyWith(color: secondary),
        labelSmall: labelSmall.copyWith(color: primary),
      );
}
