import 'package:bac_nafa/features/library/domain/models/library_models.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(FavoriteItem item);
  Future<void> removeFavorite(String favoriteId);
  Future<List<FavoriteItem>> getFavorites();
  Future<bool> isFavorite(String itemId, FavoriteType type);
}

abstract class RecentExamRepository {
  Future<void> addToHistory(HistoryItem item);
  Future<List<HistoryItem>> getHistory();
}

abstract class LocalStorageRepository {
  // Prepared for future persistence (SQLite, Hive, etc.)
  Future<void> save(String key, dynamic value);
  Future<dynamic> load(String key);
  Future<void> delete(String key);
}
