import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sujets disponibles'),
        scrolledUnderElevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un sujet…',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.textTertiary, fontSize: 15),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(Icons.search_rounded, color: AppColors.textTertiary, size: 22),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              ref.read(examSearchQueryProvider.notifier).set('');
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20),
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 2),
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text(
                          'Corrigés uniquement',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: correctionOnly == true ? AppColors.onSecondaryContainer : AppColors.textSecondary,
                          ),
                        ),
                        selected: correctionOnly == true,
                        onSelected: (_) {
                          ref.read(examCorrectionFilterProvider.notifier).set(true);
                        },
                        selectedColor: AppColors.secondaryContainer,
                        checkmarkColor: AppColors.secondary,
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      if (correctionOnly == true) ...[
                        const SizedBox(width: 8),
                        ActionChip(
                          label: const Text('Effacer le filtre', style: TextStyle(fontSize: 12)),
                          avatar: const Icon(Icons.close_rounded, size: 16),
                          onPressed: () {
                            ref.read(examCorrectionFilterProvider.notifier).set(null);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: examsAsync.when(
              data: (exams) {
                if (exams.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded, color: AppColors.textTertiary, size: 56),
                        const SizedBox(height: 12),
                        Text('Aucun sujet trouvé', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Essaye un autre terme de recherche', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCardPremium(
                        onTap: () => context.push('/exam/${exam.id}'),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(exam.title, style: AppTextStyles.titleMedium),
                                ),
                                if (exam.hasCorrection)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.successContainer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Corrigé',
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                InfoBadge(icon: Icons.calendar_today_rounded, text: exam.yearId),
                                InfoBadge(icon: Icons.timer_rounded, text: exam.duration),
                                InfoBadge(icon: Icons.grade_rounded, text: 'Coef ${exam.coefficient}'),
                                InfoBadge(icon: Icons.school_rounded, text: exam.session),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: OutlinedButton(
                                onPressed: () => context.push('/exam/${exam.id}'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.outline, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Voir le sujet'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
          ),
        ],
      ),
    );
  }
}