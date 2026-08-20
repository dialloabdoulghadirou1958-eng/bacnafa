import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_series.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SeriesPageAsSeries extends ConsumerWidget {
  final String yearId;

  const SeriesPageAsSeries({super.key, required this.yearId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesListProvider);
    final selectedYear = ref.watch(selectedYearProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Filières • BAC ${selectedYear?.year ?? ''}')),
      body: seriesAsync.when(
        data: (series) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: AppResponsiveContent(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppPageIntro(
                    eyebrow: 'Deuxième étape',
                    title: 'Choisis ta filière',
                    description:
                        'Chaque parcours ouvre une sélection de sujets pensée pour tes matières fortes.',
                    icon: Icons.route_rounded,
                    accent: AppColors.secondary,
                    trailing: _SelectionHint(
                      text: 'BAC ${selectedYear?.year ?? yearId}',
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppSectionHeading(
                    title: 'Les parcours',
                    subtitle: 'Sélectionne celui qui te ressemble',
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: series.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 380,
                          mainAxisExtent: 150,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      final item = series[index];
                      return _AnimatedSeriesEntry(
                        index: index,
                        child: _SeriesCard(
                          series: item,
                          onTap: () {
                            ref.read(selectedSeriesProvider.notifier).set(item);
                            context.push(AppRoutes.subjectsOf(yearId, item.id));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (error, _) => Center(
          child: Text('Erreur : $error', style: AppTextStyles.bodyMedium),
        ),
      ),
    );
  }
}

class _SeriesCard extends StatelessWidget {
  final BacSeries series;
  final VoidCallback onTap;

  const _SeriesCard({required this.series, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = series.accentColor;
    return AppCardPremium(
      onTap: onTap,
      padding: EdgeInsets.zero,
      shadows: AppShadows.soft,
      border: BorderSide(color: accent.withValues(alpha: 0.16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            Positioned(
              top: -28,
              right: -18,
              child: Icon(
                series.icon,
                size: 126,
                color: accent.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: accent),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 14, 11),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, accent.withValues(alpha: 0.045)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accent, accent.withValues(alpha: 0.68)],
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.22),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(series.icon, color: Colors.white, size: 19),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          series.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: accent,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      series.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Explorer la filière',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.10),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: accent,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionHint extends StatelessWidget {
  final String text;

  const _SelectionHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AnimatedSeriesEntry extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedSeriesEntry({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + (index * 60).clamp(0, 300)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
