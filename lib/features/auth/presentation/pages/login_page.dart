import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_text_field.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _fade;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authProvider);
    final isLoading = authStatus == AuthStatus.loading;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.42,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.tertiary],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -30,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.6, end: 1.0),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/branding/app_icon.jpg', fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenue',
                    style: AppTextStyles.displayMedium.copyWith(color: Colors.white, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Connecte-toi pour continuer ton parcours',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slide.value),
                        child: Opacity(opacity: _fade.value, child: child),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Connexion', style: AppTextStyles.headlineSmall),
                          const SizedBox(height: 4),
                          Text('Saisis tes identifiants', style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 20),
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
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                              child: const Text('Mot de passe oublié ?'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AppPrimaryButton(
                            text: isLoading ? 'Connexion…' : 'Se connecter',
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    await ref.read(authProvider.notifier).loginMock();
                                    if (context.mounted) context.go(AppRoutes.home);
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Pas encore de compte ?', style: AppTextStyles.bodyMedium),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                        child: const Text('Inscris-toi', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}