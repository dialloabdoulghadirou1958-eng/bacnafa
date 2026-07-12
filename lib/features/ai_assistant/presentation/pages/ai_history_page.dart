import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';
import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';
import 'package:bac_nafa/features/ai_assistant/providers/ai_providers.dart';
import 'package:go_router/go_router.dart';

class AIHistoryPage extends ConsumerWidget {
  const AIHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Historique IA'),
      ),
      body: FutureBuilder<List<Conversation>>(
        future: ref.read(aiRepositoryProvider).getConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final conversations = snapshot.data ?? [];
          if (conversations.isEmpty) {
            return const Center(child: Text('Aucune conversation trouvée'));
          }
          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.lg),
            itemCount: conversations.length,
            separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              return AppCardPremium(
                onTap: () => context.push('/assistant'),
                child: ListTile(
                  leading: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                  title: Text(conv.title, style: AppTextStyles.titleSmall),
                  subtitle: Text(
                    'Dernière activité: ${_formatDate(conv.createdAt)}',
                    style: AppTextStyles.bodySmall,
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
