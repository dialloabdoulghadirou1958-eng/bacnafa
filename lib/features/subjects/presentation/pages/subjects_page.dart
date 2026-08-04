import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matières'),
        scrolledUnderElevation: 1,
      ),
      body: subjectsAsync.when(
        data: (subjects) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
                child: _SubjectCard(
                  subject: subject,
                  onTap: () {
                    ref.read(selectedSubjectProvider.notifier).set(subject);
                    context.push('/subjects/${subject.id}/series');
                  },
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(color: AppColors.borderSubtle, width: 1),
                  ),
                  child: const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                ),
                const SizedBox(height: 16),
                Text('Une erreur est survenue', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Text('$err', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final dynamic subject;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subject,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = subject.category == 'Scientifique'
        ? AppColors.secondary
        : AppColors.tertiary;
    final Color categoryBg = subject.category == 'Scientifique'
        ? AppColors.tintBlue
        : AppColors.tintPurple;

    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: categoryBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: categoryColor.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(subject.icon, color: categoryColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subject.name,
                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderSubtle, width: 1),
                      ),
                      child: Text(
                        subject.category,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subject.description,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}