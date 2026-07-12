import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';
import 'package:go_router/go_router.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ma Bibliothèque'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Mes favoris', Icons.star_rounded),
            SizedBox(height: AppSpacing.sm),
            _buildFavoritesList(favorites),
            SizedBox(height: AppSpacing.xl),
            _buildSectionHeader('Historique récent', Icons.history_rounded),
            SizedBox(height: AppSpacing.sm),
            _buildHistoryList(history),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: AppTextStyles.titleMedium,
        ),
      ],
    );
  }

  Widget _buildFavoritesList(List<FavoriteItem> favorites) {
    if (favorites.isEmpty) {
      return _buildEmptyState('Tes sujets favoris apparaîtront ici.');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: favorites.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = favorites[index];
        return AppCardPremium(
          onTap: () {
            if (item.type == FavoriteType.subject) {
              context.push('/exam/${item.itemId}');
            } else {
              context.push('/ai');
            }
          },
          child: ListTile(
            leading: Icon(
              item.type == FavoriteType.subject ? Icons.description : Icons.auto_awesome,
              color: AppColors.primary,
            ),
            title: Text(item.title, style: AppTextStyles.titleSmall),
            subtitle: Text(
              item.type == FavoriteType.subject ? 'Sujet sauvegardé' : 'Conversation IA',
              style: AppTextStyles.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
          ),
        );
      },
    );
  }

  Widget _buildHistoryList(List<HistoryItem> history) {
    if (history.isEmpty) {
      return _buildEmptyState('Tes derniers sujets consultés apparaîtront ici.');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final item = history[index];
        return AppCardPremium(
          onTap: () => context.push('/exam/${item.itemId}'),
          child: ListTile(
            leading: const Icon(Icons.history, color: AppColors.textSecondary),
            title: Text(item.title, style: AppTextStyles.titleSmall),
            subtitle: Text(
              '${item.subjectName} • ${item.year}',
              style: AppTextStyles.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Icon(Icons.folder_open, color: AppColors.textSecondary, size: 48),
          SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
