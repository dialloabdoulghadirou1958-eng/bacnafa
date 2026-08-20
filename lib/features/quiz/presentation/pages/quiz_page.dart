import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
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
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0.04, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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

    Future.delayed(const Duration(milliseconds: 850), () {
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
    final percentage = total == 0 ? 0 : (_score / total * 100).round();
    final passed = percentage >= 50;

    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 22),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMedium,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: passed
                        ? [AppColors.success, const Color(0xFF34D399)]
                        : [AppColors.warning, const Color(0xFFFBBF24)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed ? Icons.emoji_events_rounded : Icons.refresh_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                passed ? 'Belle performance !' : 'On continue ensemble',
                style: AppTextStyles.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                '$_score / $total réponses correctes',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: total == 0 ? 0 : _score / total,
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    passed ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text('$percentage% de réussite', style: AppTextStyles.bodySmall),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go(AppRoutes.home);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Retour à l’accueil'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentIndex];
    final total = widget.quiz.questions.length;
    final progress = total == 0 ? 0.0 : (_currentIndex + 1) / total;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            _QuizTopBar(
              title: widget.quiz.title,
              current: _currentIndex + 1,
              total: total,
              score: _score,
              onClose: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: AppResponsiveContent(
                  padding: EdgeInsets.zero,
                  maxWidth: 840,
                  child: FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _QuestionCard(
                            question: question,
                            number: _currentIndex + 1,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.touch_app_rounded,
                                  color: AppColors.primary,
                                  size: 17,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Text(
                                'Ta réponse',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _answered
                                      ? AppColors.successContainer
                                      : AppColors.surfaceContainer,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  _answered
                                      ? 'Enregistrée'
                                      : 'Choisis une option',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: _answered
                                        ? AppColors.success
                                        : AppColors.textTertiary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...question.options.asMap().entries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 11),
                              child: _AnswerOption(
                                index: entry.key,
                                option: entry.value,
                                selectedIndex: _selectedIndex,
                                answered: _answered,
                                onTap: () => _selectOption(entry.key),
                              ),
                            ),
                          ),
                          if (_answered) ...[
                            const SizedBox(height: 2),
                            _AnswerHint(
                              isCorrect: question
                                  .options[_selectedIndex ?? 0]
                                  .isCorrect,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizTopBar extends StatelessWidget {
  final String title;
  final int current;
  final int total;
  final int score;
  final VoidCallback onClose;

  const _QuizTopBar({
    required this.title,
    required this.current,
    required this.total,
    required this.score,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 16, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Quitter',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  'Question $current sur $total',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warningContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warning,
                  size: 17,
                ),
                const SizedBox(width: 5),
                Text(
                  '$score',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onWarningContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int number;

  const _QuestionCard({required this.question, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF312E81)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.dialog),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -52,
            right: -28,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -70,
            left: 80,
            child: Container(
              width: 170,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.045),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Text(
                        'QUESTION ${number.toString().padLeft(2, '0')}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  question.text,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final int index;
  final Option option;
  final int? selectedIndex;
  final bool answered;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.index,
    required this.option,
    required this.selectedIndex,
    required this.answered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final showCorrect = answered && option.isCorrect;
    final showIncorrect = answered && isSelected && !option.isCorrect;
    final accent = showCorrect
        ? AppColors.success
        : showIncorrect
        ? AppColors.error
        : isSelected
        ? AppColors.primary
        : AppColors.textTertiary;
    final background = showCorrect
        ? AppColors.successContainer
        : showIncorrect
        ? AppColors.errorContainer
        : isSelected
        ? AppColors.primaryContainer
        : AppColors.surface;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(
          color: (showCorrect || showIncorrect || isSelected)
              ? accent
              : AppColors.borderSubtle,
          width: (showCorrect || showIncorrect || isSelected) ? 1.5 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.16),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: -7,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: answered ? null : onTap,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: AppTextStyles.titleSmall.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.text,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: (showCorrect || showIncorrect || isSelected)
                          ? accent
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                if (showCorrect)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 22,
                  ),
                if (showIncorrect)
                  const Icon(
                    Icons.cancel_rounded,
                    color: AppColors.error,
                    size: 22,
                  ),
                if (!answered)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 21,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerHint extends StatelessWidget {
  final bool isCorrect;

  const _AnswerHint({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.celebration_rounded : Icons.info_outline_rounded,
            color: color,
            size: 19,
          ),
          const SizedBox(width: 9),
          Text(
            isCorrect ? 'Bonne réponse !' : 'La bonne réponse est indiquée.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
