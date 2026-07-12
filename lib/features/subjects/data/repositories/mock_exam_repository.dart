import 'package:bac_nafa/features/subjects/domain/models/exam_paper.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/exam_repository.dart';

class MockExamRepository implements ExamRepository {
  final List<ExamPaper> _exams = [
    const ExamPaper(
      id: 'ex_1',
      title: 'Sujet Principal 2025',
      subjectId: 'sub_1',
      seriesId: 'ser_1',
      yearId: 'y2025',
      session: 'Normale',
      duration: '4h',
      coefficient: 7.0,
      hasCorrection: true,
    ),
    const ExamPaper(
      id: 'ex_2',
      title: 'Sujet de Rattrapage 2025',
      subjectId: 'sub_1',
      seriesId: 'ser_1',
      yearId: 'y2025',
      session: 'Rattrapage',
      duration: '3h',
      coefficient: 7.0,
      hasCorrection: false,
    ),
  ];

  @override
  Future<List<ExamPaper>> getExams({String? subjectId, String? seriesId, String? yearId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _exams.where((e) {
      final matchSubject = subjectId == null || e.subjectId == subjectId;
      final matchSeries = seriesId == null || e.seriesId == seriesId;
      final matchYear = yearId == null || e.yearId == yearId;
      return matchSubject && matchSeries && matchYear;
    }).toList();
  }

  @override
  Future<ExamPaper> getExamById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _exams.firstWhere((e) => e.id == id);
  }
}
