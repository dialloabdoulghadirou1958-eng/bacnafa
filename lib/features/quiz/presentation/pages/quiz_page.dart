import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/quiz/domain/models/quiz_models.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';

class QuizPage extends ConsumerStatefulWidget {
  final Quiz quiz;
  const QuizPage({super.key, required this.quiz});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  void _answerQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _score++;
      });
    }
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Show result
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Finished', style: AppTextStyles.titleMedium),
          content: Text('Your score: $_score / ${widget.quiz.questions.length}', style: AppTextStyles.bodyMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.quiz.questions.length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.quiz.title, style: AppTextStyles.titleMedium),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceVariant,
            color: AppColors.primary,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: AppColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.outline.withValues(alpha: 0.1)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Text(
                        question.text,
                        style: AppTextStyles.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  ...question.options.map((option) => Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surface,
                            foregroundColor: AppColors.textPrimary,
                            elevation: 0,
                            padding: EdgeInsets.all(AppSpacing.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
                            ),
                          ),
                          onPressed: () => _answerQuestion(option.isCorrect),
                          child: Text(option.text, style: AppTextStyles.titleSmall),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
