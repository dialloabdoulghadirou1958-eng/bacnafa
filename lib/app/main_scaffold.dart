import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import '../../core/widgets/app_bottom_navigation.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.toString();
    int navIndex = _computeIndex(location);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightStatusBar,
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: KeyedSubtree(
            key: ValueKey(navIndex),
            child: child,
          ),
        ),
        bottomNavigationBar: AppBottomNavigation(
          currentIndex: navIndex,
          onItemSelected: (index) {
            final routes = ['/home', '/subjects', '/ai', '/profile'];
            context.go(routes[index]);
          },
        ),
      ),
    );
  }

  int _computeIndex(String location) {
    if (location.startsWith('/subjects')) return 1;
    if (location.startsWith('/ai')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }
}