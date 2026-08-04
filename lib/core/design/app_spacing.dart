import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  static const double sectionGap = 32.0;
  static const double cardGap = 16.0;
  static const double listGap = 12.0;
  static const double iconGap = 8.0;

  static EdgeInsets get screenPadding => const EdgeInsets.all(lg);
  static EdgeInsets get cardPadding => const EdgeInsets.all(md);
  static EdgeInsets get listPadding => const EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get buttonPadding => const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  static SizedBox get spacerXs => const SizedBox(height: xs);
  static SizedBox get spacerSm => const SizedBox(height: sm);
  static SizedBox get spacerMd => const SizedBox(height: md);
  static SizedBox get spacerLg => const SizedBox(height: lg);
}