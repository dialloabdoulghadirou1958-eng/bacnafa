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
import 'package:bac_nafa/core/widgets/app_responsive.dart';
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
    const SelectionItem(id: 'coyah', label: 'Coyah', group: 'Région de Kindia'),
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
    const SelectionItem(id: 'boke', label: 'Boké', group: 'Région de Boké'),
    const SelectionItem(id: 'boffa', label: 'Boffa', group: 'Région de Boké'),
    const SelectionItem(id: 'fria', label: 'Fria', group: 'Région de Boké'),
    const SelectionItem(id: 'gaoual', label: 'Gaoual', group: 'Région de Boké'),
    const SelectionItem(
      id: 'koundara',
      label: 'Koundara',
      group: 'Région de Boké',
    ),
    const SelectionItem(id: 'mamou', label: 'Mamou', group: 'Région de Mamou'),
    const SelectionItem(
      id: 'dalaba',
      label: 'Dalaba',
      group: 'Région de Mamou',
    ),
    const SelectionItem(id: 'pita', label: 'Pita', group: 'Région de Mamou'),
    const SelectionItem(id: 'labe', label: "Labé", group: 'Région de Labé'),
    const SelectionItem(id: 'koubia', label: 'Koubia', group: 'Région de Labé'),
    const SelectionItem(
      id: 'lelouma',
      label: 'Lélouma',
      group: 'Région de Labé',
    ),
    const SelectionItem(id: 'mali', label: 'Mali', group: 'Région de Labé'),
    const SelectionItem(id: 'tougue', label: 'Tougué', group: 'Région de Labé'),
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
    final cityMissing = _hasTriedSubmit && _selectedCity == null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightOnDarkStatusBar,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            if (isWide) {
              return Row(
                children: [
                  const Expanded(child: _LoginHero()),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: _buildFormCard(
                        cityMissing: cityMissing,
                        isLoading: isLoading,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF312E81), Color(0xFF4F46E5)],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                  child: Column(
                    children: [
                      const _LoginHero(compact: true),
                      const SizedBox(height: 24),
                      _buildFormCard(
                        cityMissing: cityMissing,
                        isLoading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormCard({required bool cityMissing, required bool isLoading}) {
    return AppResponsiveContent(
      maxWidth: 560,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.dialog),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ton profil élève',
                        style: AppTextStyles.headlineSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'On personnalise ton parcours en 1 minute.',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
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
            const SizedBox(height: 16),
            AppTextField(
              label: 'Nom',
              hintText: 'Ex : Diallo',
              prefixIcon: Icons.person_outline_rounded,
              controller: _lastNameController,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _CityField(
              accent: AppColors.primary,
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
                if (selected != null) setState(() => _selectedCity = selected);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Nom du lycée (optionnel)',
              hintText: 'Ex : Lycée Donka',
              prefixIcon: Icons.school_outlined,
              controller: _schoolController,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              text: 'Accéder aux révisions',
              icon: Icons.arrow_forward_rounded,
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() => _hasTriedSubmit = true);
                      if (!_isFormValid) return;
                      ref.read(authProvider.notifier).loginMock().then((_) {
                        if (!mounted) return;
                        context.go(AppRoutes.home);
                      });
                    },
            ),
            const SizedBox(height: 12),
            Text(
              'Tes informations restent privées et servent uniquement à adapter tes révisions.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  final bool compact;

  const _LoginHero({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 84.0 : 116.0;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 48,
        vertical: compact ? 0 : 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: compact
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'app_icon',
            createRectTween: (begin, end) =>
                MaterialRectArcTween(begin: begin, end: end),
            child: Container(
              width: iconSize,
              height: iconSize,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(compact ? 24 : 32),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.28),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/branding/app_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: compact ? 16 : 28),
          Text(
            'Bienvenue sur\nBacNafa',
            textAlign: compact ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ton espace simple et motivant pour préparer le Bac à ton rythme.',
            textAlign: compact ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withValues(alpha: 0.80),
              height: 1.5,
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 34),
            const _FeatureLine(
              icon: Icons.menu_book_rounded,
              text: 'Des sujets adaptés à ta série',
            ),
            const SizedBox(height: 14),
            const _FeatureLine(
              icon: Icons.auto_awesome_rounded,
              text: 'Des quiz courts pour progresser',
            ),
            const SizedBox(height: 14),
            const _FeatureLine(
              icon: Icons.insights_rounded,
              text: 'Un suivi clair de tes efforts',
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withValues(alpha: 0.86),
          ),
        ),
      ],
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
    final borderColor = hasError ? AppColors.error : AppColors.outlineVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ville / Commune',
          style: AppTextStyles.labelLarge.copyWith(
            color: hasError ? AppColors.error : AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
