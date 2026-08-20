import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/app/theme/app_theme.dart';
import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/models/student_profile.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/core/services/auth_actions.dart';
import 'package:bac_nafa/core/services/library_counts.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/quiz/providers/quiz_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final historyCount = ref.watch(historyCountProvider);
    final quizzesCountAsync = ref.watch(quizzesCountProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightOnDarkStatusBar,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 178,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              systemOverlayStyle: AppTheme.lightOnDarkStatusBar,
              title: const Text('Mon profil'),
              actions: [
                IconButton.filledTonal(
                  onPressed: () => _showSettingsSheet(context, ref),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  tooltip: 'Paramètres',
                ),
                const SizedBox(width: 10),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _ProfileHero(user: user),
              ),
            ),
            SliverToBoxAdapter(
              child: AppResponsiveContent(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final statWidth = constraints.maxWidth >= 700
                              ? (constraints.maxWidth - 24) / 3
                              : null;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: statWidth,
                                child: _StatTile(
                                  icon: Icons.history_rounded,
                                  label: 'Sujets vus',
                                  value: historyCount.toString(),
                                  color: AppColors.secondary,
                                ),
                              ),
                              SizedBox(
                                width: statWidth,
                                child: _StatTile(
                                  icon: Icons.bookmark_rounded,
                                  label: 'Favoris',
                                  value: favoritesCount.toString(),
                                  color: AppColors.warning,
                                ),
                              ),
                              SizedBox(
                                width: statWidth,
                                child: _StatTile(
                                  icon: Icons.quiz_rounded,
                                  label: 'Quiz terminés',
                                  value: quizzesCountAsync.maybeWhen(
                                    data: (count) => count.toString(),
                                    orElse: () => '—',
                                  ),
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      AppSectionHeading(
                        title: 'Ton évolution',
                        subtitle: 'Chaque petite session compte',
                      ),
                      const SizedBox(height: 12),
                      _ProgressCard(progress: user.progress),
                      const SizedBox(height: 22),
                      AppSectionHeading(title: 'Informations du profil'),
                      const SizedBox(height: 12),
                      _ProfileDetails(user: user),
                      const SizedBox(height: 22),
                      _ProfileTip(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SettingsSheet(ref: ref),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final StudentProfile user;

  const _ProfileHero({required this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF312E81),
                  AppColors.primary,
                  Color(0xFF0E7490),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: -50,
          top: -76,
          child: _ProfileOrb(
            size: 160,
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 52, 24, 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Row(
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MON ESPACE',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              letterSpacing: 1.15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.16),
                              ),
                            ),
                            child: Text(
                              '${user.bacSeries}  •  BAC ${user.bacYear}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;

  const _ProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      padding: const EdgeInsets.all(18),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Row(
        children: [
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 850),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => CircularProgressIndicator(
                    value: value,
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    backgroundColor: AppColors.primaryContainer,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progression globale',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Continue à avancer régulièrement pour te rapprocher de ton objectif.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.warning,
                      size: 17,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Garde ton rythme',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      padding: const EdgeInsets.all(14),
      shadows: AppShadows.subtle,
      border: AppBorders.subtle,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  final StudentProfile user;

  const _ProfileDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shadows: AppShadows.subtle,
      border: AppBorders.subtle,
      child: Column(
        children: [
          _DetailRow(
            label: 'Série',
            value: user.bacSeries,
            icon: Icons.category_rounded,
          ),
          _DetailDivider(),
          _DetailRow(
            label: 'Année du Bac',
            value: '${user.bacYear}',
            icon: Icons.calendar_month_rounded,
          ),
          _DetailDivider(),
          _DetailRow(
            label: 'ID étudiant',
            value: user.id,
            icon: Icons.badge_rounded,
          ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: AppColors.borderSubtle);
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: AppColors.primary, size: 17),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.tips_and_updates_rounded,
            color: AppColors.secondary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Astuce : une session de 15 minutes vaut mieux qu’une longue pause.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  final WidgetRef ref;

  const _SettingsSheet({required this.ref});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderMedium,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text('Paramètres', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 10),
            _SettingRow(
              icon: Icons.notifications_rounded,
              label: 'Notifications',
              onTap: () {},
            ),
            _SettingRow(
              icon: Icons.lock_rounded,
              label: 'Sécurité',
              onTap: () {},
            ),
            _SettingRow(
              icon: Icons.help_outline_rounded,
              label: 'Aide & support',
              onTap: () {},
            ),
            const Divider(height: 20),
            _SettingRow(
              icon: Icons.logout_rounded,
              label: 'Se déconnecter',
              isDestructive: true,
              onTap: () {
                Navigator.of(context).pop();
                ref.read(logoutActionProvider.notifier).call();
                context.go(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    final iconColor = isDestructive ? AppColors.error : AppColors.textSecondary;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 19),
      ),
      title: Text(
        label,
        style: AppTextStyles.bodyLarge.copyWith(
          color: color,
          fontWeight: isDestructive ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: iconColor.withValues(alpha: 0.55),
      ),
    );
  }
}

class _ProfileOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _ProfileOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
