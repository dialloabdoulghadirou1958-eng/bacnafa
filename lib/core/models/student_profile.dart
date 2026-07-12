class StudentProfile {
  final String id;
  final String name;
  final String bacSeries;
  final int bacYear;
  final double progress;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.bacSeries,
    required this.bacYear,
    required this.progress,
  });

  StudentProfile copyWith({
    String? name,
    String? bacSeries,
    int? bacYear,
    double? progress,
  }) {
    return StudentProfile(
      id: id,
      name: name ?? this.name,
      bacSeries: bacSeries ?? this.bacSeries,
      bacYear: bacYear ?? this.bacYear,
      progress: progress ?? this.progress,
    );
  }
}
