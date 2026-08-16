import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/design/app_radius.dart';

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
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.card),
          ),
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle),
            left: BorderSide(color: AppColors.borderSubtle),
            right: BorderSide(color: AppColors.borderSubtle),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, -7),
              spreadRadius: -12,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.card),
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onItemSelected,
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.primaryContainer,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            height: 74,
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
      ),
    );
  }
}
