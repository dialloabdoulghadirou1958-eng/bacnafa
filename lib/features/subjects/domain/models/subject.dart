import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String category;

  const Subject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
  });

  Subject copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    String? category,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
    );
  }
}
