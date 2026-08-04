import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const _fontFamily = 'Roboto';
  static const _package = null;

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.15,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.15,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
    height: 1.2,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
    height: 1.25,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.15,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.05,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.55,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.1,
    height: 1.55,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.1,
    height: 1.35,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
    height: 1.35,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
    letterSpacing: 0.2,
    height: 1.0,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    package: _package,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}