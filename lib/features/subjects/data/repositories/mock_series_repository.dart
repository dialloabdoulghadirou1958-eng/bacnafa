import 'package:bac_nafa/features/subjects/domain/models/bac_series.dart';
import 'package:bac_nafa/features/subjects/domain/repositories/series_repository.dart';

class MockSeriesRepository implements SeriesRepository {
  final List<BacSeries> _series = [
    const BacSeries(
      id: 'ser_1',
      name: 'Sciences Mathématiques',
      description: 'Focus intense sur les mathématiques et la physique',
    ),
    const BacSeries(
      id: 'ser_2',
      name: 'Sciences Expérimentales',
      description: 'Focus sur la biologie, chimie et physique',
    ),
    const BacSeries(
      id: 'ser_3',
      name: 'Sciences Sociales',
      description: 'Focus sur l\'économie, sociologie et histoire-géo',
    ),
  ];

  @override
  Future<List<BacSeries>> getSeries() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _series;
  }

  @override
  Future<BacSeries> getSeriesById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _series.firstWhere((s) => s.id == id);
  }
}
