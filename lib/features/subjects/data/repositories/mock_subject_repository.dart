import 'package:flutter/material.dart';
import 'package:bac_nafa/features/subjects/domain/models/subject.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/subject_repository.dart';

class MockSubjectRepository implements SubjectRepository {
  final List<Subject> _subjects = [
    const Subject(
      id: 'sub_1',
      name: 'Mathématiques',
      description: 'Analyse, Algèbre et Géométrie',
      icon: Icons.calculate,
      category: 'Sciences',
    ),
    const Subject(
      id: 'sub_2',
      name: 'Physique-Chimie',
      description: 'Mécanique, Électricité et Chimie organique',
      icon: Icons.science,
      category: 'Sciences',
    ),
    const Subject(
      id: 'sub_3',
      name: 'SVT',
      description: 'Biologie et Géologie',
      icon: Icons.biotech,
      category: 'Sciences',
    ),
    const Subject(
      id: 'sub_4',
      name: 'Philosophie',
      description: 'Réflexion critique et méthodologie',
      icon: Icons.menu_book,
      category: 'Lettres',
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
