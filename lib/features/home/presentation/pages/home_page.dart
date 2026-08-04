import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final subjects = ref.watch(subjectsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                  onTap: () => context.push('/profile'),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.person, color: colorScheme.primary, size: 20),
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverList.list(
              children: [
                _GreetingCard(user: user),
                SizedBox(height: AppSpacing.lg),

                _Section(
                  title: 'Matières',
                  subtitle: 'Explorer les sujets',
                  action: 'Voir tout',
                  onAction: () => context.push('/subjects'),
                ),
                SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 112,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    itemCount: subjects.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return _SubjectCard(
                        title: subject.name,
                        icon: subject.icon,
                        color: subject.color,
                        progress: subject.progress,
                        onTap: () => context.push('/subjects'),
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                _Section(
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

                AppCardPremium(
                  shadows: AppShadows.medium,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.psychology_rounded, size: 36, color: AppColors.tertiary),
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        'Besoin d\'aide ?',
                        style: AppTextStyles.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        'Notre IA analyse tes sujets et t\'explique chaque étape en détail.',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/ai'),
                          icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                          label: const Text('Demander à l\'IA'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tertiary,
                            foregroundColor: AppColors.onTertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final dynamic user;
  const _GreetingCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.primary, AppColors.tertiary],
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${user.name}!',
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.bacSeries,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _GreetingStat(icon: Icons.trending_up, label: 'Progression', value: '${(user.progress * 100).toInt()}%'),
              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.2)),
              _GreetingStat(icon: Icons.emoji_events_rounded, label: 'Série', value: user.bacSeries),
              Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.2)),
              _GreetingStat(icon: Icons.calendar_month_rounded, label: 'Bac', value: '${user.bacYear}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GreetingStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _GreetingStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  const _Section({
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
              Text(subtitle, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        if (action != null)
          _LinkButton(label: action!, onTap: onAction),
      ],
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _LinkButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
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
        width: 148,
        child: AppCardPremium(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: AppTextStyles.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: Colors.grey.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text('$year • $series', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          if (hasCorrection)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success, size: 14),
                  const SizedBox(width: 4),
                  Text('Corrigé', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.success)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}