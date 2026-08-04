import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/core/models/student_profile.dart';
import 'package:bac_nafa/core/models/subject.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';

final currentUserProvider = Provider<StudentProfile>((ref) {
  return const StudentProfile(
    id: 'user_1',
    name: 'Amadou Diallo',
    bacSeries: 'Série S',
    bacYear: 2026,
    progress: 0.42,
  );
});

final subjectsProvider = Provider<List<CoreSubject>>((ref) {
  return _allSubjects;
});

const _allSubjects = [
  CoreSubject(
    id: 'sub_1',
    name: 'Mathématiques',
    description: 'Analyse, Algèbre et Géométrie',
    icon: Icons.calculate,
    progress: 0.65,
    color: AppColors.primary,
  ),
  CoreSubject(
    id: 'sub_2',
    name: 'Physique-Chimie',
    description: 'Mécanique, Électricité et Chimie organique',
    icon: Icons.science,
    progress: 0.30,
    color: Colors.orange,
  ),
  CoreSubject(
    id: 'sub_3',
    name: 'SVT',
    description: 'Biologie et Géologie',
    icon: Icons.biotech,
    progress: 0.50,
    color: Colors.green,
  ),
  CoreSubject(
    id: 'sub_4',
    name: 'Philosophie',
    description: 'Réflexion critique et méthodologie',
    icon: Icons.menu_book,
    progress: 0.20,
    color: Colors.purple,
  ),
];
