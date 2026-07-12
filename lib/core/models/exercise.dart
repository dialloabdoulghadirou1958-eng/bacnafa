class Exercise {
  final String id;
  final String title;
  final String difficulty; // 'Easy', 'Medium', 'Hard'
  final bool completed;

  const Exercise({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.completed,
  });

  Exercise copyWith({
    String? title,
    String? difficulty,
    bool? completed,
  }) {
    return Exercise(
      id: id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      completed: completed ?? this.completed,
    );
  }
}
