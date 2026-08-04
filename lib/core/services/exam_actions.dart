import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';

final toggleFavoriteActionProvider = NotifierProvider<ToggleFavoriteCoordinator, void>(
  ToggleFavoriteCoordinator.new,
);

class ToggleFavoriteCoordinator extends Notifier<void> {
  @override
  void build() {}

  Future<void> call(String examId, String title) async {
    await ref.read(favoritesProvider.notifier).toggleFavorite(
      FavoriteItem(
        id: '${examId}_fav',
        type: FavoriteType.subject,
        itemId: examId,
        title: title,
        createdAt: DateTime.now(),
      ),
    );
  }
}

final addToHistoryActionProvider = NotifierProvider<AddToHistoryCoordinator, void>(
  AddToHistoryCoordinator.new,
);

class AddToHistoryCoordinator extends Notifier<void> {
  @override
  void build() {}

  Future<void> call(String itemId, String title, String subjectName, String year) async {
    await ref.read(historyProvider.notifier).addExamToHistory(
      HistoryItem(
        itemId: itemId,
        title: title,
        subjectName: subjectName,
        year: year,
        accessedAt: DateTime.now(),
      ),
    );
  }
}

final isFavoriteProvider = Provider.autoDispose.family<bool, String>((ref, examId) {
  return ref.watch(favoritesProvider.select(
    (list) => list.any((f) => f.itemId == examId && f.type == FavoriteType.subject),
  ));
});