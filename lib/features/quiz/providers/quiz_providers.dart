import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/quiz/domain/models/quiz_models.dart';
import 'package:bac_nafa/features/quiz/data/mock_quiz_repository.dart';

final quizRepositoryProvider = Provider<MockQuizRepository>((ref) {
  return MockQuizRepository();
});

final quizzesProvider = FutureProvider<List<Quiz>>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return repo.getQuizzes();
});

final quizByIdProvider = FutureProvider.family<Quiz?, String>((ref, id) async {
  final quizzes = await ref.watch(quizzesProvider.future);
  try {
    return quizzes.firstWhere((q) => q.id == id);
  } catch (_) {
    return null;
  }
});