import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';

import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SeriesPageAsSeries extends ConsumerWidget {
  final String yearId;
  const SeriesPageAsSeries({super.key, required this.yearId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);
    final selectedYear = ref.watch(selectedYearProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Filière • BAC ${selectedYear?.year ?? ''}'),
        scrolledUnderElevation: 1,
      ),
      body: seriesAsync.when(
        data: (series) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: series.length,
          itemBuilder: (context, index) {
            final s = series[index];
            final delay = index * 60;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 350 + delay.clamp(0, 300)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(opacity: value, child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _SeriesGlassCard(
                  series: s,
                  isSelected: false,
                  onTap: () {
                    ref.read(selectedSeriesProvider.notifier).set(s);
                    context.push(AppRoutes.subjectsOf(yearId, s.id));
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
              Text('Erreur', style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeriesGlassCard extends StatelessWidget {
  final dynamic series;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeriesGlassCard({
    required this.series,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      shadows: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      border: AppBorders.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: Icon(series.icon ?? Icons.category_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            series.name,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            series.description ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choisir',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.primary, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
