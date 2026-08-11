import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/routes.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/app/theme/app_theme.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_primary_button.dart';
import 'package:bac_nafa/core/widgets/app_selection_sheet.dart';
import 'package:bac_nafa/core/widgets/app_text_field.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _schoolController = TextEditingController();

  SelectionItem<void>? _selectedCity;
  bool _hasTriedSubmit = false;

  static final _cities = <SelectionItem<void>>[
    const SelectionItem(
      id: 'conakry_ratoma',
      label: 'Conakry - Ratoma',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_matam',
      label: 'Conakry - Matam',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_dixinn',
      label: 'Conakry - Dixinn',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_kaloum',
      label: 'Conakry - Kaloum',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_matoto',
      label: 'Conakry - Matoto',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_kassa',
      label: 'Conakry - Kassa',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_gbessia',
      label: 'Conakry - Gbessia',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_tombolia',
      label: 'Conakry - Tombolia',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_lambagni',
      label: 'Conakry - Lambagni',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_sonfonia',
      label: 'Conakry - Sonfonia',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_kagbelen',
      label: 'Conakry - Kagbelen',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_maneah',
      label: 'Conakry - Manéah',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'conakry_sanoyah',
      label: 'Conakry - Sanoyah',
      group: 'Communes de Conakry',
    ),
    const SelectionItem(
      id: 'kindia',
      label: 'Kindia',
      group: 'Région de Kindia',
    ),
    const SelectionItem(
      id: 'coyah',
      label: 'Coyah',
      group: 'Région de Kindia',
    ),
    const SelectionItem(
      id: 'dubreka',
      label: 'Dubréka',
      group: 'Région de Kindia',
    ),
    const SelectionItem(
      id: 'forecariah',
      label: 'Forécariah',
      group: 'Région de Kindia',
    ),
    const SelectionItem(
      id: 'telimele',
      label: 'Télimélé',
      group: 'Région de Kindia',
    ),
    const SelectionItem(
      id: 'boke',
      label: 'Boké',
      group: 'Région de Boké',
    ),
    const SelectionItem(
      id: 'boffa',
      label: 'Boffa',
      group: 'Région de Boké',
    ),
    const SelectionItem(
      id: 'fria',
      label: 'Fria',
      group: 'Région de Boké',
    ),
    const SelectionItem(
      id: 'gaoual',
      label: 'Gaoual',
      group: 'Région de Boké',
    ),
    const SelectionItem(
      id: 'koundara',
      label: 'Koundara',
      group: 'Région de Boké',
    ),
    const SelectionItem(
      id: 'mamou',
      label: 'Mamou',
      group: 'Région de Mamou',
    ),
    const SelectionItem(
      id: 'dalaba',
      label: 'Dalaba',
      group: 'Région de Mamou',
    ),
    const SelectionItem(
      id: 'pita',
      label: 'Pita',
      group: 'Région de Mamou',
    ),
    const SelectionItem(
      id: 'labe',
      label: "Labé",
      group: 'Région de Labé',
    ),
    const SelectionItem(
      id: 'koubia',
      label: 'Koubia',
      group: 'Région de Labé',
    ),
    const SelectionItem(
      id: 'lelouma',
      label: 'Lélouma',
      group: 'Région de Labé',
    ),
    const SelectionItem(
      id: 'mali',
      label: 'Mali',
      group: 'Région de Labé',
    ),
    const SelectionItem(
      id: 'tougue',
      label: 'Tougué',
      group: 'Région de Labé',
    ),
    const SelectionItem(
      id: 'faranah',
      label: 'Faranah',
      group: 'Région de Faranah',
    ),
    const SelectionItem(
      id: 'dabola',
      label: 'Dabola',
      group: 'Région de Faranah',
    ),
    const SelectionItem(
      id: 'dinguiraye',
      label: 'Dinguiraye',
      group: 'Région de Faranah',
    ),
    const SelectionItem(
      id: 'kissidougou',
      label: 'Kissidougou',
      group: 'Région de Faranah',
    ),
    const SelectionItem(
      id: 'kankan',
      label: 'Kankan',
      group: 'Région de Kankan',
    ),
    const SelectionItem(
      id: 'kerouane',
      label: 'Kérouané',
      group: 'Région de Kankan',
    ),
    const SelectionItem(
      id: 'kouroussa',
      label: 'Kouroussa',
      group: 'Région de Kankan',
    ),
    const SelectionItem(
      id: 'mandiana',
      label: 'Mandiana',
      group: 'Région de Kankan',
    ),
    const SelectionItem(
      id: 'siguiri',
      label: 'Siguiri',
      group: 'Région de Kankan',
    ),
    const SelectionItem(
      id: 'nzerekore',
      label: "N'Zérékoré",
      group: "Région de N'Zérékoré",
    ),
    const SelectionItem(
      id: 'beyla',
      label: 'Beyla',
      group: "Région de N'Zérékoré",
    ),
    const SelectionItem(
      id: 'gueckedou',
      label: 'Guéckédou',
      group: "Région de N'Zérékoré",
    ),
    const SelectionItem(
      id: 'lola',
      label: 'Lola',
      group: "Région de N'Zérékoré",
    ),
    const SelectionItem(
      id: 'macenta',
      label: 'Macenta',
      group: "Région de N'Zérékoré",
    ),
    const SelectionItem(
      id: 'yomou',
      label: 'Yomou',
      group: "Région de N'Zérékoré",
    ),
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty &&
      _selectedCity != null;

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authProvider);
    final isLoading = authStatus == AuthStatus.loading;
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = screenHeight * 0.38;
    final accent = const Color(0xFF5A54E8);
    final cityMissing = _hasTriedSubmit && _selectedCity == null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightStatusBar,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF5A54E8), Color(0xFF7F77FF)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      left: -60,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: -80,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.06),
                    Hero(
                      tag: 'app_icon',
                      createRectTween: (begin, end) =>
                          MaterialRectArcTween(begin: begin, end: end),
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5A54E8)
                                  .withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/branding/app_icon.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenue',
                      style: AppTextStyles.displayMedium.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crée ton profil élève pour commencer tes révisions',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Profil élève',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Quelques informations pour personnaliser ton parcours',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppTextField(
                            label: 'Prénom',
                            hintText: 'Ex : Mariame',
                            prefixIcon: Icons.person_outline_rounded,
                            controller: _firstNameController,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 18),
                          AppTextField(
                            label: 'Nom',
                            hintText: 'Ex : Diallo',
                            prefixIcon: Icons.person_outline_rounded,
                            controller: _lastNameController,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 18),
                          _CityField(
                            accent: accent,
                            selected: _selectedCity,
                            hasError: cityMissing,
                            onTap: () async {
                              final selected = await showAppSelectionSheet(
                                context: context,
                                title: 'Sélectionne ta ville',
                                searchHint: 'Recherche une ville…',
                                items: _cities,
                                initialSelection: _selectedCity,
                              );
                              if (selected != null) {
                                setState(() => _selectedCity = selected);
                              }
                            },
                          ),
                          const SizedBox(height: 18),
                          AppTextField(
                            label: 'Nom du Lycée (optionnel)',
                            hintText: 'Ex : Lycée Donka',
                            prefixIcon: Icons.school_outlined,
                            controller: _schoolController,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 24),
                          AppPrimaryButton(
                            text: 'Accéder aux révisions',
                            backgroundColor: const Color(0xFF5A54E8),
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () {
                                    setState(() => _hasTriedSubmit = true);
                                    if (!_isFormValid) return;
                                    ref
                                        .read(authProvider.notifier)
                                        .loginMock()
                                        .then((_) {
                                      if (context.mounted) {
                                        context.go(AppRoutes.home);
                                      }
                                    });
                                  },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityField extends StatelessWidget {
  final Color accent;
  final SelectionItem<void>? selected;
  final bool hasError;
  final VoidCallback onTap;

  const _CityField({
    required this.accent,
    required this.selected,
    required this.onTap,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        hasError ? AppColors.error : AppColors.outlineVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ville / Commune',
          style: AppTextStyles.labelLarge.copyWith(
            color: hasError
                ? AppColors.error
                : AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.medium),
              border: Border.all(color: borderColor, width: 1.0),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 8),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: selected != null ? accent : AppColors.textTertiary,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: selected != null
                      ? Text(
                          selected!.label,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        )
                      : Text(
                          'Ex : Conakry - Ratoma',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 15,
                            color: AppColors.textTertiary,
                          ),
                        ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textTertiary,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Veuillez sélectionner ta ville ou commune.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}
