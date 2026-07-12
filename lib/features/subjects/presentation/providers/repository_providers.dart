import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/subject_repository.dart';
import 'package:bac_nafa/features/subjects/data/repositories/mock_subject_repository.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/series_repository.dart';
import 'package:bac_nafa/features/subjects/data/repositories/mock_series_repository.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/bac_year_repository.dart';
import 'package:bac_nafa/features/subjects/data/repositories/mock_bac_year_repository.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/exam_repository.dart';
import 'package:bac_nafa/features/subjects/data/repositories/mock_exam_repository.dart';

final subjectsRepositoryProvider = Provider<SubjectRepository>((ref) {
  return MockSubjectRepository();
});

final seriesRepositoryProvider = Provider<SeriesRepository>((ref) {
  return MockSeriesRepository();
});

final yearsRepositoryProvider = Provider<BacYearRepository>((ref) {
  return MockBacYearRepository();
});

final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return MockExamRepository();
});
