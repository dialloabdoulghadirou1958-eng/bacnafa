import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/subjects/domain/models/subject.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SubjectsPageAsSubjects extends ConsumerWidget {
  const SubjectsPageAsSubjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsListProvider);
    final selectedSeries = ref.watch(selectedSeriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Matières')),
      body: subjectsAsync.when(
        data: (subjects) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 32),
          child: AppResponsiveContent(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppPageIntro(
                    eyebrow: 'Ton espace de travail',
                    title: 'Par quelle matière on commence ?',
                    description:
                        'Choisis une matière pour accéder aux sujets, aux corrections et aux sessions d’entraînement.',
                    icon: Icons.menu_book_rounded,
                    accent: AppColors.primary,
                    trailing: _SeriesChip(
                      label: selectedSeries?.name ?? 'Toutes les filières',
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppSectionHeading(
                    title: 'Toutes les matières',
                    subtitle: '${subjects.length} matières disponibles',
                  ),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subjects.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 390,
                          mainAxisExtent: 232,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return _AnimatedSubjectEntry(
                        index: index,
                        child: _SubjectCard(
                          subject: subject,
                          onTap: () {
                            ref
                                .read(selectedSubjectProvider.notifier)
                                .set(subject);
                            context.push(AppRoutes.exam('sample'));
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

class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const _SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = subject.accentColor;
    return AppCardPremium(
      onTap: onTap,
      padding: EdgeInsets.zero,
      shadows: AppShadows.medium,
      border: BorderSide.none,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.08,
                child: SvgPicture.asset(
                  subject.svgAsset,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent,
                    Color.lerp(accent, AppColors.onSurface, 0.28) ?? accent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Icon(
                          subject.icon,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          subject.category,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    subject.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subject.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Voir les sujets',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 19,
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

class _SeriesChip extends StatelessWidget {
  final String label;

  const _SeriesChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _AnimatedSubjectEntry extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedSubjectEntry({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + (index * 55).clamp(0, 320)),
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
