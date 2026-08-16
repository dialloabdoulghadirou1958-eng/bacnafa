import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_navigation.dart';

class MainScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppTheme.lightStatusBar,
          child: Scaffold(
            body: Row(
              children: [
                if (isWide)
                  _DesktopNavigation(navigationShell: navigationShell),
                Expanded(child: navigationShell),
              ],
            ),
            bottomNavigationBar: isWide
                ? null
                : AppBottomNavigation(
                    currentIndex: navigationShell.currentIndex,
                    onItemSelected: (index) => navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _DesktopNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _DesktopNavigation({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 236,
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.22),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Image.asset('assets/branding/app_icon.png'),
                ),
                const SizedBox(width: 10),
                Text(
                  'BacNafa',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 38),
          Text(
            'ESPACE RÉVISION',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              extended: true,
              minExtendedWidth: 200,
              groupAlignment: -1,
              indicatorColor: AppColors.primaryContainer,
              selectedIconTheme: const IconThemeData(color: AppColors.primary),
              unselectedIconTheme: const IconThemeData(
                color: AppColors.textTertiary,
              ),
              selectedLabelTextStyle: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
              unselectedLabelTextStyle: AppTextStyles.titleSmall.copyWith(
                color: AppColors.textSecondary,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_rounded),
                  label: Text('Accueil'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.menu_book_rounded),
                  label: Text('Sujets'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.quiz_rounded),
                  label: Text('Quiz'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_rounded),
                  label: Text('Profil'),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.52),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Chaque question te rapproche du Bac.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onPrimaryContainer,
                    ),
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
