import 'package:equatable/equatable.dart';

/// Represents a chat message in the AI Tutor conversation
class ChatMessage extends Equatable {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;
  final bool isTyping;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isTyping = false,
  });

  /// Create a user message
  factory ChatMessage.user({
    required String id,
    required String content,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id,
      content: content,
      sender: MessageSender.user,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  /// Create an AI message
  factory ChatMessage.ai({
    required String id,
    required String content,
    DateTime? timestamp,
    bool isTyping = false,
  }) {
    return ChatMessage(
      id: id,
      content: content,
      sender: MessageSender.ai,
      timestamp: timestamp ?? DateTime.now(),
      isTyping: isTyping,
    );
  }

  /// Create a typing indicator message
  factory ChatMessage.typing(String id) {
    return ChatMessage(
      id: id,
      content: '',
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      isTyping: true,
    );
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
    bool? isTyping,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
    );
  }

  @override
  List<Object?> get props => [id, content, sender, timestamp, isTyping];
}

/// Enum to represent who sent the message
enum MessageSender {
  user,
  ai,
}

/// Predefined quick questions for the AI Tutor
class QuickQuestion {
  final String id;
  final String question;
  final String emoji;

  const QuickQuestion({
    required this.id,
    required this.question,
    required this.emoji,
  });
}

/// Predefined quick questions for Mexican Bitcoin learners
class QuickQuestions {
  static const List<QuickQuestion> all = [
    QuickQuestion(
      id: 'q1',
      question: '¿Qué es Bitcoin?',
      emoji: '₿',
    ),
    QuickQuestion(
      id: 'q2',
      question: '¿Qué es el halving?',
      emoji: '⏰',
    ),
    QuickQuestion(
      id: 'q3',
      question: '¿Cómo funcionan las wallets?',
      emoji: '👛',
    ),
    QuickQuestion(
      id: 'q4',
      question: '¿Qué es Lightning Network?',
      emoji: '⚡',
    ),
    QuickQuestion(
      id: 'q5',
      question: '¿Bitcoin es legal en México?',
      emoji: '🇲🇽',
    ),
  ];
}
