import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
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

    return Scaffold(
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
                Expanded(child: _StatTile(icon: Icons.history_rounded, label: 'Sujets vus', value: historyCount.toString(), color: AppColors.secondary)),
                const SizedBox(width: 10),
                Expanded(child: _StatTile(icon: Icons.star_rounded, label: 'Favoris', value: favoritesCount.toString(), color: AppColors.warning)),
                const SizedBox(width: 10),
                Expanded(child: _StatTile(icon: Icons.psychology_rounded, label: 'IA Aide', value: '12', color: AppColors.tertiary)),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            AppCardPremium(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informations', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 16),
                  _DetailRow(label: 'Série', value: user.bacSeries, icon: Icons.category_rounded),
                  const Divider(height: 28),
                  _DetailRow(label: 'Année du Bac', value: '${user.bacYear}', icon: Icons.calendar_month_rounded),
                  const Divider(height: 28),
                  _DetailRow(label: 'ID Étudiant', value: user.id, icon: Icons.badge_rounded),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            AppCardPremium(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Paramètres', style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 12),
                  _SettingRow(icon: Icons.notifications_rounded, label: 'Notifications', onTap: () {}),
                  const Divider(height: 24),
                  _SettingRow(icon: Icons.lock_rounded, label: 'Sécurité', onTap: () {}),
                  const Divider(height: 24),
                  _SettingRow(icon: Icons.help_outline_rounded, label: 'Aide & Support', onTap: () {}),
                  const Divider(height: 24),
                  _SettingRow(
                    icon: Icons.logout_rounded,
                    label: 'Se déconnecter',
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
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.person_rounded, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(user.name, style: AppTextStyles.displayMedium),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
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
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
        ),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.outline.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}