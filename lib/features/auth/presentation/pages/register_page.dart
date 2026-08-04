import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_text_field.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _serieController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _serieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authProvider);
    final isLoading = authStatus == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Crée ton compte', style: AppTextStyles.headlineSmall),
                        const SizedBox(height: 2),
                        Text(
                          'Rejoins des milliers d\'élèves',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'Nom complet',
                hintText: 'Jean Dupont',
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Email ou Téléphone',
                hintText: 'exemple@mail.com',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Mot de passe',
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Confirmation',
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Série Bac',
                hintText: 'Ex : Sciences Expérimentales',
                prefixIcon: Icons.category_outlined,
                controller: _serieController,
              ),
              const SizedBox(height: 28),
              AppPrimaryButton(
                text: isLoading ? 'Création…' : 'S\'inscrire',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        await ref.read(authProvider.notifier).registerMock();
                        if (context.mounted) context.go(AppRoutes.home);
                      },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Déjà un compte ?', style: AppTextStyles.bodyMedium),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    child: const Text('Connecte-toi', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}