class BacSeries {
  final String id;
  final String name;
  final String description;

  const BacSeries({
    required this.id,
    required this.name,
    required this.description,
  });

  BacSeries copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return BacSeries(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
