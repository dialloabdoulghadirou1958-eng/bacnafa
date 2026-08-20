import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';
import 'package:bac_nafa/features/subjects/domain/models/exam_paper.dart';
import 'package:bac_nafa/features/subjects/presentation/widgets/info_badge.dart';

class ExamPapersPage extends ConsumerStatefulWidget {
  const ExamPapersPage({super.key});

  @override
  ConsumerState<ExamPapersPage> createState() => _ExamPapersPageState();
}

class _ExamPapersPageState extends ConsumerState<ExamPapersPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      ref.read(examSearchQueryProvider.notifier).set(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examsAsync = ref.watch(filteredExamsProvider);
    final correctionOnly = ref.watch(examCorrectionFilterProvider);
    final subject = ref.watch(selectedSubjectProvider);
    final series = ref.watch(selectedSeriesProvider);
    final year = ref.watch(selectedYearProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sujets disponibles')),
      body: Column(
        children: [
          AppResponsiveContent(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  AppPageIntro(
                    eyebrow: 'Bibliothèque',
                    title: subject?.name ?? 'Explore les épreuves',
                    description:
                        'Recherche rapidement un sujet et ouvre sa correction quand elle est disponible.',
                    icon: Icons.description_rounded,
                    accent: subject?.accentColor ?? AppColors.primary,
                    trailing: _ContextPills(
                      year: year?.year,
                      series: series?.name,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, _) => TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un sujet…',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: value.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: _searchController.clear,
                                icon: const Icon(Icons.close_rounded),
                                tooltip: 'Effacer',
                              ),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          borderSide: BorderSide(color: AppColors.borderSubtle),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          borderSide: BorderSide(color: AppColors.borderSubtle),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          avatar: const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 16,
                          ),
                          label: const Text('Avec correction'),
                          selected: correctionOnly == true,
                          onSelected: (_) => ref
                              .read(examCorrectionFilterProvider.notifier)
                              .set(correctionOnly == true ? null : true),
                        ),
                        if (correctionOnly == true)
                          ActionChip(
                            avatar: const Icon(Icons.close_rounded, size: 16),
                            label: const Text('Réinitialiser'),
                            onPressed: () => ref
                                .read(examCorrectionFilterProvider.notifier)
                                .set(null),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: examsAsync.when(
              data: (exams) {
                if (exams.isEmpty) return const _EmptyExams();
                return AppResponsiveContent(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 28),
                    itemCount: exams.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final exam = exams[index];
                      return _ExamCard(exam: exam);
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              error: (error, _) => Center(
                child: Text('$error', style: AppTextStyles.bodyMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamCard extends StatelessWidget {
  final ExamPaper exam;

  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: () => context.push('/exam/${exam.id}'),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: exam.hasCorrection
                  ? AppColors.successContainer
                  : AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(
              exam.hasCorrection
                  ? Icons.task_alt_rounded
                  : Icons.article_outlined,
              color: exam.hasCorrection ? AppColors.success : AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exam.title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (exam.hasCorrection) _CorrectionPill(),
                  ],
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    InfoBadge(
                      icon: Icons.calendar_today_rounded,
                      text: exam.yearId,
                    ),
                    InfoBadge(icon: Icons.timer_rounded, text: exam.duration),
                    InfoBadge(
                      icon: Icons.grade_rounded,
                      text: 'Coef ${exam.coefficient}',
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Row(
                  children: [
                    Text(
                      'Ouvrir le sujet',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrectionPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.successContainer,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        'Corrigé',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ContextPills extends StatelessWidget {
  final int? year;
  final String? series;

  const _ContextPills({this.year, this.series});

  @override
  Widget build(BuildContext context) {
    final labels = <String>[
      ...?(year == null ? null : ['BAC $year']),
      ...?(series == null ? null : [series!]),
    ];
    if (labels.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: labels
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _EmptyExams extends StatelessWidget {
  const _EmptyExams();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: AppColors.textTertiary,
              size: 34,
            ),
          ),
          const SizedBox(height: 14),
          Text('Aucun sujet trouvé', style: AppTextStyles.titleMedium),
          const SizedBox(height: 5),
          Text(
            'Essaie un autre terme ou retire le filtre.',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
