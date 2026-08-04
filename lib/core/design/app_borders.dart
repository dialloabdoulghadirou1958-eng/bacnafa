import 'package:flutter/material.dart';

class AppBorders {
  AppBorders._();

  static BorderSide get none => BorderSide.none;

  static BorderSide get subtle => const BorderSide(
    color: Color(0xFFE2E8F0),
    width: 1.0,
  );

  static BorderSide get medium => const BorderSide(
    color: Color(0xFFCBD5E1),
    width: 1.0,
  );

  static BorderSide get strong => const BorderSide(
    color: Color(0xFF94A3B8),
    width: 1.0,
  );

  static BorderSide get focus => const BorderSide(
    color: Color(0xFF4338CA),
    width: 2.0,
  );

  static BorderSide get error => const BorderSide(
    color: Color(0xFFDC2626),
    width: 1.0,
  );

  static BorderSide get success => const BorderSide(
    color: Color(0xFF059669),
    width: 1.0,
  );
}