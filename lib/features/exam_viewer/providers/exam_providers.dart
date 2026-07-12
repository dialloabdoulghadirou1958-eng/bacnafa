import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/exam_viewer/data/mock_exam_content_repository.dart';
import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';

final examRepositoryProvider = Provider<ExamContentRepository>((ref) {
  return MockExamContentRepository();
});

final currentExamProvider = NotifierProvider<CurrentExamNotifier, ExamContent?>(() {
  return CurrentExamNotifier();
});

class CurrentExamNotifier extends Notifier<ExamContent?> {
  @override
  ExamContent? build() => null;

  void set(ExamContent? exam) => state = exam;
}

final examContentProvider = FutureProvider.family<ExamContent?, String>((ref, id) async {
  final repository = ref.watch(examRepositoryProvider);
  return repository.getExamById(id);
});

final examFavoritesProvider = NotifierProvider<ExamFavoritesNotifier, Set<String>>(() {
  return ExamFavoritesNotifier();
});

class ExamFavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggleFavorite(String examId) {
    if (state.contains(examId)) {
      state = {...state}..remove(examId);
    } else {
      state = {...state, examId};
    }
  }

  bool isFavorite(String examId) => state.contains(examId);
}
