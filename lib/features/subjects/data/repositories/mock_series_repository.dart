import 'package:flutter/material.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_series.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/series_repository.dart';

class MockSeriesRepository implements SeriesRepository {
  final List<BacSeries> _series = [
    const BacSeries(
      id: 'ser_1',
      name: 'Sciences Mathématiques (SM)',
      description: 'Mathématiques, Physique-Chimie dominantes',
      icon: Icons.functions_rounded,
      accentColor: Color(0xFF5A54E8),
    ),
    const BacSeries(
      id: 'ser_2',
      name: 'Sciences Expérimentales (SE)',
      description: 'SVT, Physique-Chimie et Mathématiques',
      icon: Icons.biotech_rounded,
      accentColor: Color(0xFF059669),
    ),
    const BacSeries(
      id: 'ser_3',
      name: 'Lettres & Arts',
      description: 'Français, Philosophie et Langues',
      icon: Icons.menu_book_rounded,
      accentColor: Color(0xFFB45309),
    ),
    const BacSeries(
      id: 'ser_4',
      name: 'Sciences Sociales',
      description: 'Histoire-Géographie, Économie & Philosophie',
      icon: Icons.public_rounded,
      accentColor: Color(0xFFD97706),
    ),
  ];

  @override
  Future<List<BacSeries>> getSeries() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _series;
  }

  @override
  Future<BacSeries> getSeriesById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _series.firstWhere((s) => s.id == id);
  }
}
