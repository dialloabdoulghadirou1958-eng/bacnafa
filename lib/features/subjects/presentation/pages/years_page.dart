import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_year.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class YearsPageAsYears extends ConsumerWidget {
  const YearsPageAsYears({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsAsync = ref.watch(yearsListProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sujets du Bac')),
      body: yearsAsync.when(
        data: (years) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: AppResponsiveContent(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppPageIntro(
                    eyebrow: 'Bibliothèque de sujets',
                    title: 'Choisis ton année',
                    description:
                        'Retrouve les épreuves et corrections qui correspondent à ton objectif.',
                    icon: Icons.calendar_month_rounded,
                    accent: AppColors.primary,
                    trailing: _IntroBadge(
                      label: 'Cible ${user.bacYear}',
                      icon: Icons.flag_rounded,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppSectionHeading(
                    title: 'Années disponibles',
                    subtitle: '${years.length} sessions à explorer',
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: years.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          mainAxisExtent: 136,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      final year = years[index];
                      return _AnimatedEntry(
                        index: index,
                        child: _YearCard(
                          year: year,
                          isCurrent: year.year == user.bacYear,
                          onTap: () {
                            ref.read(selectedYearProvider.notifier).set(year);
                            context.push(AppRoutes.series(year.id));
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
        error: (error, _) => _SubjectsError(message: '$error'),
      ),
    );
  }
}

class _YearCard extends StatelessWidget {
  final BacYear year;
  final bool isCurrent;
  final VoidCallback onTap;

  const _YearCard({
    required this.year,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCurrent
                    ? [AppColors.primary, AppColors.secondary]
                    : [
                        AppColors.surfaceContainer,
                        AppColors.surfaceContainerHigh,
                      ],
              ),
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            child: Icon(
              Icons.school_rounded,
              color: isCurrent ? Colors.white : AppColors.primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BAC ${year.year}',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCurrent ? 'Ton année cible' : 'Voir les épreuves',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: isCurrent ? AppColors.primary : AppColors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _IntroBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _IntroBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedEntry extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedEntry({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + (index * 65).clamp(0, 300)),
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

class _SubjectsError extends StatelessWidget {
  final String message;

  const _SubjectsError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.error,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'Impossible de charger les sujets',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
