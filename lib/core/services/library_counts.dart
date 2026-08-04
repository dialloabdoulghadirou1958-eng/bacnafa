import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';

final favoritesCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider.select((list) => list.length));
});

final historyCountProvider = Provider<int>((ref) {
  return ref.watch(historyProvider.select((list) => list.length));
});