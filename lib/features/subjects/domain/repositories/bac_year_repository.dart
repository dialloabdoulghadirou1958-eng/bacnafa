import 'package:bac_nafa/features/subjects/domain/models/bac_year.dart';

abstract class BacYearRepository {
  Future<List<BacYear>> getYears();
}
