class ExamPaper {
  final String id;
  final String title;
  final String subjectId;
  final String seriesId;
  final String yearId;
  final String session;
  final String duration;
  final double coefficient;
  final bool hasCorrection;

  const ExamPaper({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.seriesId,
    required this.yearId,
    required this.session,
    required this.duration,
    required this.coefficient,
    required this.hasCorrection,
  });

  ExamPaper copyWith({
    String? id,
    String? title,
    String? subjectId,
    String? seriesId,
    String? yearId,
    String? session,
    String? duration,
    double? coefficient,
    bool? hasCorrection,
  }) {
    return ExamPaper(
      id: id ?? this.id,
      title: title ?? this.title,
      subjectId: subjectId ?? this.subjectId,
      seriesId: seriesId ?? this.seriesId,
      yearId: yearId ?? this.yearId,
      session: session ?? this.session,
      duration: duration ?? this.duration,
      coefficient: coefficient ?? this.coefficient,
      hasCorrection: hasCorrection ?? this.hasCorrection,
    );
  }
}
