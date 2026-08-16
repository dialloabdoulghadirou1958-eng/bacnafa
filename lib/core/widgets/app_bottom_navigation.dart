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
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.borderSubtle)),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onItemSelected,
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primaryContainer,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Accueil',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_rounded),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Sujets',
            ),
            NavigationDestination(
              icon: Icon(Icons.quiz_rounded),
              selectedIcon: Icon(Icons.quiz_rounded),
              label: 'Quiz',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
