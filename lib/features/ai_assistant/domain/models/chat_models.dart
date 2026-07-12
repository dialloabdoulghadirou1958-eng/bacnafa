import 'package:flutter/material.dart';

enum ChatRole { user, assistant }

enum ChatStatus { sending, sent, error }

enum MessageContentType { text, markdown, latex, table, image, document, artifact }

class MessageContent {
  final String text;
  final MessageContentType type;
  final Map<String, dynamic>? metadata;

  MessageContent({
    required this.text,
    this.type = MessageContentType.text,
    this.metadata,
  });
}

class ChatMessage {
  final String id;
  final List<MessageContent> contents;
  final ChatRole role;
  final DateTime timestamp;
  final ChatStatus status;

  ChatMessage({
    required this.id,
    required this.contents,
    required this.role,
    required this.timestamp,
    required this.status,
  });

  ChatMessage copyWith({
    List<MessageContent>? contents,
    ChatRole? role,
    DateTime? timestamp,
    ChatStatus? status,
  }) {
    return ChatMessage(
      id: id,
      contents: contents ?? this.contents,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}

class Conversation {
  final String id;
  final String title;
  final String? subjectId;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  Conversation({
    required this.id,
    required this.title,
    this.subjectId,
    required this.createdAt,
    required this.messages,
  });

  Conversation copyWith({
    String? title,
    List<ChatMessage>? messages,
  }) {
    return Conversation(
      id: id,
      title: title ?? this.title,
      subjectId: subjectId,
      createdAt: createdAt,
      messages: messages ?? this.messages,
    );
  }
}

class ExamContext {
  final String examId;
  final String subjectName;
  final String series;
  final String year;
  final String contentSummary;

  ExamContext({
    required this.examId,
    required this.subjectName,
    required this.series,
    required this.year,
    required this.contentSummary,
  });
}
