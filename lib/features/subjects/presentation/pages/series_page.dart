import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/widgets/app_selection_card.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SeriesPage extends ConsumerWidget {
  const SeriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);
    final selectedSubject = ref.watch(selectedSubjectProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedSubject?.name ?? 'Séries'),
        scrolledUnderElevation: 1,
      ),
      body: seriesAsync.when(
        data: (series) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: series.length,
          itemBuilder: (context, index) {
            final s = series[index];
            return delay(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppSelectionCard(
                  title: s.name,
                  icon: Icons.category_rounded,
                  isSelected: ref.watch(selectedSeriesProvider)?.id == s.id,
                  onTap: () {
                    ref.read(selectedSeriesProvider.notifier).set(s);
                    context.push(
                      '/subjects/${selectedSubject?.id}/series/${s.id}/years',
                    );
                  },
                ),
              ),
            );
          },
        ),
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
    );
  }
}

Widget delay({required int index, required Widget child}) {
  return TweenAnimationBuilder<double>(
    duration: Duration(milliseconds: 300 + (index * 60).clamp(0, 300)),
    tween: Tween(begin: 0.0, end: 1.0),
    curve: Curves.easeOutCubic,
    builder: (context, value, c) {
      return Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      );
    },
  );
}