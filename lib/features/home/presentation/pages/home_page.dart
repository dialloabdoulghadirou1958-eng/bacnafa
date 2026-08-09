import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final subjects = ref.watch(subjectsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HomeSliverAppBar(user: user),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            sliver: SliverList.list(
              children: [
                _SectionHeader(
                  title: 'Matières',
                  subtitle: 'Explorer les sujets',
                  action: 'Voir tout',
                  onAction: () => context.push(AppRoutes.subjects),
                ),
                SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 124,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    itemCount: subjects.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return _SubjectCard(
                        title: subject.name,
                        icon: subject.icon,
                        color: subject.color,
                        progress: subject.progress,
                        onTap: () => context.push(AppRoutes.subjects),
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                _SectionHeader(
                  title: 'Reprendre',
                  subtitle: 'Mes dernières consultations',
                ),
                SizedBox(height: AppSpacing.sm),
                _RecentExamCard(
                  subject: 'Mathématiques',
                  year: 'BAC 2026',
                  series: 'Science Maths',
                  hasCorrection: true,
                  onTap: () {},
                ),
                SizedBox(height: AppSpacing.sm),
                _RecentExamCard(
                  subject: 'Physique-Chimie',
                  year: 'BAC 2025',
                  series: 'Sciences Expér.',
                  hasCorrection: false,
                  onTap: () {},
                ),
                SizedBox(height: AppSpacing.lg),

                SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSliverAppBar extends StatelessWidget {
  final dynamic user;
  const _HomeSliverAppBar({required this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        'BacNafa',
        style: AppTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.w800),
      ),
      centerTitle: false,
      pinned: true,
      floating: false,
      snap: false,
      expandedHeight: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.profile),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.circular),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: Center(
                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 22),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.headlineSmall),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final double progress;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: AppCardPremium(
          padding: const EdgeInsets.all(16),
          shadows: AppShadows.medium,
          border: AppBorders.subtle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: AppColors.surfaceContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentExamCard extends StatelessWidget {
  final String subject;
  final String year;
  final String series;
  final bool hasCorrection;
  final VoidCallback onTap;

  const _RecentExamCard({
    required this.subject,
    required this.year,
    required this.series,
    required this.hasCorrection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle, width: 1),
            ),
            child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('$year • $series', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (hasCorrection)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.successContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Corrigé',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle, width: 1),
              ),
              child: Text(
                'Sans correction',
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
            ),
        ],
      ),
    );
  }
}

