import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';
import 'package:bac_nafa/features/ai_assistant/domain/repositories/ai_repository.dart';

class MockAIRepository implements AIRepository {
  @override
  Future<ChatMessage> sendMessage(String message, ExamContext? context) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    List<MessageContent> contents = [];

    if (context != null) {
      contents.add(MessageContent(
        text: "Analysons ensemble le sujet de ${context.subjectName} (${context.year}, ${context.series}).",
        type: MessageContentType.text,
      ));
      contents.add(MessageContent(
        text: "Voici la formule clé pour résoudre cet exercice :\n\n\\int x^n dx = \\frac{x^{n+1}}{n+1} + C",
        type: MessageContentType.latex,
      ));
      contents.add(MessageContent(
        text: "Voici un résumé des étapes à suivre pour réussir ce type d'épreuve.",
        type: MessageContentType.artifact,
      ));
    } else if (message.toLowerCase().contains('bonjour')) {
      contents.add(MessageContent(
        text: "Bonjour ! Je suis ton professeur particulier IA spécialisé pour le Bac. Quel sujet souhaites-tu aborder ?",
        type: MessageContentType.text,
      ));
    } else if (message.toLowerCase().contains('exercice')) {
      contents.add(MessageContent(
        text: "Pour résoudre cet exercice, je te conseille de commencer par identifier les données et les formules clés.",
        type: MessageContentType.text,
      ));
      contents.add(MessageContent(
        text: "L'erreur classique ici est d'oublier la constante d'intégration.",
        type: MessageContentType.markdown,
      ));
    } else {
      contents.add(MessageContent(
        text: "C'est une question intéressante. Pour y répondre précisément, pourrais-tu me donner plus de détails ou m'indiquer l'exercice concerné ?",
        type: MessageContentType.text,
      ));
    }

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contents: contents,
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
      status: ChatStatus.sent,
    );
  }

  @override
  Future<List<Conversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Conversation(
        id: 'conv_1',
        title: 'Mathématiques - Intégrales',
        subjectId: 'math-2026-sm',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        messages: [],
      ),
      Conversation(
        id: 'conv_2',
        title: 'Physique - Thermodynamique',
        subjectId: 'phys-2025-se',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        messages: [],
      ),
    ];
  }
}
