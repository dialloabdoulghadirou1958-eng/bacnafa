import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';

abstract class ExamContentRepository {
  Future<ExamContent?> getExamById(String id);
}

class MockExamContentRepository implements ExamContentRepository {
  @override
  Future<ExamContent?> getExamById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (id == 'ex_1') {
      return ExamContent(
        id: 'ex_1',
        title: 'Sujet Principal 2025',
        subjectName: 'Mathématiques',
        series: 'Sciences Mathématiques',
        year: '2025',
        session: 'Normale',
        duration: '4h',
        coefficient: 7.0,
        sections: [
          ExamSection(
            id: 'sec1',
            title: 'Première Partie',
            content: 'Questions d\'analyse et d\'algèbre.',
            order: 1,
          ),
        ],
      );
    }
    if (id == 'ex_2') {
      return ExamContent(
        id: 'ex_2',
        title: 'Sujet de Rattrapage 2025',
        subjectName: 'Mathématiques',
        series: 'Sciences Mathématiques',
        year: '2025',
        session: 'Rattrapage',
        duration: '3h',
        coefficient: 7.0,
        sections: [
          ExamSection(
            id: 'sec2',
            title: 'Première Partie',
            content: 'Questions de rattrapage.',
            order: 1,
          ),
        ],
      );
    }
    return null;
  }
}
