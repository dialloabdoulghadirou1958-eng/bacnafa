import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';

class ExamHeaderCard extends StatelessWidget {
  final ExamContent exam;
  const ExamHeaderCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exam.year,
                  style: TextStyle(
                    color: AppColors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  exam.subjectName,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            exam.title,
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _Chip(label: 'Série', value: exam.series, icon: Icons.category_rounded),
              _Chip(label: 'Session', value: exam.session, icon: Icons.schedule_rounded),
              _Chip(label: 'Durée', value: exam.duration, icon: Icons.timer_rounded),
              _Chip(label: 'Coefficient', value: exam.coefficient.toStringAsFixed(0), icon: Icons.speed_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _Chip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text('$label ', style: AppTextStyles.bodySmall),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class ExamSectionCard extends StatelessWidget {
  final ExamSection section;
  const ExamSectionCard({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  section.title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (section.content.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              section.content,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
          ),
        ],
        const SizedBox(height: 12),
        ...section.exercises.map((ex) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ExerciseCard(exercise: ex),
        )),
      ],
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final ExamExercise exercise;
  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${exercise.number}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Exercice ${exercise.number}',
                  style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${exercise.points} pts',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            exercise.statement,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.55),
          ),
          if (exercise.attachments.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: exercise.attachments.map((att) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.image_rounded, size: 14, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        att,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}