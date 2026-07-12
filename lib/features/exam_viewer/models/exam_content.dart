import 'package:flutter/material.dart';

class ExamContent {
  final String id;
  final String title;
  final String subjectName;
  final String series;
  final String year;
  final String session;
  final String duration;
  final double coefficient;
  final List<ExamSection> sections;

  ExamContent({
    required this.id,
    required this.title,
    required this.subjectName,
    required this.series,
    required this.year,
    required this.session,
    required this.duration,
    required this.coefficient,
    required this.sections,
  });
}

class ExamSection {
  final String id;
  final String title;
  final String content;
  final int order;
  final List<ExamExercise> exercises;

  ExamSection({
    required this.id,
    required this.title,
    required this.content,
    required this.order,
    this.exercises = const [],
  });
}

class ExamExercise {
  final String id;
  final int number;
  final String statement;
  final double points;
  final List<String> attachments;

  ExamExercise({
    required this.id,
    required this.number,
    required this.statement,
    required this.points,
    this.attachments = const [],
  });
}
