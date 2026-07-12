import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/features/onboarding/presentation/widgets/selection_card.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class YearsPage extends ConsumerWidget {
  const YearsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsAsync = ref.watch(yearsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Choisir l\'année'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: yearsAsync.when(
          data: (years) => ListView.separated(
            padding: EdgeInsets.all(AppSpacing.lg),
            itemCount: years.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final y = years[index];
              return SelectionCard(
                title: '${y.year}',
                isSelected: ref.watch(selectedYearProvider)?.id == y.id,
                onTap: () {
                  ref.read(selectedYearProvider.notifier).set(y);
                  context.push('/exams');
                },
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Erreur: $err')),
        ),
      ),
    );
  }
}
