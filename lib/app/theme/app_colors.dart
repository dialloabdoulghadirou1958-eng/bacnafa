import 'package:flutter/material.dart';

class AppColors {

  AppColors._();

  static const Color primary = Color(0xFF4338CA);
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFE0E7FF);
  static const Color onPrimaryContainer = Color(0xFF1E1B4B);
  static const Color primaryLight = primaryContainer;

  static const Color secondary = Color(0xFF0284C7);
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFE0F2FE);
  static const Color onSecondaryContainer = Color(0xFF0C4A6E);

  static const Color tertiary = Color(0xFF7C3AED);
  static const Color onTertiary = Colors.white;
  static const Color tertiaryContainer = Color(0xFFEDE9FE);
  static const Color onTertiaryContainer = Color(0xFF3B1D7F);
  static const Color aiAccent = tertiary;

  static const Color error = Color(0xFFDC2626);
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  static const Color success = Color(0xFF059669);
  static const Color onSuccess = Colors.white;
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccessContainer = Color(0xFF064E3B);

  static const Color warning = Color(0xFFD97706);
  static const Color onWarning = Color(0xFF78350F);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF78350F);

  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF0F172A);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onSurfaceVariant = Color(0xFF475569);
  static const Color background = surfaceContainerLow;

  static const Color surfaceDim = Color(0xFFF8FAFC);
  static const Color surfaceBright = Color(0xFFF8FAFC);
  static const Color surfaceContainerLowest = Colors.white;
  static const Color surfaceContainerLow = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);
  static const Color surfaceContainerHigh = Color(0xFFE2E8F0);
  static const Color surfaceContainerHighest = Color(0xFFCBD5E1);

  static const Color onPrimaryFixed = Color(0xFF3730A3);
  static const Color onSecondaryFixed = Color(0xFF0369A1);
  static const Color outline = Color(0xFF94A3B8);
  static const Color outlineVariant = Color(0xFFCBD5E1);
  static const Color outlineStrong = Color(0xFF94A3B8);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF334155);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);

  static const Color tintBlue = Color(0xFFDBEAFE);
  static const Color tintGreen = Color(0xFFDCFCE7);
  static const Color tintOrange = Color(0xFFFFEDD5);
  static const Color tintPurple = Color(0xFFF3E8FF);

  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color borderStrong = Color(0xFF94A3B8);

  static ColorScheme get lightColorScheme => ColorScheme.light(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: onSurface,
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: Colors.black.withValues(alpha: 0.08),
  );
}