import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';
import 'package:bac_nafa/features/onboarding/providers/onboarding_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkLaunchStatus();
  }

  void _checkLaunchStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    final isFirstLaunch = ref.read(isFirstLaunchProvider);
    final authStatus = ref.read(authProvider);

    if (isFirstLaunch) {
      context.go('/onboarding');
    } else if (authStatus == AuthStatus.authenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
               child: Image.asset(
                 'assets/branding/app_icon.jpg',
                 width: 80,
                 height: 80,
               ),

            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'BacNafa',
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Ton succès commence ici',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
