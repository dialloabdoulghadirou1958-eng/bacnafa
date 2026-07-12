import 'package:bac_nafa/features/subjects/domain/models/subject.dart';

abstract class SubjectRepository {
  Future<List<Subject>> getSubjects();
  Future<Subject> getSubjectById(String id);
}
