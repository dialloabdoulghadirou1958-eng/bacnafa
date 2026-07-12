import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_section_title.dart';
import 'package:bac_nafa/core/widgets/app_progress_indicator.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final favoritesCount = ref.watch(favoritesProvider).length;
    final historyCount = ref.watch(historyProvider).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 50, color: AppColors.primary),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    user.name,
                    style: AppTextStyles.displayMedium,
                  ),
                  Text(
                    'Élève en ${user.bacSeries}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            AppCardPremium(
              child: Column(
                children: [
                  const AppSectionTitle(
                    title: 'Mon Activité Bac',
                    subtitle: 'Suivi de ta préparation',
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ActivityStat(
                        label: 'Sujets vus', 
                        value: historyCount.toString(), 
                        icon: Icons.history,
                      ),
                      _ActivityStat(
                        label: 'Favoris', 
                        value: favoritesCount.toString(), 
                        icon: Icons.star,
                      ),
                      _ActivityStat(
                        label: 'IA Aide', 
                        value: '12', 
                        icon: Icons.auto_awesome,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            AppCardPremium(
              child: Column(
                children: [
                  const AppSectionTitle(
                    title: 'Progression Globale',
                    subtitle: 'Ton avancée vers le succès',
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppProgressIndicator(
                    label: 'Préparation au Bac',
                    progress: user.progress,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Informations Académiques',
              subtitle: 'Détails de ton inscription',
            ),
            AppCardPremium(
              child: Column(
                children: [
                  _ProfileDetailRow(label: 'Série', value: user.bacSeries),
                  const Divider(height: 24),
                  _ProfileDetailRow(label: 'Année du Bac', value: '${user.bacYear}'),
                  const Divider(height: 24),
                  _ProfileDetailRow(label: 'ID Étudiant', value: user.id),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Paramètres',
              subtitle: 'Gère ton compte et tes préférences',
            ),
            AppCardPremium(
              child: Column(
                children: [
                  _SettingItem(icon: Icons.notifications, title: 'Notifications'),
                  const Divider(height: 24),
                  _SettingItem(icon: Icons.lock, title: 'Sécurité'),
                  const Divider(height: 24),
                  _SettingItem(icon: Icons.help_outline, title: 'Aide & Support'),
                  const Divider(height: 24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text('Se déconnecter', style: AppTextStyles.bodyLarge.copyWith(color: Colors.red)),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
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

class _ActivityStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ActivityStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.titleMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
      onTap: () {},
    );
  }
}
