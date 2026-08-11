import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';

import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

class SubjectsPageAsSubjects extends ConsumerWidget {
  const SubjectsPageAsSubjects({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(subjectsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matières'),
        scrolledUnderElevation: 1,
      ),
      body: subjectsAsync.when(
        data: (subjects) => ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            final delay = index * 60;
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 350 + delay.clamp(0, 300)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _SubjectModernCard(
                  subject: subject,
                  onTap: () {
                    ref.read(selectedSubjectProvider.notifier).set(subject);
                    context.push(AppRoutes.exam('sample'));
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

class _SubjectModernCard extends StatelessWidget {
  final dynamic subject;
  final VoidCallback onTap;

  const _SubjectModernCard({required this.subject, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = subject.accentColor ?? AppColors.primary;
    return AppCardPremium(
      onTap: onTap,
      padding: EdgeInsets.zero,
      shadows: AppShadows.premium,
      border: AppBorders.none,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: SvgPicture.asset(
                subject.svgAsset ?? 'assets/subjects/education.svg',
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  accent,
                  BlendMode.screen,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.9),
                  accent.withValues(alpha: 0.65),
                  accent.withValues(alpha: 0.4),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    subject.icon ?? Icons.school_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subject.name,
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              subject.category ?? '',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subject.description ?? '',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Commencer',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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
        ],
      ),
    );
  }
}
