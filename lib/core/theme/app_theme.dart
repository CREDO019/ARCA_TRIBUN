import 'package:arca_tribun/core/theme/app_colors.dart';
import 'package:arca_tribun/core/theme/app_spacing.dart';
import 'package:arca_tribun/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Uygulamanın açık ve koyu ThemeData konfigürasyonları.
class AppTheme {
  AppTheme._();

  /// Beyaz yüzeyler ve kırmızı aksanlar üzerine kurulan kulüp teması.
  static ThemeData get lightTheme => _buildTheme(
        palette: AppColorPalette.light,
        brightness: Brightness.light,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
      );

  /// Siyah yüzeyler ve aynı kırmızı marka aksanları üzerine kurulan tema.
  static ThemeData get darkTheme => _buildTheme(
        palette: AppColorPalette.dark,
        brightness: Brightness.dark,
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
      );

  static ThemeData _buildTheme({
    required AppColorPalette palette,
    required Brightness brightness,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final textTheme = AppTypography.textThemeFor(
      primary: palette.textPrimary,
      secondary: palette.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      primaryColor: AppColors.primaryRed,
      cardColor: palette.surface,
      canvasColor: palette.background,
      colorScheme: _colorScheme(palette, brightness),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      extensions: [palette],
      appBarTheme: _appBarTheme(palette, systemOverlayStyle),
      bottomNavigationBarTheme: _bottomNavTheme(palette),
      cardTheme: _cardTheme(palette),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme(palette),
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme(palette),
      iconTheme: IconThemeData(
        color: palette.textPrimary,
        size: AppSpacing.iconLg,
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
        space: 0,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        textColor: palette.textPrimary,
        subtitleTextStyle: textTheme.bodySmall,
        titleTextStyle: textTheme.titleMedium,
      ),
      snackBarTheme: _snackBarTheme,
      chipTheme: _chipTheme(palette, textTheme),
      tabBarTheme: _tabBarTheme(palette, textTheme),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryRed,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryRed,
        selectionColor: AppColors.primaryRed.withValues(alpha: 0.24),
        selectionHandleColor: AppColors.primaryRed,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryRed;
          }
          return palette.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryRed.withValues(alpha: 0.32);
          }
          return palette.surfaceAlt;
        }),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ColorScheme _colorScheme(
    AppColorPalette palette,
    Brightness brightness,
  ) {
    if (brightness == Brightness.dark) {
      return ColorScheme.dark(
        primary: AppColors.primaryRed,
        onPrimary: AppColors.white,
        secondary: palette.surfaceAlt,
        onSecondary: palette.textPrimary,
        surface: palette.surface,
        onSurface: palette.textPrimary,
        error: AppColors.errorRed,
        onError: AppColors.white,
        outline: palette.border,
      );
    }

    return ColorScheme.light(
      primary: AppColors.primaryRed,
      onPrimary: AppColors.white,
      secondary: palette.surfaceAlt,
      onSecondary: palette.textPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: AppColors.errorRed,
      onError: AppColors.white,
      outline: palette.border,
    );
  }

  static AppBarTheme _appBarTheme(
    AppColorPalette palette,
    SystemUiOverlayStyle systemOverlayStyle,
  ) =>
      AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: systemOverlayStyle,
        titleTextStyle:
            AppTypography.headlineMedium.copyWith(color: palette.textPrimary),
        iconTheme: IconThemeData(
          color: palette.textPrimary,
          size: AppSpacing.iconLg,
        ),
      );

  static BottomNavigationBarThemeData _bottomNavTheme(
    AppColorPalette palette,
  ) =>
      BottomNavigationBarThemeData(
        backgroundColor: palette.surface,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: palette.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );

  static CardThemeData _cardTheme(AppColorPalette palette) => CardThemeData(
        color: palette.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: BorderSide(color: palette.border),
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

  static OutlinedButtonThemeData _outlinedButtonTheme(
    AppColorPalette palette,
  ) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.border),
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

  static InputDecorationTheme _inputDecorationTheme(
    AppColorPalette palette,
  ) =>
      InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: palette.textSecondary,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: palette.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      );

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.deepBlack,
        contentTextStyle:
            AppTypography.bodyMedium.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      );

  static ChipThemeData _chipTheme(
    AppColorPalette palette,
    TextTheme textTheme,
  ) =>
      ChipThemeData(
        backgroundColor: palette.surface,
        selectedColor: AppColors.primaryRed,
        labelStyle: textTheme.bodySmall,
        side: BorderSide(color: palette.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      );

  static TabBarThemeData _tabBarTheme(
    AppColorPalette palette,
    TextTheme textTheme,
  ) =>
      TabBarThemeData(
        indicatorColor: AppColors.primaryRed,
        labelColor: palette.textPrimary,
        unselectedLabelColor: palette.textSecondary,
        labelStyle: textTheme.titleMedium,
        unselectedLabelStyle: textTheme.bodyMedium,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: palette.border,
      );
}
