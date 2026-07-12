import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/exam_viewer/models/exam_content.dart';

class ExamHeaderCard extends StatelessWidget {
  final ExamContent exam;

  const ExamHeaderCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exam.year,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: [
              _HeaderInfoChip(label: 'Série', value: exam.series),
              _HeaderInfoChip(label: 'Session', value: exam.session),
              _HeaderInfoChip(label: 'Durée', value: exam.duration),
              _HeaderInfoChip(label: 'Coef', value: exam.coefficient.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderInfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderInfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            section.title,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (section.content.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              section.content,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ...section.exercises.map((ex) => ExerciseCard(exercise: ex)),
      ],
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final ExamExercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCardPremium(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercice ${exercise.number}',
                  style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Text(
                    '${exercise.points} pts',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              exercise.statement,
              style: AppTextStyles.bodyMedium,
            ),
            if (exercise.attachments.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: AttachmentPreview(attachments: exercise.attachments),
              ),
          ],
        ),
      ),
    );
  }
}

class AttachmentPreview extends StatelessWidget {
  final List<String> attachments;

  const AttachmentPreview({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: attachments.map((att) => Padding(
        padding: EdgeInsets.only(right: AppSpacing.sm),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.image, size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text(
                'Pièce jointe',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}
