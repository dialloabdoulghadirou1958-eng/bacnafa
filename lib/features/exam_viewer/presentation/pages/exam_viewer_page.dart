import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/services/exam_actions.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/exam_viewer/presentation/widgets/exam_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/exam_viewer/providers/exam_providers.dart';

class ExamViewerPage extends ConsumerStatefulWidget {
  final String examId;
  const ExamViewerPage({super.key, required this.examId});

  @override
  ConsumerState<ExamViewerPage> createState() => _ExamViewerPageState();
}

class _ExamViewerPageState extends ConsumerState<ExamViewerPage> {
  @override
  void initState() {
    super.initState();
    _addToHistory();
  }

  void _addToHistory() {
    Future.microtask(() async {
      final examAsync = await ref.read(
        examContentProvider(widget.examId).future,
      );
      if (examAsync != null) {
        await ref.read(addToHistoryActionProvider.notifier)(
          examAsync.id,
          examAsync.title,
          examAsync.subjectName,
          examAsync.year,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final examAsync = ref.watch(examContentProvider(widget.examId));
    final isFavorite = ref.watch(isFavoriteProvider(widget.examId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sujet'),
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isFavorite ? Colors.amber : AppColors.textSecondary,
            ),
            onPressed: () async {
              final exam = examAsync.value;
              if (exam != null) {
                await ref
                    .read(toggleFavoriteActionProvider.notifier)
                    .call(widget.examId, exam.title);
              }
            },
          ),
        ],
      ),
      body: examAsync.when(
        data: (exam) {
          if (exam == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.search_off_rounded,
                    color: AppColors.textTertiary,
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sujet non trouvé',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            child: AppResponsiveContent(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppPageIntro(
                      eyebrow: 'Lecture de l’épreuve',
                      title: exam.subjectName,
                      description:
                          'Prends le temps de lire chaque partie et avance exercice par exercice.',
                      icon: Icons.auto_stories_rounded,
                      accent: AppColors.secondary,
                      trailing: _ExamContext(exam: exam),
                    ),
                    const SizedBox(height: 20),
                    ExamHeaderCard(exam: exam),
                    const SizedBox(height: 26),
                    AppSectionHeading(
                      title: 'Énoncé du sujet',
                      subtitle:
                          '${exam.sections.length} partie${exam.sections.length > 1 ? 's' : ''} à parcourir',
                    ),
                    const SizedBox(height: 14),
                    ...exam.sections.map(
                      (section) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExamSectionCard(section: section),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text(
                '$err',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamContext extends StatelessWidget {
  final dynamic exam;

  const _ExamContext({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [exam.year, exam.session]
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
