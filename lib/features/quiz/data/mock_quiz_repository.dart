import 'package:bac_nafa/features/quiz/domain/models/quiz_models.dart';

class MockQuizRepository {
  Future<List<Quiz>> getQuizzes() async {
    return [
      Quiz(
        id: '1',
        title: 'Math Quiz',
        description: 'Basic math',
        questions: [
          Question(
            id: 'q1',
            text: 'What is 2 + 2?',
            options: [
              Option(id: 'o1', text: '3', isCorrect: false),
              Option(id: 'o2', text: '4', isCorrect: true),
              Option(id: 'o3', text: '5', isCorrect: false),
            ],
          ),
        ],
      ),
    ];
  }
}
