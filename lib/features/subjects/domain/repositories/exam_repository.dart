import 'package:bac_nafa/features/subjects/domain/models/exam_paper.dart';

abstract class ExamRepository {
  Future<List<ExamPaper>> getExams({
    String? subjectId,
    String? seriesId,
    String? yearId,
  });
  Future<ExamPaper> getExamById(String id);
}
