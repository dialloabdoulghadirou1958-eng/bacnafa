import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/exam_viewer/data/mock_exam_content_repository.dart';
import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';

final examRepositoryProvider = Provider<ExamContentRepository>((ref) {
  return MockExamContentRepository();
});

final examContentProvider =
    FutureProvider.autoDispose.family<ExamContent?, String>((ref, id) async {
  final repository = ref.watch(examRepositoryProvider);
  return repository.getExamById(id);
});
