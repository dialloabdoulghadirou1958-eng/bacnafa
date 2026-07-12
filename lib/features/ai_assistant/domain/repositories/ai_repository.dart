import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';

abstract class AIRepository {
  Future<ChatMessage> sendMessage(String message, ExamContext? context);
  Future<List<Conversation>> getConversations();
}
