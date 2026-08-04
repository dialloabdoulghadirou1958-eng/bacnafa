import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:bac_nafa/features/onboarding/providers/onboarding_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _gradientController;
  late final Animation<double> _gradientAnimation;
  int _currentPage = 0;

  static const _pages = [
    _PageData(
      icon: Icons.psychology_rounded,
      title: 'Prépare ton Bac',
      subtitle: 'BacNafa est ton hub intelligent de sujets, corrections et explications pour réussir ton examen.',
      color: AppColors.primary,
      accent: AppColors.tertiary,
    ),
    _PageData(
      icon: Icons.menu_book_rounded,
      title: 'Choisis ta filière',
      subtitle: 'Sélectionne ta série pour accéder aux sujets adaptés à ton parcours.',
      color: AppColors.secondary,
      accent: AppColors.primary,
    ),
    _PageData(
      icon: Icons.flag_rounded,
      title: 'Définis tes objectifs',
      subtitle: 'Dis-nous ce que tu veux accomplir et nous t\'accompagnerons.',
      color: AppColors.tertiary,
      accent: AppColors.secondary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _gradientAnimation = CurvedAnimation(
      parent: _gradientController,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _goToPage(_currentPage + 1);
    } else {
      ref.read(isFirstLaunchProvider.notifier).setFirstLaunch(false);
      context.go(AppRoutes.login);
    }
  }

  _PageData get _current => _pages[_currentPage];

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _AnimatedGradient(
              listenable: _gradientAnimation,
              startColor: _current.color,
              endColor: _current.accent,
            ),
          ),
          Positioned.fill(
            child: _DecorativeCircles(color: _current.color),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _currentPage > 0
                            ? IconButton(
                                key: const ValueKey('back'),
                                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                                onPressed: () => _goToPage(_currentPage - 1),
                              )
                            : const SizedBox.shrink(key: ValueKey('none')),
                      ),
                      const Spacer(),
                      if (_currentPage < _pages.length - 1)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: TextButton(
                            onPressed: _nextPage,
                            style: TextButton.styleFrom(foregroundColor: Colors.white),
                            child: const Text('Passer'),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    children: [
                      _IntroPage(page: _pages[0]),
                      _SelectionPage(
                        page: _pages[1],
                        title: 'Ton niveau',
                        options: const ['Terminale'],
                        selectedValue: data.selectedClass.isEmpty ? null : data.selectedClass,
                        onSelect: (v) => ref.read(onboardingProvider.notifier).updateClass(v),
                      ),
                      _SeriesSelectionPage(
                        page: _pages[2],
                        title: 'Ta série',
                        series: const [
                          _SerieItem('Sciences Mathématiques', Icons.functions_rounded),
                          _SerieItem('Sciences Expérimentales', Icons.biotech_rounded),
                          _SerieItem('Sciences Sociales', Icons.people_rounded),
                        ],
                        selectedValue: data.selectedSeries.isEmpty ? null : data.selectedSeries,
                        onSelect: (v) => ref.read(onboardingProvider.notifier).updateSeries(v),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    children: [
                      OnboardingIndicator(
                        currentIndex: _currentPage,
                        totalPages: _pages.length,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 20),
                      _AnimatedContinueButton(
                        label: _currentPage == _pages.length - 1 ? 'Commencer' : 'Continuer',
                        color: _current.color,
                        onPressed: _nextPage,
                      ),
                    ],
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

class _PageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color accent;
  const _PageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.accent,
  });
}

class _SerieItem {
  final String name;
  final IconData icon;
  const _SerieItem(this.name, this.icon);
}

class _DecorativeCircles extends StatelessWidget {
  final Color color;
  const _DecorativeCircles({required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final _PageData page;
  const _IntroPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1.5),
                ),
                child: Icon(page.icon, color: Colors.white, size: 64),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              page.title,
              style: AppTextStyles.displayMedium.copyWith(color: Colors.white, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              page.subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionPage extends StatelessWidget {
  final _PageData page;
  final String title;
  final List<String> options;
  final String? selectedValue;
  final void Function(String) onSelect;

  const _SelectionPage({
    required this.page,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        children: [
          _PageHeader(page: page, title: title),
          const SizedBox(height: 24),
          ...options.asMap().entries.map((e) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + e.key * 80),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OnboardingCard(
                  title: e.value,
                  isSelected: selectedValue == e.value,
                  onTap: () => onSelect(e.value),
                  accentColor: page.color,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SeriesSelectionPage extends StatelessWidget {
  final _PageData page;
  final String title;
  final List<_SerieItem> series;
  final String? selectedValue;
  final void Function(String) onSelect;

  const _SeriesSelectionPage({
    required this.page,
    required this.title,
    required this.series,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        children: [
          _PageHeader(page: page, title: title),
          const SizedBox(height: 24),
          ...series.asMap().entries.map((e) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + e.key * 80),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OnboardingCard(
                  title: e.value.name,
                  icon: e.value.icon,
                  isSelected: selectedValue == e.value.name,
                  onTap: () => onSelect(e.value.name),
                  accentColor: page.color,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final _PageData page;
  final String title;
  const _PageHeader({required this.page, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30, width: 1.5),
          ),
          child: Icon(page.icon, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 20),
        Text(title, style: AppTextStyles.displayMedium.copyWith(color: Colors.white, fontSize: 26)),
        const SizedBox(height: 8),
        Text(
          page.subtitle,
          style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.75), height: 1.4),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;
  const _OnboardingCard({
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.25),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: isSelected ? accentColor : Colors.white70, size: 24),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? accentColor : Colors.white,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? Icon(Icons.check_circle_rounded, key: const ValueKey('check'), color: accentColor, size: 24)
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedContinueButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const _AnimatedContinueButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AnimatedGradient extends AnimatedWidget {
  final Color startColor;
  final Color endColor;
  const _AnimatedGradient({
    required super.listenable,
    required this.startColor,
    required this.endColor,
  });

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final dx = animation.value * 0.5;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1 - dx, -1 - dx),
          end: Alignment(1 + dx, 1 + dx),
          colors: [startColor, endColor],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}