import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';
import 'package:bac_nafa/features/subjects/presentation/widgets/info_badge.dart';

class ExamPapersPage extends ConsumerWidget {
  const ExamPapersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examsAsync = ref.watch(filteredExamsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sujets disponibles'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un sujet...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) => ref.read(examSearchQueryProvider.notifier).set(val),
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtres:',
                      style: AppTextStyles.bodySmall,
                    ),
                    FilterChip(
                      label: const Text('Correction disponible'),
                      selected: ref.watch(examCorrectionFilterProvider) == true,
                      onSelected: (val) {
                        ref.read(examCorrectionFilterProvider.notifier).set(val ? true : null);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: examsAsync.when(
          data: (exams) {
            if (exams.isEmpty) {
              return const Center(child: Text('Aucun sujet trouvé'));
            }
            return ListView.separated(
              padding: EdgeInsets.all(AppSpacing.lg),
              itemCount: exams.length,
              separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final exam = exams[index];
                return AppCardPremium(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                exam.title,
                                style: AppTextStyles.titleMedium,
                              ),
                            ),
                            if (exam.hasCorrection)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Corrigé',
                                  style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.md,
                          children: [
                            InfoBadge(icon: Icons.calendar_today, text: exam.yearId),
                            InfoBadge(icon: Icons.timer, text: exam.duration),
                            InfoBadge(icon: Icons.grade, text: 'Coeff: ${exam.coefficient}'),
                            InfoBadge(icon: Icons.info, text: exam.session),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md),
                        TextButton(
                          onPressed: () => context.push('/exam/${exam.id}'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                          child: const Text('Voir le sujet'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur: $err')),
        ),
      ),
    );
  }
}
