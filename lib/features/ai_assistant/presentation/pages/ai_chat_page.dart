import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';
import 'package:bac_nafa/features/ai_assistant/providers/ai_providers.dart';
import 'package:bac_nafa/features/ai_assistant/presentation/widgets/chat_bubble.dart';
import 'package:bac_nafa/features/ai_assistant/presentation/widgets/chat_input.dart';

class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleContext();
  }

  void _handleContext() {
    final uri = GoRouterState.of(context).uri;
    final examId = uri.queryParameters['examId'];
    final subject = uri.queryParameters['subject'];
    final title = uri.queryParameters['title'];

    if (examId != null) {
      ref.read(examContextProvider.notifier).set(ExamContext(
        examId: examId,
        subjectName: subject ?? 'Sujet',
        series: 'Série', // Simplified for mock
        year: '2026',     // Simplified for mock
        contentSummary: title ?? '',
      ));
    }
  }

  Future<void> _sendMessage(String text) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final userMsg = ChatMessage(
      id: messageId,
      contents: [MessageContent(text: text)],
      role: ChatRole.user,
      timestamp: DateTime.now(),
      status: ChatStatus.sent,
    );

    ref.read(messagesProvider.notifier).addMessage(userMsg);
    ref.read(isSendingProvider.notifier).set(true);

    try {
      final repository = ref.read(aiRepositoryProvider);
      final context = ref.read(examContextProvider);
      final response = await repository.sendMessage(text, context);
      
      ref.read(messagesProvider.notifier).addMessage(response);
    } catch (e) {
      ref.read(messagesProvider.notifier).addMessage(
        ChatMessage(
          id: 'err_${DateTime.now().millisecondsSinceEpoch}',
          contents: [
            MessageContent(
              text: 'Désolé, une erreur est survenue. Veuillez réessayer.',
              type: MessageContentType.text,
            ),
          ],
          role: ChatRole.assistant,
          timestamp: DateTime.now(),
          status: ChatStatus.error,
        ),
      );
    } finally {
      ref.read(isSendingProvider.notifier).set(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);
    final examContext = ref.watch(examContextProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assistant IA'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (examContext != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.md),
                color: AppColors.primaryLight.withValues(alpha: 0.5),
              child: Row(
                children: [
                  const Icon(Icons.book_rounded, color: AppColors.primary, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Sujet : ${examContext.subjectName} - ${examContext.year}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref.read(examContextProvider.notifier).set(null),
                    child: const Text('Fermer', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => ChatBubble(message: messages[index]),
                  ),
          ),
          ChatInput(onSend: _sendMessage),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 64, color: AppColors.aiAccent),
            SizedBox(height: AppSpacing.md),
            Text(
              'Bonjour ! Je suis ton tuteur IA spécialisé Bac.',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Pose-moi une question sur un exercice ou demande-moi une explication de cours.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
