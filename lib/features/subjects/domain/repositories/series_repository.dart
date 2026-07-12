import 'package:bac_nafa/features/subjects/domain/models/bac_series.dart';

abstract class SeriesRepository {
  Future<List<BacSeries>> getSeries();
  Future<BacSeries> getSeriesById(String id);
}
