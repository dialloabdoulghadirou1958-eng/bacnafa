import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_section_title.dart';
import 'package:bac_nafa/core/widgets/app_progress_indicator.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/core/models/subject.dart';

class SubjectsPage extends ConsumerWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mes Matières'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSectionTitle(
              title: 'Toutes les matières',
              subtitle: 'Suis ton avancement par discipline',
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return _SubjectCard(subject: subject);
                },
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            const AppSectionTitle(
              title: 'Détails du programme',
              subtitle: 'Accède aux chapitres et exercices',
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCardPremium(
                    onTap: () {},
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: subject.color.withValues(alpha: 0.2),
                        child: Icon(subject.icon, color: subject.color),
                      ),
                      title: Text(subject.name, style: AppTextStyles.titleMedium),
                      subtitle: Text(subject.description, style: AppTextStyles.bodySmall),
                      trailing: Text(
                        '${(subject.progress * 100).toInt()}%',
                        style: AppTextStyles.labelMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: AppSpacing.md),
      child: AppCardPremium(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: subject.color.withValues(alpha: 0.2),
              child: Icon(subject.icon, color: subject.color, size: 30),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              subject.name,
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            AppProgressIndicator(
              label: 'Progression',
              progress: subject.progress,
              color: subject.color,
            ),
          ],
        ),
      ),
    );
  }
}
