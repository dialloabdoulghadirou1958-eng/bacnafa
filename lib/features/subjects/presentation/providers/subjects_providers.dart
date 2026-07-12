import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/subjects/domain/models/subject.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_series.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_year.dart';
import 'package:bac_nafa/features/subjects/domain/models/exam_paper.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/repository_providers.dart';

// Selection state providers using Notifier
class SelectedSubjectNotifier extends Notifier<Subject?> {
  @override
  Subject? build() => null;
  void set(Subject? s) => state = s;
}
final selectedSubjectProvider = NotifierProvider<SelectedSubjectNotifier, Subject?>(SelectedSubjectNotifier.new);

class SelectedSeriesNotifier extends Notifier<BacSeries?> {
  @override
  BacSeries? build() => null;
  void set(BacSeries? s) => state = s;
}
final selectedSeriesProvider = NotifierProvider<SelectedSeriesNotifier, BacSeries?>(SelectedSeriesNotifier.new);

class SelectedYearNotifier extends Notifier<BacYear?> {
  @override
  BacYear? build() => null;
  void set(BacYear? y) => state = y;
}
final selectedYearProvider = NotifierProvider<SelectedYearNotifier, BacYear?>(SelectedYearNotifier.new);

class ExamSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String q) => state = q;
}
final examSearchQueryProvider = NotifierProvider<ExamSearchQueryNotifier, String>(ExamSearchQueryNotifier.new);

class ExamCorrectionFilterNotifier extends Notifier<bool?> {
  @override
  bool? build() => null;
  void set(bool? v) => state = v;
}
final examCorrectionFilterProvider = NotifierProvider<ExamCorrectionFilterNotifier, bool?>(ExamCorrectionFilterNotifier.new);

// Data providers
final subjectsListProvider = FutureProvider<List<Subject>>((ref) {
  final repo = ref.watch(subjectsRepositoryProvider);
  return repo.getSubjects();
});

final seriesListProvider = FutureProvider<List<BacSeries>>((ref) {
  final repo = ref.watch(seriesRepositoryProvider);
  return repo.getSeries();
});

final yearsListProvider = FutureProvider<List<BacYear>>((ref) {
  final repo = ref.watch(yearsRepositoryProvider);
  return repo.getYears();
});

final examPapersProvider = FutureProvider<List<ExamPaper>>((ref) {
  final repo = ref.watch(examRepositoryProvider);
  final subject = ref.watch(selectedSubjectProvider);
  final series = ref.watch(selectedSeriesProvider);
  final year = ref.watch(selectedYearProvider);

  return repo.getExams(
    subjectId: subject?.id,
    seriesId: series?.id,
    yearId: year?.id,
  );
});

// Filtered provider
final filteredExamsProvider = Provider<AsyncValue<List<ExamPaper>>>((ref) {
  final examsAsync = ref.watch(examPapersProvider);
  final query = ref.watch(examSearchQueryProvider).toLowerCase();
  final correctionOnly = ref.watch(examCorrectionFilterProvider);

  return examsAsync.whenData((exams) {
    return exams.where((exam) {
      final matchesQuery = exam.title.toLowerCase().contains(query);
      final matchesCorrection = correctionOnly == null || exam.hasCorrection == correctionOnly;
      return matchesQuery && matchesCorrection;
    }).toList();
  });
});
