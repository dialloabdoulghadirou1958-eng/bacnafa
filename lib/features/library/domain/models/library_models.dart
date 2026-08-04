

enum FavoriteType { subject, conversation }

class FavoriteItem {
  final String id;
  final FavoriteType type;
  final String itemId;
  final String title;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.type,
    required this.itemId,
    required this.title,
    required this.createdAt,
  });

  FavoriteItem copyWith({
    String? id,
    FavoriteType? type,
    String? itemId,
    String? title,
    DateTime? createdAt,
  }) {
    return FavoriteItem(
      id: id ?? this.id,
      type: type ?? this.type,
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Future implementation: Map<String, dynamic> toJson()
  // Future implementation: factory FavoriteItem.fromJson(Map<String, dynamic> json)
}

class HistoryItem {
  final String itemId;
  final String title;
  final String subjectName;
  final String year;
  final DateTime accessedAt;

  HistoryItem({
    required this.itemId,
    required this.title,
    required this.subjectName,
    required this.year,
    required this.accessedAt,
  });

  HistoryItem copyWith({
    String? itemId,
    String? title,
    String? subjectName,
    String? year,
    DateTime? accessedAt,
  }) {
    return HistoryItem(
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      subjectName: subjectName ?? this.subjectName,
      year: year ?? this.year,
      accessedAt: accessedAt ?? this.accessedAt,
    );
  }
}
