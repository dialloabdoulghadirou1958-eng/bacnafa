import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/core/widgets/app_bottom_navigation.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.toString();
    int navIndex = 0;
    if (location.startsWith('/subjects')) {
      navIndex = 1;
    } else if (location.startsWith('/ai')) {
      navIndex = 2;
    } else if (location.startsWith('/profile')) {
      navIndex = 3;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: navIndex,
        onItemSelected: (index) {
          final routes = ['/home', '/subjects', '/ai', '/profile'];
          context.go(routes[index]);
        },
      ),
    );
  }
}
