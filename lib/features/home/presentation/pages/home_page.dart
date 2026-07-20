import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_section_title.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              'Prépare ton Bac avec les sujets et l\'aide de l\'IA.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSpacing.lg),

            // Barre de recherche principale
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.search, color: AppColors.textSecondary),
                  hintText: 'Rechercher un sujet, une matière...',
                  border: InputBorder.none,
                  hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                onSubmitted: (value) {},
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Quiz',
              subtitle: 'Test your knowledge',
            ),
            SizedBox(height: AppSpacing.sm),
            AppPrimaryButton(
              text: 'Start Math Quiz',
              onPressed: () => context.push('/quiz/1'),
              icon: Icons.quiz,
              backgroundColor: AppColors.primary,
            ),
            SizedBox(height: AppSpacing.xl),
            const AppSectionTitle(
              title: 'Explorer les sujets',
              subtitle: 'Trouve rapidement tes épreuves',
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
                    title: 'Mathématiques',
                    color: AppColors.tintBlue,
                    icon: Icons.calculate,
                    iconColor: AppColors.primary,
                    onTap: () => context.push('/subjects'),
                  ),
                  _SubjectCard(
                    title: 'Physique',
                    color: AppColors.tintOrange,
                    icon: Icons.science,
                    iconColor: Colors.orange,
                    onTap: () => context.push('/subjects'),
                  ),
                  _SubjectCard(
                    title: 'Chimie',
                    color: AppColors.tintGreen,
                    icon: Icons.biotech,
                    iconColor: Colors.green,
                    onTap: () => context.push('/subjects'),
                  ),
                  _SubjectCard(
                    title: 'Français',
                    color: AppColors.tintPurple,
                    icon: Icons.language,
                    iconColor: Colors.purple,
                    onTap: () => context.push('/subjects'),
                  ),
                  _SubjectCard(
                    title: 'Philosophie',
                    color: AppColors.tintBlue,
                    icon: Icons.menu_book,
                    iconColor: AppColors.primary,
                    onTap: () => context.push('/subjects'),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xl),

            const AppSectionTitle(
              title: 'Mes derniers sujets',
              subtitle: 'Reprends tes révisions',
            ),
            _RecentSubjectItem(
              subject: 'Mathématiques',
              year: 'BAC 2026',
              series: 'Sciences Mathématiques',
              hasCorrection: true,
              onTap: () {},
            ),
            SizedBox(height: AppSpacing.sm),
            _RecentSubjectItem(
              subject: 'Physique-Chimie',
              year: 'BAC 2025',
              series: 'Sciences Expérimentales',
              hasCorrection: false,
              onTap: () {},
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
                    'Besoin d\'aide sur un sujet ?',
                    style: AppTextStyles.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'L\'Assistant IA analyse tes sujets et t\'aide à comprendre chaque étape.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: AppSpacing.md),
                  AppPrimaryButton(
                    text: 'Demander à l\'IA',
                    onPressed: () => context.push('/ai'),
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
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSubjectItem extends StatelessWidget {
  final String subject;
  final String year;
  final String series;
  final bool hasCorrection;
  final VoidCallback onTap;

  const _RecentSubjectItem({
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
      child: Row(
        children: [
          const Icon(Icons.description_outlined, color: AppColors.primary),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: AppTextStyles.titleSmall),
                SizedBox(height: 2),
                Text(
                  '$year • $series',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          if (hasCorrection)
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.md),
              child: Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
            ),
          const Icon(Icons.chevron_right, color: AppColors.outline),
        ],
      ),
    );
  }
}
