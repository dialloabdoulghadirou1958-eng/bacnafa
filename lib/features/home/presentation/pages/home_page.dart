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
import 'package:bac_nafa/core/services/library_counts.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/quiz/providers/quiz_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final subjects = ref.watch(subjectsProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final quizCount = ref
        .watch(quizzesCountProvider)
        .maybeWhen(data: (count) => count, orElse: () => 0);

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
                    const SizedBox(height: 24),
                    const AppSectionHeading(
                      title: 'Ton plan de révision',
                      subtitle: 'Des raccourcis pour avancer aujourd’hui',
                    ),
                    const SizedBox(height: 12),
                    _DailyActions(
                      favoritesCount: favoritesCount,
                      quizCount: quizCount,
                      onQuizTap: () => context.push(AppRoutes.quiz('1')),
                      onSubjectsTap: () => context.push(AppRoutes.subjects),
                      onLibraryTap: () => context.push('/library'),
                    ),
                    const SizedBox(height: 28),
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
                    const SizedBox(height: 28),
                    _MotivationCard(
                      progress: user.progress,
                      onTap: () => context.push(AppRoutes.profile),
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
      expandedHeight: 250,
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
                padding: const EdgeInsets.fromLTRB(24, 70, 24, 16),
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
                        const SizedBox(height: 12),
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

class _DailyActions extends StatelessWidget {
  final int favoritesCount;
  final int quizCount;
  final VoidCallback onQuizTap;
  final VoidCallback onSubjectsTap;
  final VoidCallback onLibraryTap;

  const _DailyActions({
    required this.favoritesCount,
    required this.quizCount,
    required this.onQuizTap,
    required this.onSubjectsTap,
    required this.onLibraryTap,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _PlanAction(
        icon: Icons.bolt_rounded,
        label: 'Quiz express',
        detail: quizCount == 0
            ? 'S’entraîner'
            : '$quizCount disponible${quizCount > 1 ? 's' : ''}',
        color: AppColors.tertiary,
        onTap: onQuizTap,
      ),
      _PlanAction(
        icon: Icons.description_rounded,
        label: 'Un sujet',
        detail: 'Lire & comprendre',
        color: AppColors.secondary,
        onTap: onSubjectsTap,
      ),
      _PlanAction(
        icon: Icons.bookmark_rounded,
        label: 'Mes favoris',
        detail: '$favoritesCount enregistré${favoritesCount > 1 ? 's' : ''}',
        color: AppColors.warning,
        onTap: onLibraryTap,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 640) {
          return Row(
            children: actions
                .map(
                  (action) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: action == actions.last ? 0 : 12,
                      ),
                      child: _PlanActionCard(action: action),
                    ),
                  ),
                )
                .toList(),
          );
        }

        return SizedBox(
          height: 112,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: actions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) => SizedBox(
              width: 158,
              child: _PlanActionCard(action: actions[index]),
            ),
          ),
        );
      },
    );
  }
}

class _PlanAction {
  final IconData icon;
  final String label;
  final String detail;
  final Color color;
  final VoidCallback onTap;

  const _PlanAction({
    required this.icon,
    required this.label,
    required this.detail,
    required this.color,
    required this.onTap,
  });
}

class _PlanActionCard extends StatelessWidget {
  final _PlanAction action;

  const _PlanActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: action.onTap,
      padding: const EdgeInsets.all(13),
      shadows: AppShadows.subtle,
      border: AppBorders.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: action.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(action.icon, color: action.color, size: 18),
              ),
              const Spacer(),
              Icon(Icons.arrow_outward_rounded, color: action.color, size: 17),
            ],
          ),
          const Spacer(),
          Text(
            action.label,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            action.detail,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  final double progress;
  final VoidCallback onTap;

  const _MotivationCard({required this.progress, required this.onTap});

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
            colors: [AppColors.secondary, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Petit pas, grand résultat',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tu as déjà ${(progress * 100).round()}% du chemin. Continue avec une courte session.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
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
              mainAxisExtent: 126,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) =>
                _SubjectCard(subject: subjects[index], onTap: onTap),
          );
        }

        return SizedBox(
          height: 126,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: subjects.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 158,
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
      padding: const EdgeInsets.all(12),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: subject.color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(subject.icon, color: subject.color, size: 20),
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
