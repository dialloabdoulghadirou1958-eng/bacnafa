import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';

final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider.select(
    (asyncValue) => asyncValue.maybeWhen(data: (list) => list.length, orElse: () => 0),
  ));
});

final historyCountProvider = Provider<int>((ref) {
  return ref.watch(historyProvider.select((list) => list.length));
});