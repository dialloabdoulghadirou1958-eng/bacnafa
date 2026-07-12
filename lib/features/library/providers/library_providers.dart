import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/domain/repositories/library_repositories.dart';
import 'package:bac_nafa/features/library/data/mock_library_repositories.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return MockFavoriteRepository();
});

final recentExamRepositoryProvider = Provider<RecentExamRepository>((ref) {
  return MockRecentExamRepository();
});

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return MockLocalStorageRepository();
});

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<FavoriteItem>>(() {
  return FavoritesNotifier();
});

class FavoritesNotifier extends Notifier<List<FavoriteItem>> {
  @override
  List<FavoriteItem> build() {
    _loadFavorites();
    return [];
  }

  Future<void> _loadFavorites() async {
    final repository = ref.read(favoriteRepositoryProvider);
    state = await repository.getFavorites();
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    final repository = ref.read(favoriteRepositoryProvider);
    final isFav = await repository.isFavorite(item.itemId, item.type);
    if (isFav) {
      final favorite = state.firstWhere((f) => f.itemId == item.itemId && f.type == item.type);
      await repository.removeFavorite(favorite.id);
    } else {
      await repository.addFavorite(item);
    }
    state = await repository.getFavorites();
  }

  bool isFavorite(String itemId, FavoriteType type) {
    return state.any((item) => item.itemId == itemId && item.type == type);
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryItem>>(() {
  return HistoryNotifier();
});

class HistoryNotifier extends Notifier<List<HistoryItem>> {
  @override
  List<HistoryItem> build() {
    _loadHistory();
    return [];
  }

  Future<void> _loadHistory() async {
    final repository = ref.read(recentExamRepositoryProvider);
    state = await repository.getHistory();
  }

  Future<void> addExamToHistory(HistoryItem item) async {
    final repository = ref.read(recentExamRepositoryProvider);
    await repository.addToHistory(item);
    state = await repository.getHistory();
  }
}
