import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/core/models/student_profile.dart';
import 'package:bac_nafa/core/models/subject.dart';
import 'package:bac_nafa/core/models/chat_message.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';

final currentUserProvider = Provider<StudentProfile>((ref) {
  return const StudentProfile(
    id: 'user_1',
    name: 'Amadou Diallo',
    bacSeries: 'Série S',
    bacYear: 2026,
    progress: 0.42,
  );
});

final subjectsProvider = Provider<List<Subject>>((ref) {
  return [
    const Subject(
      id: 'sub_1',
      name: 'Mathématiques',
      description: 'Analyse, Algèbre et Géométrie',
      icon: Icons.calculate,
      progress: 0.65,
      color: AppColors.primary,
    ),
    const Subject(
      id: 'sub_2',
      name: 'Physique-Chimie',
      description: 'Mécanique, Électricité et Chimie organique',
      icon: Icons.science,
      progress: 0.30,
      color: Colors.orange,
    ),
    const Subject(
      id: 'sub_3',
      name: 'SVT',
      description: 'Biologie et Géologie',
      icon: Icons.biotech,
      progress: 0.50,
      color: Colors.green,
    ),
    const Subject(
      id: 'sub_4',
      name: 'Philosophie',
      description: 'Réflexion critique et méthodologie',
      icon: Icons.menu_book,
      progress: 0.20,
      color: Colors.purple,
    ),
  ];
});

class ChatMessagesNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      ChatMessage(
        id: 'm1',
        content: 'Bonjour ! Je suis ton assistant BacNafa. Comment puis-je t\'aider aujourd\'hui ?',
        isUser: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: 'm2',
        content: 'Peux-tu m\'expliquer le théorème des valeurs intermédiaires ?',
        isUser: true,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatMessage(
        id: 'm3',
        content: 'Bien sûr ! Le TVI stipule que si une fonction f est continue sur un intervalle [a, b]...',
        isUser: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
    ];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}

final chatMessagesProvider = NotifierProvider<ChatMessagesNotifier, List<ChatMessage>>(() {
  return ChatMessagesNotifier();
});
