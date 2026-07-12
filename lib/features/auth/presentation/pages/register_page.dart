import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_text_field.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crée ton compte',
              style: AppTextStyles.displayMedium,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Rejoins des milliers d\'élèves et réussis ton Bac.',
              style: AppTextStyles.bodyMedium,
            ),
            SizedBox(height: AppSpacing.xl),
            const AppTextField(
              label: 'Nom complet',
              hintText: 'Jean Dupont',
              prefixIcon: Icons.person_outline,
            ),
            SizedBox(height: AppSpacing.md),
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
            SizedBox(height: AppSpacing.md),
            const AppTextField(
              label: 'Confirmation mot de passe',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            SizedBox(height: AppSpacing.md),
            const AppTextField(
              label: 'Série Bac',
              hintText: 'Ex: Sciences Expérimentales',
              prefixIcon: Icons.category_outlined,
            ),
            SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              text: 'S\'inscrire',
              onPressed: authStatus == AuthStatus.loading
                  ? null
                  : () async {
                      await ref.read(authProvider.notifier).registerMock();
                      if (context.mounted) {
                        context.go('/home');
                      }
                    },
            ),
            SizedBox(height: AppSpacing.md),
            Center(
              child: TextButton(
                onPressed: () {
                  context.push('/login');
                },
                child: Text(
                  'Déjà un compte ? Connecte-toi',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
