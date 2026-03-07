import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'bloc/ai_tutor_bloc.dart';
import 'bloc/ai_tutor_event.dart';
import 'bloc/ai_tutor_state.dart';
import 'models/chat_message.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_input.dart';

/// Main AI Tutor chat page
class AiTutorChatPage extends StatefulWidget {
  const AiTutorChatPage({super.key});

  @override
  State<AiTutorChatPage> createState() => _AiTutorChatPageState();
}

class _AiTutorChatPageState extends State<AiTutorChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize chat with welcome message
    context.read<AiTutorBloc>().add(const InitializeChat());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage(String message) {
    context.read<AiTutorBloc>().add(SendMessage(message));
    // Delay scroll to allow message to be added
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _handleClearChat() {
    context.read<AiTutorBloc>().add(const ClearChat());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: BlocConsumer<AiTutorBloc, AiTutorState>(
              listener: (context, state) {
                // Scroll to bottom when new message is added
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });
              },
              builder: (context, state) {
                return _buildMessagesList(state);
              },
            ),
          ),
          // Chat input
          BlocBuilder<AiTutorBloc, AiTutorState>(
            builder: (context, state) {
              return ChatInput(
                onSendMessage: _handleSendMessage,
                isLoading: state is AiTutorLoading,
                quickQuestions: QuickQuestions.all,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build the app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A1A2E),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF7931A)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          // Satoshi Mentor avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B4EE6), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B4EE6).withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text('₿', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Satoshi Mentor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'En línea',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF6B4EE6)),
          onPressed: _handleClearChat,
          tooltip: 'Limpiar chat',
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Color(0xFF6B4EE6)),
          onPressed: () => _showInfoDialog(),
          tooltip: 'Acerca de',
        ),
      ],
    );
  }

  /// Build the messages list
  Widget _buildMessagesList(AiTutorState state) {
    if (state.messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return MessageBubble(message: message);
      },
    );
  }

  /// Build empty state placeholder
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B4EE6), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B4EE6).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text('₿', style: TextStyle(fontSize: 50)),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 2000.ms,
              ),
          const SizedBox(height: 24),
          const Text(
            'Satoshi Mentor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Tu guía en el mundo de Bitcoin',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  /// Show info dialog
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFF6B4EE6),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6B4EE6), Color(0xFF8B5CF6)],
                ),
              ),
              child: const Center(
                child: Text('₿', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Satoshi Mentor',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu tutor de Bitcoin dentro de BITQUEST.',
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            _buildInfoItem('📚', 'Aprende Bitcoin desde cero'),
            _buildInfoItem('🇲🇽', 'Ejemplos para México'),
            _buildInfoItem('🔐', 'Sin consejos de inversión'),
            _buildInfoItem('⚡', 'Respuestas claras y rápidas'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Entendido',
              style: TextStyle(color: Color(0xFFF7931A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// /// Export for easy access
// export 'chat_page.dart';
// export 'bloc/ai_tutor_bloc.dart';
// export 'bloc/ai_tutor_event.dart';
// export 'bloc/ai_tutor_state.dart';
// export 'models/chat_message.dart';
// export 'services/ai_tutor_service.dart';
// export 'widgets/message_bubble.dart';
// export 'widgets/chat_input.dart';
