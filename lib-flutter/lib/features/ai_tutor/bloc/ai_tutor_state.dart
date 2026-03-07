import 'package:equatable/equatable.dart';
import '../models/chat_message.dart';

/// Base state for AI Tutor BLoC
abstract class AiTutorState extends Equatable {
  final List<ChatMessage> messages;

  const AiTutorState(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// Initial state when the chat is empty
class AiTutorInitial extends AiTutorState {
  const AiTutorInitial() : super(const []);
}

/// State when the AI is processing a message
class AiTutorLoading extends AiTutorState {
  const AiTutorLoading(List<ChatMessage> messages) : super(messages);

  @override
  List<Object?> get props => [messages];
}

/// State when messages are loaded and ready
class AiTutorLoaded extends AiTutorState {
  const AiTutorLoaded(List<ChatMessage> messages) : super(messages);

  @override
  List<Object?> get props => [messages];
}

/// State when there's an error
class AiTutorError extends AiTutorState {
  final String errorMessage;

  const AiTutorError(
    List<ChatMessage> messages,
    this.errorMessage,
  ) : super(messages);

  @override
  List<Object?> get props => [messages, errorMessage];
}

/// Extension to check if AI is typing
extension AiTutorStateX on AiTutorState {
  bool get isTyping {
    if (messages.isEmpty) return false;
    return messages.last.isTyping;
  }

  bool get hasMessages => messages.isNotEmpty;

  int get messageCount => messages.length;
}
