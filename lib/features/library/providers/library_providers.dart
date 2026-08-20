import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/domain/repositories/library_repositories.dart';
import 'package:bac_nafa/features/library/data/mock_library_repositories.dart';
import 'dart:async';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return MockFavoriteRepository();
});

final recentExamRepositoryProvider = Provider<RecentExamRepository>((ref) {
  return MockRecentExamRepository();
});

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, List<FavoriteItem>>(FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<FavoriteItem>> {
  int _generation = 0;
  Completer<void>? _mutex;

  @override
  Future<List<FavoriteItem>> build() async {
    final repository = ref.read(favoriteRepositoryProvider);
    return repository.getFavorites();
  }

  Future<void> _acquireLock() async {
    while (_mutex != null) {
      await _mutex!.future;
    }
    _mutex = Completer<void>();
  }

  void _releaseLock() {
    _mutex?.complete();
    _mutex = null;
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    await _acquireLock();
    try {
      final repository = ref.read(favoriteRepositoryProvider);
      final current = state.value ?? [];
      final isFav = current.any((f) => f.itemId == item.itemId && f.type == item.type);

      // Increment generation to mark this operation
      final thisGeneration = ++_generation;

      if (isFav) {
        final favorite = current.firstWhere(
          (f) => f.itemId == item.itemId && f.type == item.type,
          orElse: () => throw StateError('Favorite not found in state'),
        );
        state = AsyncData(current.where((f) => f.id != favorite.id).toList());
        await repository.removeFavorite(favorite.id);
      } else {
        state = AsyncData([...current, item]);
        await repository.addFavorite(item);
      }

      // Only apply final refresh if no newer operation has started
      if (thisGeneration == _generation) {
        final fresh = await repository.getFavorites();
        if (thisGeneration == _generation) {
          state = AsyncData(fresh);
        }
      }
    } finally {
      _releaseLock();
    }
  }

  bool isFavorite(String itemId, FavoriteType type) {
    final current = state.value;
    if (current == null) return false;
    return current.any((item) => item.itemId == itemId && item.type == type);
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryItem>>(HistoryNotifier.new);

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
