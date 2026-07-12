class BacYear {
  final String id;
  final int year;

  const BacYear({
    required this.id,
    required this.year,
  });

  BacYear copyWith({
    String? id,
    int? year,
  }) {
    return BacYear(
      id: id ?? this.id,
      year: year ?? this.year,
    );
  }
}
