import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/app/theme/app_theme.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';
import 'package:bac_nafa/features/ai_assistant/providers/ai_providers.dart';
import 'package:bac_nafa/features/ai_assistant/presentation/widgets/chat_bubble.dart';
import 'package:bac_nafa/features/ai_assistant/presentation/widgets/chat_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AIChatPage extends ConsumerStatefulWidget {
  const AIChatPage({super.key});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uri = GoRouterState.of(context).uri;
    final examId = uri.queryParameters['examId'];
    final subject = uri.queryParameters['subject'];
    final title = uri.queryParameters['title'];

    if (examId != null) {
      ref.read(examContextProvider.notifier).set(ExamContext(
        examId: examId,
        subjectName: subject ?? 'Sujet',
        series: 'Série',
        year: '2026',
        contentSummary: title ?? '',
      ));
    }
  }

  Future<void> _sendMessage(String text) async {
    final messageId = DateTime.now().microsecondsSinceEpoch.toString();
    final userMsg = ChatMessage(
      id: messageId,
      contents: [MessageContent(text: text)],
      role: ChatRole.user,
      timestamp: DateTime.now(),
      status: ChatStatus.sent,
    );

    ref.read(messagesProvider.notifier).addMessage(userMsg);
    ref.read(isSendingProvider.notifier).set(true);

    _scrollToBottom();

    try {
      final repository = ref.read(aiRepositoryProvider);
      final contextExam = ref.read(examContextProvider);
      final response = await repository.sendMessage(text, contextExam);

      ref.read(messagesProvider.notifier).addMessage(response);
    } catch (_) {
      ref.read(messagesProvider.notifier).addMessage(
        ChatMessage(
          id: 'err_${DateTime.now().microsecondsSinceEpoch}',
          contents: [
            MessageContent(text: 'Désolé, une erreur est survenue. Veuillez réessayer.', type: MessageContentType.text),
          ],
          role: ChatRole.assistant,
          timestamp: DateTime.now(),
          status: ChatStatus.error,
        ),
      );
    } finally {
      ref.read(isSendingProvider.notifier).set(false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);
    final examContext = ref.watch(examContextProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.lightStatusBar,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Assistant IA'),
          scrolledUnderElevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.history_rounded, size: 22),
              onPressed: () => context.push('/assistant/history'),
            ),
          ],
        ),
        body: Column(
          children: [
            if (examContext != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2), width: 1),
                      ),
                      child: const Icon(Icons.book_rounded, color: AppColors.tertiary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${examContext.subjectName} — ${examContext.contentSummary}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onTertiaryContainer,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref.read(examContextProvider.notifier).set(null),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderSubtle, width: 1),
                        ),
                        child: Icon(Icons.close_rounded, size: 18, color: AppColors.textTertiary),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: messages.isEmpty
                  ? _EmptyChat(
                      examContext: examContext,
                      onPrompt: (text) => _sendMessage(text),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => ChatBubble(message: messages[index]),
                    ),
            ),
            ChatInput(onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  final ExamContext? examContext;
  final void Function(String) onPrompt;

  const _EmptyChat({required this.examContext, required this.onPrompt});

  @override
  Widget build(BuildContext context) {
    const suggestions = [
      'Explique-moi les limites de fonctions',
      'Comment résoudre une équation différentielle ?',
      'Peux-tu m\'expliquer la loi d\'Ohm ?',
      'Aide-moi à comprendre les suites géométriques',
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2), width: 1),
              ),
              child: const Icon(Icons.psychology_rounded, color: AppColors.tertiary, size: 52),
            ),
            const SizedBox(height: 24),
            Text(
              'Tuteur IA Bac',
              style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Pose-moi tes questions sur les sujets du Bac et j\'analyse chaque étape avec toi.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (examContext != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.2), width: 1),
                ),
                child: Text(
                  'Contexte : ${examContext!.contentSummary}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onTertiaryContainer,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: suggestions.map((s) {
                return ActionChip(
                  label: Text(s, style: AppTextStyles.labelSmall),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  backgroundColor: AppColors.surfaceContainerHighest,
                  side: BorderSide(color: AppColors.borderSubtle, width: 1),
                  onPressed: () => onPrompt(s),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}