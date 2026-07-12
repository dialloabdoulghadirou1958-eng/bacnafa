import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/features/onboarding/presentation/widgets/selection_card.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SeriesPage extends ConsumerWidget {
  const SeriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);
    final selectedSubject = ref.watch(selectedSubjectProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(selectedSubject?.name ?? 'Séries'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: seriesAsync.when(
          data: (series) => ListView.separated(
            padding: EdgeInsets.all(AppSpacing.lg),
            itemCount: series.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final s = series[index];
              return SelectionCard(
                title: s.name,
                isSelected: ref.watch(selectedSeriesProvider)?.id == s.id,
                onTap: () {
                  ref.read(selectedSeriesProvider.notifier).set(s);
                  context.push('/subjects/${selectedSubject?.id}/series/${s.id}/years');
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
