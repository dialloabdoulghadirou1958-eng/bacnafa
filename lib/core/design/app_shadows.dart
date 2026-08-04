import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get none => [];

  static List<BoxShadow> get subtle {
    return [
      BoxShadow(
        color: const Color(0x080A0F1E),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> get soft {
    return [
      BoxShadow(
        color: const Color(0x0D0F172A),
        blurRadius: 10,
        offset: const Offset(0, 4),
        spreadRadius: -2,
      ),
    ];
  }

  static List<BoxShadow> get medium {
    return [
      BoxShadow(
        color: const Color(0x140F172A),
        blurRadius: 16,
        offset: const Offset(0, 8),
        spreadRadius: -4,
      ),
    ];
  }

  static List<BoxShadow> get elevated {
    return [
      BoxShadow(
        color: const Color(0x1A0F172A),
        blurRadius: 24,
        offset: const Offset(0, 12),
        spreadRadius: -6,
      ),
    ];
  }

  static List<BoxShadow> get premium {
    return [
      BoxShadow(
        color: const Color(0x140F172A),
        blurRadius: 32,
        offset: const Offset(0, 16),
        spreadRadius: -8,
      ),
    ];
  }
}