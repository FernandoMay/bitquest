import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../services/ai_tutor_service.dart';
import 'ai_tutor_event.dart';
import 'ai_tutor_state.dart';

/// BLoC for managing AI Tutor chat state
class AiTutorBloc extends Bloc<AiTutorEvent, AiTutorState> {
  final AiTutorService _aiTutorService;
  final Uuid _uuid = const Uuid();

  /// Welcome message from Satoshi Mentor
  static const String _welcomeMessage = '''¡Hola! Soy **SATOSHI MENTOR** 🎓

Tu guía en el mundo de Bitcoin. Estoy aquí para ayudarte a entender Bitcoin de manera clara y sencilla.

**Puedo enseñarte sobre:**
₿ Qué es Bitcoin y cómo funciona
⏰ El halving y su importancia
👛 Wallets y seguridad
⚡ Lightning Network
🇲🇽 Uso de Bitcoin en México

¿Por qué no me preguntas algo? Usa las preguntas rápidas o escribe tu propia pregunta abajo 👇''';

  AiTutorBloc({
    AiTutorService? aiTutorService,
  })  : _aiTutorService = aiTutorService ?? AiTutorService(),
        super(const AiTutorInitial()) {
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<SelectQuickQuestion>(_onSelectQuickQuestion);
    on<LoadHistory>(_onLoadHistory);
    on<ClearChat>(_onClearChat);
  }

  /// Initialize chat with welcome message
  Future<void> _onInitializeChat(
    InitializeChat event,
    Emitter<AiTutorState> emit,
  ) async {
    if (state.messages.isEmpty) {
      final welcomeMessage = ChatMessage.ai(
        id: _uuid.v4(),
        content: _welcomeMessage,
        timestamp: DateTime.now(),
      );
      emit(AiTutorLoaded([welcomeMessage]));
    }
  }

  /// Handle sending a message
  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<AiTutorState> emit,
  ) async {
    if (event.message.trim().isEmpty) return;

    // Create user message
    final userMessage = ChatMessage.user(
      id: _uuid.v4(),
      content: event.message.trim(),
    );

    // Create typing indicator
    final typingId = _uuid.v4();
    final typingMessage = ChatMessage.typing(typingId);

    // Add user message and typing indicator
    final currentMessages = List<ChatMessage>.from(state.messages)
      ..addAll([userMessage, typingMessage]);

    emit(AiTutorLoading(currentMessages));

    try {
      // Call AI service
      final response = await _aiTutorService.sendMessage(event.message.trim());

      // Remove typing indicator and add AI response
      final updatedMessages = currentMessages
          .where((m) => m.id != typingId)
          .toList();

      final aiMessage = ChatMessage.ai(
        id: _uuid.v4(),
        content: response,
        timestamp: DateTime.now(),
      );

      updatedMessages.add(aiMessage);
      emit(AiTutorLoaded(updatedMessages));
    } catch (e) {
      // Remove typing indicator
      final updatedMessages = currentMessages
          .where((m) => m.id != typingId)
          .toList();

      // Add error message
      emit(AiTutorError(
        updatedMessages,
        'No pude procesar tu mensaje. Por favor intenta de nuevo.',
      ));
    }
  }

  /// Handle selecting a quick question
  Future<void> _onSelectQuickQuestion(
    SelectQuickQuestion event,
    Emitter<AiTutorState> emit,
  ) async {
    add(SendMessage(event.question.question));
  }

  /// Load chat history (placeholder for future implementation)
  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<AiTutorState> emit,
  ) async {
    // TODO: Implement local storage for chat history
    // For now, just initialize with welcome message
    add(const InitializeChat());
  }

  /// Clear the chat
  Future<void> _onClearChat(
    ClearChat event,
    Emitter<AiTutorState> emit,
  ) async {
    // Re-initialize with welcome message
    final welcomeMessage = ChatMessage.ai(
      id: _uuid.v4(),
      content: _welcomeMessage,
      timestamp: DateTime.now(),
    );
    emit(AiTutorLoaded([welcomeMessage]));
  }
}
