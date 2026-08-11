import 'package:flutter/material.dart';
import 'package:bac_nafa/features/subjects/domain/models/subject.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/subject_repository.dart';

class MockSubjectRepository implements SubjectRepository {
  final List<Subject> _subjects = [
    const Subject(
      id: 'sub_1',
      name: 'Mathématiques',
      description: 'Algèbre, Analyse et Géométrie',
      icon: Icons.calculate_rounded,
      category: 'Sciences',
      svgAsset: 'assets/subjects/math.svg',
      accentColor: Color(0xFF5A54E8),
    ),
    const Subject(
      id: 'sub_2',
      name: 'Physique-Chimie',
      description: 'Mécanique, Électricité et Chimie',
      icon: Icons.science_rounded,
      category: 'Sciences',
      svgAsset: 'assets/subjects/physique.svg',
      accentColor: Color(0xFF0284C7),
    ),
    const Subject(
      id: 'sub_3',
      name: 'SVT',
      description: 'Sciences de la Vie et de la Terre',
      icon: Icons.biotech_rounded,
      category: 'Sciences',
      svgAsset: 'assets/subjects/svt.svg',
      accentColor: Color(0xFF059669),
    ),
    const Subject(
      id: 'sub_4',
      name: 'Philosophie',
      description: 'Réflexion critique et dissertation',
      icon: Icons.menu_book_rounded,
      category: 'Lettres',
      svgAsset: 'assets/subjects/philosophie.svg',
      accentColor: Color(0xFFB45309),
    ),
    const Subject(
      id: 'sub_5',
      name: 'Français',
      description: 'Langue, littérature et expression écrite',
      icon: Icons.translate_rounded,
      category: 'Lettres',
      svgAsset: 'assets/subjects/francais.svg',
      accentColor: Color(0xFFDC2626),
    ),
    const Subject(
      id: 'sub_6',
      name: 'Anglais',
      description: 'Compréhension, grammaire et expression',
      icon: Icons.language_rounded,
      category: 'Lettres',
      svgAsset: 'assets/subjects/anglais.svg',
      accentColor: Color(0xFF7C3AED),
    ),
    const Subject(
      id: 'sub_7',
      name: 'Histoire-Géographie',
      description: 'Histoire universelle et géographie humaine',
      icon: Icons.public_rounded,
      category: 'Sciences Humaines',
      svgAsset: 'assets/subjects/histoire.svg',
      accentColor: Color(0xFFD97706),
    ),
  ];

  @override
  Future<List<Subject>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _subjects;
  }

  @override
  Future<Subject> getSubjectById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _subjects.firstWhere((s) => s.id == id);
  }
}
