import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get none => [];

  static List<BoxShadow> get subtle {
    return [
      BoxShadow(
        color: const Color(0x140F172A),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> get soft {
    return [
      BoxShadow(
        color: const Color(0x140F172A),
        blurRadius: 14,
        offset: const Offset(0, 6),
        spreadRadius: -3,
      ),
    ];
  }

  static List<BoxShadow> get medium {
    return [
      BoxShadow(
        color: const Color(0x1A0F172A),
        blurRadius: 20,
        offset: const Offset(0, 10),
        spreadRadius: -5,
      ),
    ];
  }

  static List<BoxShadow> get elevated {
    return [
      BoxShadow(
        color: const Color(0x1F0F172A),
        blurRadius: 28,
        offset: const Offset(0, 14),
        spreadRadius: -7,
      ),
    ];
  }

  static List<BoxShadow> get premium {
    return [
      BoxShadow(
        color: const Color(0x1A0F172A),
        blurRadius: 40,
        offset: const Offset(0, 20),
        spreadRadius: -10,
      ),
      BoxShadow(
        color: const Color(0x0D0F172A),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }
}