import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String category;
  final String svgAsset;
  final Color accentColor;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    required this.svgAsset,
    required this.accentColor,
  });

  Subject copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    String? category,
    String? svgAsset,
    Color? accentColor,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      svgAsset: svgAsset ?? this.svgAsset,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}
