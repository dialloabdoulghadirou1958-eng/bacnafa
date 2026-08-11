import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/app/theme/app_theme.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_shadows.dart';
import 'package:bac_nafa/core/design/app_borders.dart';
import 'package:bac_nafa/core/services/auth_actions.dart';
import 'package:bac_nafa/core/services/library_counts.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/features/quiz/providers/quiz_providers.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final historyCount = ref.watch(historyCountProvider);
    final quizzesCountAsync = ref.watch(quizzesCountProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightStatusBar,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Mon Profil'),
              scrolledUnderElevation: 1,
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_rounded, color: AppColors.primary, size: 22),
                  tooltip: 'Paramètres',
                  onPressed: () => _showSettingsSheet(context, ref),
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  _ProfileHeader(user: user),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.history_rounded,
                          label: 'Sujets vus',
                          value: historyCount.toString(),
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.star_rounded,
                          label: 'Favoris',
                          value: favoritesCount.toString(),
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.quiz_rounded,
                          label: 'Quiz',
                          value: quizzesCountAsync.maybeWhen(
                            data: (c) => c.toString(),
                            orElse: () => '—',
                          ),
                          color: AppColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  AppCardPremium(
                    padding: const EdgeInsets.all(16),
                    shadows: AppShadows.subtle,
                    border: AppBorders.subtle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.trending_up_rounded,
                                color: AppColors.primary,
                                size: 17,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Progression',
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                            const Spacer(),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: user.progress),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Text(
                                  '${(value * 100).toInt()}%',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(left: 44),
                          child: Text(
                            'Avancement global vers le Bac',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.circular),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: user.progress),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return LinearProgressIndicator(
                                value: value,
                                minHeight: 8,
                                backgroundColor: AppColors.surfaceContainer,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  AppCardPremium(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shadows: AppShadows.subtle,
                    border: AppBorders.subtle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.primary,
                                size: 17,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Informations',
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                            label: 'Série',
                            value: user.bacSeries,
                            icon: Icons.category_rounded),
                        Divider(
                            height: 16,
                            thickness: 0.8,
                            color: AppColors.borderSubtle),
                        _DetailRow(
                            label: 'Année du Bac',
                            value: '${user.bacYear}',
                            icon: Icons.calendar_month_rounded),
                        Divider(
                            height: 16,
                            thickness: 0.8,
                            color: AppColors.borderSubtle),
                        _DetailRow(
                            label: 'ID Étudiant',
                            value: user.id,
                            icon: Icons.badge_rounded),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _SettingsSheetContent(ref: ref, context: context),
      ),
    );
  }
}

class _SettingsSheetContent extends StatelessWidget {
  final WidgetRef ref;
  final BuildContext context;

  const _SettingsSheetContent({required this.ref, required this.context});

  @override
  Widget build(BuildContext _) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Paramètres', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 12),
            _SettingRow(icon: Icons.notifications_rounded, label: 'Notifications', onTap: () {}),
            Divider(height: 24, color: AppColors.borderSubtle),
            _SettingRow(icon: Icons.lock_rounded, label: 'Sécurité', onTap: () {}),
            Divider(height: 24, color: AppColors.borderSubtle),
            _SettingRow(icon: Icons.help_outline_rounded, label: 'Aide & Support', onTap: () {}),
            Divider(height: 24, color: AppColors.borderSubtle),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.circular),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2), width: 2),
            ),
            child: const Icon(Icons.person_rounded,
                size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school_rounded,
                    size: 14, color: AppColors.secondary),
                const SizedBox(width: 5),
                Text(
                  'Élève en ${user.bacSeries} • ${user.bacYear}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSecondaryContainer,
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      shadows: AppShadows.subtle,
      border: AppBorders.subtle,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
                color: color, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textTertiary, fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary, fontSize: 13)),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.textPrimary),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDestructive ? AppColors.error : AppColors.textSecondary;
    final labelColor = isDestructive ? AppColors.error : AppColors.textPrimary;
    final chevronColor = isDestructive ? AppColors.error.withValues(alpha: 0.5) : AppColors.outline.withValues(alpha: 0.5);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: iconColor.withValues(alpha: 0.2), width: 1),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: labelColor,
                  fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: chevronColor),
          ],
        ),
      ),
    );
  }
}
