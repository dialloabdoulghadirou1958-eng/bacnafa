import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_section_title.dart';
import 'package:bac_nafa/core/widgets/app_progress_indicator.dart';
import 'package:bac_nafa/core/providers/mock_providers.dart';


class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

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
                ],
              ),
            ),
          ],
        ),
      ),
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
