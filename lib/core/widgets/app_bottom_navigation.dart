import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onItemSelected,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryContainer,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      elevation: 1,
      height: 72,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_rounded, size: 24),
          selectedIcon: Icon(Icons.home, size: 26),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_rounded, size: 24),
          selectedIcon: Icon(Icons.menu_book, size: 26),
          label: 'Sujets',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome, size: 24),
          selectedIcon: Icon(Icons.auto_awesome, size: 26),
          label: 'Assist.',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_rounded, size: 24),
          selectedIcon: Icon(Icons.person, size: 26),
          label: 'Profil',
        ),
      ],
    );
  }
}