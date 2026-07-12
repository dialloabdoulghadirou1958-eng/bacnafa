import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_text_field.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppSpacing.xxl),
            const Icon(Icons.school, size: 80, color: AppColors.primary),
            SizedBox(height: AppSpacing.md),
            Text(
              'Bienvenue sur BacNafa',
              style: AppTextStyles.displayMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            const AppTextField(
              label: 'Email ou Téléphone',
              hintText: 'exemple@mail.com',
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: AppSpacing.md),
            const AppTextField(
              label: 'Mot de passe',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              text: 'Se connecter',
              onPressed: authStatus == AuthStatus.loading
                  ? null
                  : () async {
                      await ref.read(authProvider.notifier).loginMock();
                      if (context.mounted) {
                        context.go('/home');
                      }
                    },
            ),
            SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () {
                context.push('/register');
              },
              child: Text(
                'Pas encore de compte ? Inscris-toi',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

