class Exercise {
  final String id;
  final String title;
  final int number;

  const Exercise({
    required this.id,
    required this.title,
    required this.number,
  });

  Exercise copyWith({
    String? id,
    String? title,
    int? number,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
    );
  }
}
