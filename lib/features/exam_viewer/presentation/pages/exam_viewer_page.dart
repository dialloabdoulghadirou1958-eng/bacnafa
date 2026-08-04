import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/services/exam_actions.dart';
import 'package:bac_nafa/features/exam_viewer/presentation/widgets/exam_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/features/exam_viewer/providers/exam_providers.dart';

class ExamViewerPage extends ConsumerStatefulWidget {
  final String examId;
  const ExamViewerPage({super.key, required this.examId});

  @override
  ConsumerState<ExamViewerPage> createState() => _ExamViewerPageState();
}

class _ExamViewerPageState extends ConsumerState<ExamViewerPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomBar = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final isAtBottom = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100;
      if (_showBottomBar == isAtBottom) {
        setState(() => _showBottomBar = !isAtBottom);
      }
    });
    _addToHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addToHistory() {
    Future.microtask(() async {
      final examAsync = await ref.read(examContentProvider(widget.examId).future);
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sujet'),
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: isFavorite
                  ? Colors.amber
                  : AppColors.textSecondary,
            ),
            onPressed: () async {
              final exam = examAsync.value;
              if (exam != null) {
                await ref.read(toggleFavoriteActionProvider.notifier)
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
                  const Icon(Icons.search_off_rounded, color: AppColors.textTertiary, size: 56),
                  const SizedBox(height: 12),
                  Text('Sujet non trouvé', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExamHeaderCard(exam: exam),
                      const SizedBox(height: 24),
                      ...exam.sections.map((section) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExamSectionCard(section: section),
                      )),
                      SizedBox(height: _showBottomBar ? 100 : 24),
                    ],
                  ),
                ),
              ),
              if (_showBottomBar)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      boxShadow: AppShadows.soft,
                    ),
                    padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push(
                            '/ai?examId=${exam.id}&title=${Uri.encodeComponent(exam.title)}&subject=${Uri.encodeComponent(exam.subjectName)}',
                          );
                        },
                        icon: const Icon(Icons.psychology_rounded, size: 20),
                        label: const Text('Demander à l\'Assistant IA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          foregroundColor: AppColors.onTertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.button),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 12),
              Text('$err', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}