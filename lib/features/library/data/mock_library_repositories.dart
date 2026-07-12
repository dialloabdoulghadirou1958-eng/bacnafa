import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/domain/repositories/library_repositories.dart';

class MockFavoriteRepository implements FavoriteRepository {
  final List<FavoriteItem> _favorites = [];

  @override
  Future<void> addFavorite(FavoriteItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _favorites.add(item);
  }

  @override
  Future<void> removeFavorite(String favoriteId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _favorites.removeWhere((item) => item.id == favoriteId);
  }

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_favorites);
  }

  @override
  Future<bool> isFavorite(String itemId, FavoriteType type) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _favorites.any((item) => item.itemId == itemId && item.type == type);
  }
}

class MockRecentExamRepository implements RecentExamRepository {
  final List<HistoryItem> _history = [];

  @override
  Future<void> addToHistory(HistoryItem item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Remove if already exists to bring to top
    _history.removeWhere((h) => h.itemId == item.itemId);
    _history.insert(0, item);
    if (_history.length > 20) {
      _history.removeLast();
    }
  }

  @override
  Future<List<HistoryItem>> getHistory() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_history);
  }
}

class MockLocalStorageRepository implements LocalStorageRepository {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> save(String key, dynamic value) async {
    _storage[key] = value;
  }

  @override
  Future<dynamic> load(String key) async {
    return _storage[key];
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }
}
