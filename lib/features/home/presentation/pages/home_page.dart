import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/app/theme/app_theme.dart';
import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/models/subject.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final subjects = ref.watch(subjectsProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _HomeHero(userName: user.name, progress: user.progress),
          SliverToBoxAdapter(
            child: AppResponsiveContent(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _QuickStartCard(
                      onTap: () => context.push(AppRoutes.subjects),
                    ),
                    const SizedBox(height: 30),
                    AppSectionHeading(
                      title: 'Tes matières',
                      subtitle: 'Continue là où tu t’es arrêté',
                      actionLabel: 'Tout voir',
                      onAction: () => context.push(AppRoutes.subjects),
                    ),
                    const SizedBox(height: 14),
                    _SubjectCollection(
                      subjects: subjects,
                      onTap: () => context.push(AppRoutes.subjects),
                    ),
                    const SizedBox(height: 30),
                    AppSectionHeading(
                      title: 'Reprendre une session',
                      subtitle: 'Tes dernières consultations',
                    ),
                    const SizedBox(height: 14),
                    const _RecentExamCard(
                      subject: 'Mathématiques',
                      year: 'BAC 2026',
                      series: 'Sciences Mathématiques',
                      hasCorrection: true,
                    ),
                    const SizedBox(height: 12),
                    const _RecentExamCard(
                      subject: 'Physique-Chimie',
                      year: 'BAC 2025',
                      series: 'Sciences Expérimentales',
                      hasCorrection: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  final String userName;
  final double progress;

  const _HomeHero({required this.userName, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 292,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: AppTheme.lightOnDarkStatusBar,
      title: Text(
        'BacNafa',
        style: AppTextStyles.titleLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton.filledTonal(
            onPressed: () => context.push(AppRoutes.profile),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.16),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.person_rounded, size: 21),
            tooltip: 'Mon profil',
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF312E81),
                      Color(0xFF4F46E5),
                      Color(0xFF0E7490),
                    ],
                    stops: [0, 0.58, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -82,
              right: -48,
              child: _HeroOrb(
                size: 220,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              bottom: -96,
              left: -84,
              child: _HeroOrb(
                size: 230,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 84, 24, 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1020),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BONJOUR, ${userName.split(' ').first.toUpperCase()} 👋',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Prêt à faire\nprogresser ton Bac ?',
                          style: AppTextStyles.displaySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.08,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ProgressSummary(progress: progress),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  final double progress;

  const _ProgressSummary({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          const Icon(Icons.insights_rounded, color: Colors.white, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progression globale',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.78),
                  ),
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 7,
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Text(
            '${(progress * 100).round()}%',
            style: AppTextStyles.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStartCard extends StatelessWidget {
  final VoidCallback onTap;

  const _QuickStartCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: EdgeInsets.zero,
      shadows: AppShadows.medium,
      border: AppBorders.none,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surface, AppColors.primaryContainer],
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Objectif du jour', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Lance une nouvelle session de révision',
                    style: AppTextStyles.titleMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectCollection extends StatelessWidget {
  final List<CoreSubject> subjects;
  final VoidCallback onTap;

  const _SubjectCollection({required this.subjects, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              mainAxisExtent: 148,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) =>
                _SubjectCard(subject: subjects[index], onTap: onTap),
          );
        }

        return SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: subjects.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 188,
              child: _SubjectCard(subject: subjects[index], onTap: onTap),
            ),
          ),
        );
      },
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final CoreSubject subject;
  final VoidCallback onTap;

  const _SubjectCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: subject.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(subject.icon, color: subject.color, size: 22),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
          const Spacer(),
          Text(
            subject.name,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: subject.progress,
                    minHeight: 5,
                    backgroundColor: AppColors.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(subject.color),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(subject.progress * 100).round()}%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: subject.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentExamCard extends StatelessWidget {
  final String subject;
  final String year;
  final String series;
  final bool hasCorrection;

  const _RecentExamCard({
    required this.subject,
    required this.year,
    required this.series,
    required this.hasCorrection,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: () => context.push(AppRoutes.subjects),
      padding: const EdgeInsets.all(16),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Row(
        children: [
          const IconBadgeForRecent(),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$year  •  $series',
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _StatusPill(hasCorrection: hasCorrection),
        ],
      ),
    );
  }
}

class IconBadgeForRecent extends StatelessWidget {
  const IconBadgeForRecent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Icon(
        Icons.description_rounded,
        color: AppColors.secondary,
        size: 22,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool hasCorrection;

  const _StatusPill({required this.hasCorrection});

  @override
  Widget build(BuildContext context) {
    final color = hasCorrection ? AppColors.success : AppColors.textTertiary;
    final background = hasCorrection
        ? AppColors.successContainer
        : AppColors.surfaceContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasCorrection ? Icons.check_circle_rounded : Icons.schedule_rounded,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            hasCorrection ? 'Corrigé' : 'À revoir',
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _HeroOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
