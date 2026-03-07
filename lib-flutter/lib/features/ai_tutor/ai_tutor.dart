/// AI Tutor Module - BITQUEST
/// 
/// A gamified Bitcoin education chatbot that teaches Bitcoin concepts
/// to beginners in Mexico.
/// 
/// Features:
/// - Chat interface with Satoshi Mentor AI
/// - Markdown support for formatted responses
/// - Quick question suggestions
/// - Typing indicators
/// - Smooth animations
/// - Dark theme with Bitcoin orange and purple accents
/// 
/// Usage:
/// ```dart
/// import 'package:bitquest/features/ai_tutor/ai_tutor.dart';
/// 
/// // Navigate to chat page
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (context) => const AiTutorChatPage()),
/// );
/// ```

export 'chat_page.dart';
export 'bloc/ai_tutor_bloc.dart';
export 'bloc/ai_tutor_event.dart';
export 'bloc/ai_tutor_state.dart';
export 'models/chat_message.dart';
export 'services/ai_tutor_service.dart';
export 'widgets/message_bubble.dart';
export 'widgets/chat_input.dart';
