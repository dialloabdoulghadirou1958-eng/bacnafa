import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/core/widgets/app_responsive.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ma bibliothèque')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 32),
        child: AppResponsiveContent(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppPageIntro(
                  eyebrow: 'Ton espace sauvegardé',
                  title: 'Retrouve tes essentiels',
                  description:
                      'Tes favoris et tes dernières consultations restent accessibles en un geste.',
                  icon: Icons.bookmark_rounded,
                  accent: AppColors.tertiary,
                  trailing: _LibrarySummary(
                    favorites: favorites.length,
                    history: history.length,
                  ),
                ),
                const SizedBox(height: 28),
                AppSectionHeading(
                  title: 'Mes favoris',
                  subtitle:
                      '${favorites.length} sujet${favorites.length > 1 ? 's' : ''} enregistré${favorites.length > 1 ? 's' : ''}',
                ),
                const SizedBox(height: 12),
                if (favorites.isEmpty)
                  const _LibraryEmptySlot(
                    message:
                        'Ajoute une étoile à un sujet pour le retrouver ici.',
                  )
                else
                  ...favorites.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _LibraryItem(
                        icon: Icons.star_rounded,
                        color: AppColors.warning,
                        title: item.title,
                        subtitle: 'Sujet sauvegardé',
                        onTap: () => context.push('/exam/${item.itemId}'),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                AppSectionHeading(
                  title: 'Historique récent',
                  subtitle:
                      '${history.length} dernière${history.length > 1 ? 's' : ''} consultation${history.length > 1 ? 's' : ''}',
                ),
                const SizedBox(height: 12),
                if (history.isEmpty)
                  const _LibraryEmptySlot(
                    message: 'Tes sujets consultés apparaîtront ici.',
                  )
                else
                  ...history.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _LibraryItem(
                        icon: Icons.history_rounded,
                        color: AppColors.secondary,
                        title: item.title,
                        subtitle: '${item.subjectName} • ${item.year}',
                        onTap: () => context.push('/exam/${item.itemId}'),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LibrarySummary extends StatelessWidget {
  final int favorites;
  final int history;

  const _LibrarySummary({required this.favorites, required this.history});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SummaryPill(
          icon: Icons.star_rounded,
          label: '$favorites',
          color: Colors.white,
        ),
        const SizedBox(width: 6),
        _SummaryPill(
          icon: Icons.history_rounded,
          label: '$history',
          color: Colors.white,
        ),
      ],
    );
  }
}

class _SummaryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SummaryPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryEmptySlot extends StatelessWidget {
  final String message;

  const _LibraryEmptySlot({required this.message});

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.surface, AppColors.surfaceGlow],
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.folder_open_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LibraryItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.18),
                  color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: color.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textTertiary,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}
