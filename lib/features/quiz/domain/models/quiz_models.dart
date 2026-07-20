class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });
}

class Question {
  final String id;
  final String text;
  final List<Option> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });
}

class Option {
  final String id;
  final String text;
  final bool isCorrect;

  Option({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}
