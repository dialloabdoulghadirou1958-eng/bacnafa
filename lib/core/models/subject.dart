import 'package:flutter/material.dart';

class CoreSubject {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final double progress;
  final Color color;

  const CoreSubject({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.progress,
    required this.color,
  });

  CoreSubject copyWith({
    String? name,
    String? description,
    IconData? icon,
    double? progress,
    Color? color,
  }) {
    return CoreSubject(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
      color: color ?? this.color,
    );
  }
}
