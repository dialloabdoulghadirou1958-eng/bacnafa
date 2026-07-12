import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/repository_providers.dart';
import 'package:bac_nafa/features/subjects/domain/models/exam_paper.dart';

class ExamPaperDetailPage extends ConsumerWidget {
  const ExamPaperDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final examId = GoRouterState.of(context).pathParameters['id']!;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Détail du Sujet'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<ExamPaper>(
          future: ref.read(examRepositoryProvider).getExamById(examId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }
            final exam = snapshot.data!;

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.title,
                    style: AppTextStyles.displayMedium,
                  ),
                  Text(
                    'Session ${exam.session} - ${exam.yearId}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  SizedBox(height: AppSpacing.xl),
                  
                  const Text('Informations', style: AppTextStyles.titleMedium),
                  SizedBox(height: AppSpacing.md),
                  AppCardPremium(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          _DetailRow(label: 'Durée', value: exam.duration),
                          const Divider(height: 24),
                          _DetailRow(label: 'Coefficient', value: '${exam.coefficient}'),
                          const Divider(height: 24),
                          _DetailRow(label: 'Session', value: exam.session),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),

                  const Text('Exercices', style: AppTextStyles.titleMedium),
                  SizedBox(height: AppSpacing.md),
                  ...[
                    _ExerciseTile(number: 1, title: 'Analyse de fonction et limites'),
                    _ExerciseTile(number: 2, title: 'Étude de suites numériques'),
                    _ExerciseTile(number: 3, title: 'Calcul intégral et aires'),
                  ],
                  SizedBox(height: AppSpacing.xl),

                  const Text('Correction', style: AppTextStyles.titleMedium),
                  SizedBox(height: AppSpacing.md),
                  AppCardPremium(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: exam.hasCorrection 
                        ? const Text('La correction détaillée est disponible en PDF.')
                        : const Text('La correction n\'est pas encore disponible pour ce sujet.'),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                  
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      text: "Demander à l'Assistant IA",
                      onPressed: () {
                        // Navigation vers l'assistant IA avec le contexte du sujet
                        context.push('/ai');
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.titleSmall),
      ],
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final int number;
  final String title;

  const _ExerciseTile({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outline),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.primary,
          child: Text('$number', style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        title: Text(title, style: AppTextStyles.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}
