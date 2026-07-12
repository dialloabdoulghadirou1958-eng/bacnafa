import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';
import 'package:bac_nafa/features/exam_viewer/providers/exam_providers.dart';
import 'package:bac_nafa/features/exam_viewer/presentation/widgets/exam_widgets.dart';
import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';

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
    // We use Future.microtask to avoid updating state during build
    Future.microtask(() async {
      final examAsync = await ref.read(examContentProvider(widget.examId).future);
      if (examAsync != null) {
        ref.read(historyProvider.notifier).addExamToHistory(
          HistoryItem(
            itemId: examAsync.id,
            title: examAsync.title,
            subjectName: examAsync.subjectName,
            year: examAsync.year,
            accessedAt: DateTime.now(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final examAsync = ref.watch(examContentProvider(widget.examId));
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sujet'),
        actions: [
          IconButton(
            icon: Icon(
              favorites.any((f) => f.itemId == widget.examId && f.type == FavoriteType.subject) 
                ? Icons.star 
                : Icons.star_border,
              color: favorites.any((f) => f.itemId == widget.examId && f.type == FavoriteType.subject) 
                ? Colors.amber 
                : AppColors.textSecondary,
            ),
            onPressed: () async {
              final exam = examAsync.value;
              if (exam != null) {
                await ref.read(favoritesProvider.notifier).toggleFavorite(
                  FavoriteItem(
                    id: '${widget.examId}_fav',
                    type: FavoriteType.subject,
                    itemId: widget.examId,
                    title: exam.title,
                    createdAt: DateTime.now(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: examAsync.when(
        data: (exam) {
          if (exam == null) {
            return const Center(child: Text('Sujet non trouvé'));
          }

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExamHeaderCard(exam: exam),
                        SizedBox(height: AppSpacing.xl),
                        ...exam.sections.map((section) => ExamSectionCard(section: section)),
                        SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
                _buildBottomActionBar(context, exam),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ExamContent exam) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: AppPrimaryButton(
            text: 'Demander à l\'Assistant IA',
            onPressed: () {
              context.push(
                '/ai?examId=${exam.id}&title=${Uri.encodeComponent(exam.title)}&subject=${Uri.encodeComponent(exam.subjectName)}',
              );
            },
            icon: Icons.auto_awesome,
            backgroundColor: AppColors.aiAccent,
          ),
        ),
      ),
    );
  }
}
