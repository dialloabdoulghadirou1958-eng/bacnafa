import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/features/onboarding/presentation/widgets/illustration_circle.dart';
import 'package:bac_nafa/features/onboarding/presentation/widgets/selection_card.dart';
import 'package:bac_nafa/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:bac_nafa/features/onboarding/providers/onboarding_provider.dart';
import 'package:bac_nafa/features/onboarding/models/onboarding_data.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildPage1(),
                  _buildPage2(onboardingData),
                  _buildPage3(onboardingData),
                  _buildPage4(onboardingData),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OnboardingIndicator(currentIndex: _currentPage, totalPages: 4),
                  SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: AppPrimaryButton(
                      text: _currentPage == 3 ? 'Commencer' : 'Suivant',
                      onPressed: _nextPage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(),
          const IllustrationCircle(
            label: 'Apprentissage Intelligent',
            icon: Icons.auto_awesome,
            color: AppColors.primary,
          ),
          SizedBox(height: AppSpacing.xxl),
          Text(
            'Prépare ton Bac intelligemment',
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'BacNafa est ton compagnon d\'apprentissage personnel pour réussir ton examen avec confiance.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPage2(OnboardingData data) {
    final classes = ['Terminale', 'Première', 'Seconde'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(),
          const IllustrationCircle(
            label: 'Ton Parcours',
            icon: Icons.map,
            color: AppColors.secondary,
          ),
          SizedBox(height: AppSpacing.xxl),
          Text(
            'Choisis ton parcours',
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium,
          ),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: classes.map((c) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: SelectionCard(
                  title: c,
                  isSelected: data.selectedClass == c,
                  onTap: () => ref.read(onboardingProvider.notifier).updateClass(c),
                ),
              )).toList(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPage3(OnboardingData data) {
    final series = [
      {'name': 'Sciences Mathématiques', 'icon': Icons.functions},
      {'name': 'Sciences Expérimentales', 'icon': Icons.biotech},
      {'name': 'Sciences Sociales', 'icon': Icons.people},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(),
          const IllustrationCircle(
            label: 'Ta Série',
            icon: Icons.category,
            color: AppColors.aiAccent,
          ),
          SizedBox(height: AppSpacing.xxl),
          Text(
            'Quelle est ta série ?',
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium,
          ),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: series.map((s) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: SelectionCard(
                  title: s['name'] as String,
                  icon: s['icon'] as IconData,
                  isSelected: data.selectedSeries == s['name'],
                  onTap: () => ref.read(onboardingProvider.notifier).updateSeries(s['name'] as String),
                ),
              )).toList(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPage4(OnboardingData data) {
    final goals = [
      'Réviser mes cours',
      'Faire des exercices',
      'Comprendre mes erreurs',
      'Préparer les examens',
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const Spacer(),
          const IllustrationCircle(
            label: 'Tes Objectifs',
            icon: Icons.flag,
            color: Colors.green,
          ),
          SizedBox(height: AppSpacing.xxl),
          Text(
            'Quel est ton objectif ?',
            textAlign: TextAlign.center,
            style: AppTextStyles.displayMedium,
          ),
          SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: goals.map((g) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: SelectionCard(
                  title: g,
                  isSelected: data.selectedGoals.contains(g),
                  onTap: () {
                    final currentGoals = Set<String>.from(data.selectedGoals);
                    if (currentGoals.contains(g)) {
                      currentGoals.remove(g);
                    } else {
                      currentGoals.add(g);
                    }
                    ref.read(onboardingProvider.notifier).updateGoals(currentGoals.toList());
                  },
                ),
              )).toList(),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
