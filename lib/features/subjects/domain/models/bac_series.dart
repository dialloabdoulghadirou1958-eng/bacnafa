import 'package:flutter/material.dart';

class BacSeries {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color accentColor;

  const BacSeries({
    required this.id,
    required this.name,
    required this.description,
    this.icon = Icons.category_rounded,
    this.accentColor = const Color(0xFF5A54E8),
  });

  BacSeries copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    Color? accentColor,
  }) {
    return BacSeries(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
