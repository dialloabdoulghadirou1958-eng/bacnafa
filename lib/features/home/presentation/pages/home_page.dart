import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_section_title.dart';
import 'package:bac_nafa/core/widgets/app_progress_indicator.dart';
import 'package:bac_nafa/core/widgets/app_bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('BacNafa'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryLight,
              child: const Icon(Icons.person, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, Étudiant ! 👋',
              style: AppTextStyles.displayMedium,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Prêt à booster tes révisions aujourd\'hui ?',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSpacing.lg),

            AppCardPremium(
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.stars, color: AppColors.aiAccent),
                      SizedBox(width: 8),
                      Text(
                        'Objectif du jour',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.aiAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Terminer le chapitre sur les Intégrales',
                    style: AppTextStyles.titleMedium,
                  ),
                  SizedBox(height: AppSpacing.md),
                  const AppProgressIndicator(
                    label: 'Progression du chapitre',
                    progress: 0.65,
                    color: AppColors.aiAccent,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Mes Matières',
              subtitle: 'Toutes tes ressources organisées',
              action: Text(
                'Voir tout',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _SubjectCard(
                    title: 'Maths',
                    color: AppColors.tintBlue,
                    icon: Icons.calculate,
                    iconColor: AppColors.primary,
                  ),
                  _SubjectCard(
                    title: 'Physique',
                    color: AppColors.tintOrange,
                    icon: Icons.science,
                    iconColor: Colors.orange,
                  ),
                  _SubjectCard(
                    title: 'SVT',
                    color: AppColors.tintGreen,
                    icon: Icons.biotech,
                    iconColor: Colors.green,
                  ),
                  _SubjectCard(
                    title: 'Philo',
                    color: AppColors.tintPurple,
                    icon: Icons.menu_book,
                    iconColor: Colors.purple,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Ma Préparation',
              subtitle: 'Suis ton évolution vers le Bac',
            ),
            AppCardPremium(
              child: Column(
                children: [
                  const AppProgressIndicator(
                    label: 'Préparation Globale',
                    progress: 0.42,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'Matières', value: '4/6'),
                      _StatItem(label: 'Exercices', value: '12/40'),
                      _StatItem(label: 'Séries', value: '2/10'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Exercices Récents',
              subtitle: 'Reprends là où tu t\'es arrêté',
            ),
            _RecentExerciseItem(
              title: 'Limites et Continuité',
              subject: 'Mathématiques',
              progress: 0.8,
            ),
            SizedBox(height: AppSpacing.sm),
            _RecentExerciseItem(
              title: 'Oxydoréduction',
              subject: 'Physique-Chimie',
              progress: 0.3,
            ),
            SizedBox(height: AppSpacing.xl),

            AppCardPremium(
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              child: Column(
                children: [
                  const Icon(Icons.auto_awesome, size: 48, color: AppColors.aiAccent),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Assistant IA BacNafa',
                    style: AppTextStyles.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Pose tes questions et reçois des explications instantanées.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppPrimaryButton(
                    text: 'Lancer l\'assistant',
                    onPressed: () {},
                    icon: Icons.chat_bubble_outline,
                    backgroundColor: AppColors.aiAccent,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _navIndex,
        onItemSelected: (index) {
          setState(() {
            _navIndex = index;
          });
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _SubjectCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: EdgeInsets.only(right: AppSpacing.sm),
      child: AppCardPremium(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentExerciseItem extends StatelessWidget {
  final String title;
  final String subject;
  final double progress;

  const _RecentExerciseItem({
    required this.title,
    required this.subject,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: () {},
      child: Row(
        children: [
          const Icon(Icons.book_outlined, color: AppColors.textSecondary),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                Text(subject, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: AppProgressIndicator(
              label: '',
              progress: progress,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
