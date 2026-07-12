import 'package:bac_nafa/features/subjects/domain/models/bac_year.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/bac_year_repository.dart';

class MockBacYearRepository implements BacYearRepository {
  final List<BacYear> _years = [
    const BacYear(id: 'y2026', year: 2026),
    const BacYear(id: 'y2025', year: 2025),
    const BacYear(id: 'y2024', year: 2024),
    const BacYear(id: 'y2023', year: 2023),
  ];

  @override
  Future<List<BacYear>> getYears() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _years;
  }
}
