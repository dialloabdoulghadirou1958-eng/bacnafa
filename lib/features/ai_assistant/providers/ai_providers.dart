import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';
import 'package:bac_nafa/features/ai_assistant/domain/repositories/ai_repository.dart';
import 'package:bac_nafa/features/ai_assistant/data/mock_ai_repository.dart';

final aiRepositoryProvider = Provider<AIRepository>((ref) {
  return MockAIRepository();
});

final examContextProvider = NotifierProvider<ExamContextNotifier, ExamContext?>(ExamContextNotifier.new);

class ExamContextNotifier extends Notifier<ExamContext?> {
  @override
  ExamContext? build() => null;

  void set(ExamContext? context) => state = context;
}

final isSendingProvider = NotifierProvider<IsSendingNotifier, bool>(IsSendingNotifier.new);

class IsSendingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final messagesProvider = NotifierProvider<MessagesNotifier, List<ChatMessage>>(MessagesNotifier.new);

class MessagesNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => [];

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void updateMessage(String id, ChatMessage updatedMessage) {
    state = [
      for (final msg in state)
        if (msg.id == id) updatedMessage else msg,
    ];
  }

  void clear() {
    state = [];
  }
}
