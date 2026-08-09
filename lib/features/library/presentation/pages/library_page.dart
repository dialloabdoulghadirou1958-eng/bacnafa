import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Bibliothèque'),
        scrolledUnderElevation: 1,
      ),
      body: favorites.isEmpty && history.isEmpty
          ? const _EmptyLibrary()
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              children: [
                _SectionHeader(icon: Icons.star_rounded, title: 'Mes favoris', count: favorites.length),
                if (favorites.isEmpty)
                  const _EmptySlot(message: 'Tes sujets favoris apparaîtront ici.')
                else
                  ...favorites.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _LibraryItem(
                          icon: Icons.description_rounded,
                          title: item.title,
                          subtitle: 'Sujet sauvegardé',
                          onTap: () => context.push('/exam/${item.itemId}'),
                        ),
                      )),
                _SectionHeader(icon: Icons.history_rounded, title: 'Historique récent', count: history.length),
                if (history.isEmpty)
                  const _EmptySlot(message: 'Tes derniers sujets consultés apparaîtront ici.')
                else
                  ...history.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _LibraryItem(
                          icon: Icons.history_rounded,
                          title: item.title,
                          subtitle: '${item.subjectName} • ${item.year}',
                          onTap: () => context.push('/exam/${item.itemId}'),
                        ),
                      )),
              ],
            ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.bookmark_add_rounded, color: AppColors.secondary, size: 48),
            ),
            const SizedBox(height: 16),
            Text('Bibliothèque vide', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Sauvegarde tes sujets favoris et retrouve-les ici.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.titleMedium),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final String message;
  const _EmptySlot({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open_rounded, color: AppColors.textTertiary, size: 20),
          const SizedBox(width: 8),
          Text(message, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _LibraryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LibraryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardPremium(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.labelSmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.outline.withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}