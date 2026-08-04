import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/widgets/app_selection_card.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class YearsPage extends ConsumerWidget {
  const YearsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsAsync = ref.watch(yearsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Année du bac'),
        scrolledUnderElevation: 1,
      ),
      body: yearsAsync.when(
        data: (years) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: years.length,
          itemBuilder: (context, index) {
            final y = years[index];
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 60).clamp(0, 300)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppSelectionCard(
                  title: 'BAC ${y.year}',
                  icon: Icons.school_rounded,
                  isSelected: ref.watch(selectedYearProvider)?.id == y.id,
                  onTap: () {
                    ref.read(selectedYearProvider.notifier).set(y);
                    context.push('/exams');
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