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
import 'package:bac_nafa/core/widgets/app_progress_indicator.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final favoritesCount = ref.watch(favoritesCountProvider);
    final historyCount = ref.watch(historyCountProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightStatusBar,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mon Profil'),
          scrolledUnderElevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            children: [
              _ProfileHeader(user: user),
              SizedBox(height: AppSpacing.lg),

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
                      icon: Icons.psychology_rounded,
                      label: 'IA Aide',
                      value: '12',
                      color: AppColors.tertiary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),

              AppCardPremium(
                padding: const EdgeInsets.all(20),
                shadows: AppShadows.soft,
                border: AppBorders.subtle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progression', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 16),
                    AppProgressIndicator(
                      label: 'Préparation Bac',
                      progress: user.progress,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              AppCardPremium(
                padding: const EdgeInsets.all(20),
                shadows: AppShadows.soft,
                border: AppBorders.subtle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informations', style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 16),
                    _DetailRow(label: 'Série', value: user.bacSeries, icon: Icons.category_rounded),
                    Divider(height: 28, color: AppColors.borderSubtle),
                    _DetailRow(label: 'Année du Bac', value: '${user.bacYear}', icon: Icons.calendar_month_rounded),
                    Divider(height: 28, color: AppColors.borderSubtle),
                    _DetailRow(label: 'ID Étudiant', value: user.id, icon: Icons.badge_rounded),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.lg),

              AppCardPremium(
                padding: const EdgeInsets.all(20),
                shadows: AppShadows.soft,
                border: AppBorders.subtle,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        ref.read(logoutActionProvider.notifier).call();
                        context.go(AppRoutes.login);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.circular),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
              boxShadow: AppShadows.medium,
            ),
            child: Icon(Icons.person_rounded, size: 52, color: AppColors.primary),
          ),
          const SizedBox(height: 14),
          Text(user.name, style: AppTextStyles.displayMedium.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2), width: 1),
            ),
            child: Text(
              'Élève en ${user.bacSeries}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSecondaryContainer),
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      shadows: AppShadows.soft,
      border: AppBorders.subtle,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: color, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
        ),
        Text(value, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
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
                style: AppTextStyles.bodyLarge.copyWith(color: labelColor, fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w400),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: chevronColor),
          ],
        ),
      ),
    );
  }
}