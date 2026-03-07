import 'package:equatable/equatable.dart';
import '../models/chat_message.dart';

/// Base event for AI Tutor BLoC
abstract class AiTutorEvent extends Equatable {
  const AiTutorEvent();

  @override
  List<Object?> get props => [];
}

/// Event to send a message to the AI tutor
class SendMessage extends AiTutorEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

/// Event to load chat history
class LoadHistory extends AiTutorEvent {
  const LoadHistory();
}

/// Event to clear the chat
class ClearChat extends AiTutorEvent {
  const ClearChat();
}

/// Event to select a quick question
class SelectQuickQuestion extends AiTutorEvent {
  final QuickQuestion question;

  const SelectQuickQuestion(this.question);

  @override
  List<Object?> get props => [question];
}

/// Event to initialize the welcome message
class InitializeChat extends AiTutorEvent {
  const InitializeChat();
}
