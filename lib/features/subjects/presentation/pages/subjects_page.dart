import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Matières'), scrolledUnderElevation: 1),
      body: subjectsAsync.when(
        data: (subjects) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            final delay = index * 60;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 350 + delay.clamp(0, 400)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCardPremium(
                  onTap: () {
                    ref.read(selectedSubjectProvider.notifier).set(subject);
                    context.push(
                      '/subjects/${subject.id}/series',
                    );
                  },
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: subject.category == 'Scientifique'
                              ? AppColors.tintBlue
                              : AppColors.tintPurple,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(subject.icon, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(subject.name, style: AppTextStyles.titleMedium),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    subject.category,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subject.description,
                              style: AppTextStyles.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, color: AppColors.outline.withValues(alpha: 0.5)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 12),
                Text('Une erreur est survenue', style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text('$err', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}