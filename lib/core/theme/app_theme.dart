import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Uygulamanın ana ThemeData konfigürasyonu.
/// Yalnızca karanlık tema kullanılır (dark-first design).
class AppTheme {
  AppTheme._();

  /// Uygulama karanlık teması
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryRed,
        colorScheme: _colorScheme,
        textTheme: AppTypography.textTheme,
        appBarTheme: _appBarTheme,
        bottomNavigationBarTheme: _bottomNavTheme,
        cardTheme: _cardTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        iconTheme: const IconThemeData(
          color: AppColors.white,
          size: AppSpacing.iconLg,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 1,
          space: 0,
        ),
        snackBarTheme: _snackBarTheme,
        chipTheme: _chipTheme,
        tabBarTheme: _tabBarTheme,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      );

  static ColorScheme get _colorScheme => const ColorScheme.dark(
        primary: AppColors.primaryRed,
        onPrimary: AppColors.white,
        secondary: AppColors.cardBg2,
        onSecondary: AppColors.white,
        surface: AppColors.cardBg,
        error: AppColors.errorRed,
        onError: AppColors.white,
        outline: AppColors.border,
      );

  static AppBarTheme get _appBarTheme => AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: AppTypography.headlineMedium,
        iconTheme: const IconThemeData(
          color: AppColors.white,
          size: AppSpacing.iconLg,
        ),
      );

  static BottomNavigationBarThemeData get _bottomNavTheme =>
      const BottomNavigationBarThemeData(
        backgroundColor: AppColors.deepBlack,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.secondaryGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );

  static CardThemeData get _cardTheme => CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: const BorderSide(color: AppColors.border),
        ),
      );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
          elevation: 0,
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: AppTypography.button,
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          textStyle: AppTypography.button,
        ),
      );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: AppTypography.bodyMedium,
        labelStyle: AppTypography.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      );

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.cardBg2,
        contentTextStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      );

  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: AppColors.cardBg,
        selectedColor: AppColors.primaryRed,
        labelStyle: AppTypography.bodySmall,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      );

  static TabBarThemeData get _tabBarTheme => TabBarThemeData(
        indicatorColor: AppColors.primaryRed,
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.secondaryGray,
        labelStyle: AppTypography.titleMedium,
        unselectedLabelStyle: AppTypography.bodyMedium,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.border,
      );
}
