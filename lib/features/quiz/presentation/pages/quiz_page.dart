import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/features/quiz/domain/models/quiz_models.dart';

class QuizPage extends ConsumerStatefulWidget {
  final Quiz quiz;
  const QuizPage({super.key, required this.quiz});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slide = Tween<Offset>(begin: const Offset(0.05, 0.04), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectOption(int index) {
    if (_answered) return;
    final option = widget.quiz.questions[_currentIndex].options[index];
    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (option.isCorrect) _score++;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (_currentIndex < widget.quiz.questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedIndex = null;
          _answered = false;
        });
        _controller.forward(from: 0);
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final total = widget.quiz.questions.length;
    final percentage = (_score / total * 100).round();
    final passed = percentage >= 50;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: passed ? AppColors.successContainer : AppColors.warningContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                passed ? Icons.emoji_events_rounded : Icons.replay_rounded,
                size: 44,
                color: passed ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              passed ? 'Bravo !' : 'Continue à t\'entraîner',
              style: AppTextStyles.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text(
              '$_score / $total correctes',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.circular),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: _score / total),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 10,
                    backgroundColor: AppColors.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      passed ? AppColors.success : AppColors.warning,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 4),
            Text('$percentage%', style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  elevation: 0,
                ),
                child: const Text('Terminer'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentIndex];
    final progress = (_currentIndex + 1) / widget.quiz.questions.length;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title, style: AppTextStyles.titleMedium),
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              children: [
                Text(
                  'Question ${_currentIndex + 1}/${widget.quiz.questions.length}',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text('$_score', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.circular),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Text(
                          question.text,
                          style: AppTextStyles.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: question.options.length,
                          itemBuilder: (context, index) {
                            final option = question.options[index];
                            final isSelected = _selectedIndex == index;
                            final showCorrect = _answered && option.isCorrect;
                            final showIncorrect = _answered && isSelected && !option.isCorrect;

                            Color? bgColor;
                            Color? fgColor;
                            Color? borderColor;
                            IconData? trailingIcon;

                            if (showCorrect) {
                              bgColor = AppColors.successContainer;
                              fgColor = AppColors.success;
                              borderColor = AppColors.success;
                              trailingIcon = Icons.check_circle_rounded;
                            } else if (showIncorrect) {
                              bgColor = AppColors.errorContainer;
                              fgColor = AppColors.error;
                              borderColor = AppColors.error;
                              trailingIcon = Icons.cancel_rounded;
                            } else if (isSelected) {
                              bgColor = AppColors.primaryContainer;
                              fgColor = AppColors.primary;
                              borderColor = AppColors.primary;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOutCubic,
                                decoration: BoxDecoration(
                                  color: bgColor ?? AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: borderColor ?? colorScheme.outlineVariant,
                                    width: isSelected || showCorrect || showIncorrect ? 2 : 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: _answered ? null : () => _selectOption(index),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: (fgColor ?? AppColors.textSecondary).withValues(alpha: 0.12),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              String.fromCharCode(65 + index),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: fgColor ?? AppColors.textSecondary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              option.text,
                                              style: AppTextStyles.titleSmall.copyWith(
                                                color: fgColor ?? AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          if (trailingIcon != null)
                                            Icon(trailingIcon, color: fgColor, size: 22),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}