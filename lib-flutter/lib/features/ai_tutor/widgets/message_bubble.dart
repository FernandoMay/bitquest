import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

/// Widget for displaying a chat message bubble
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final Animation<double>? animation;

  const MessageBubble({
    super.key,
    required this.message,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final isTyping = message.isTyping;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(isTyping),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildBubble(context, isUser, isTyping),
                const SizedBox(height: 4),
                _buildTimestamp(context),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isUser) _buildAvatar(false),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(
          begin: isUser ? 0.2 : -0.2,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  /// Build the avatar for the message sender
  Widget _buildAvatar(bool isTyping) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: message.sender == MessageSender.user
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF7931A), Color(0xFFFFB347)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B4EE6), Color(0xFF8B5CF6)],
              ),
        boxShadow: [
          BoxShadow(
            color: (message.sender == MessageSender.user
                    ? const Color(0xFFF7931A)
                    : const Color(0xFF6B4EE6))
                .withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: isTyping
            ? _buildTypingIndicator()
            : Text(
                message.sender == MessageSender.user ? '👤' : '₿',
                style: const TextStyle(fontSize: 20),
              ),
      ),
    );
  }

  /// Build typing indicator animation
  Widget _buildTypingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
              delay: Duration(milliseconds: index * 200),
            )
            .then()
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(0.5, 0.5),
              duration: 600.ms,
            );
      }),
    );
  }

  /// Build the message bubble
  Widget _buildBubble(BuildContext context, bool isUser, bool isTyping) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: isUser
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF7931A), Color(0xFFE5810F)],
              )
            : null,
        color: isUser ? null : const Color(0xFF2D1F4E),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isUser ? 20 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isUser
            ? null
            : Border.all(
                color: const Color(0xFF6B4EE6).withValues(alpha: 0.3),
                width: 1,
              ),
      ),
      child: isTyping
          ? const SizedBox(
              width: 60,
              child: Center(
                child: Text(
                  'pensando...',
                  style: TextStyle(
                    color: Color(0xFFA78BFA),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          : MarkdownBody(
              data: message.content,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFFE5E7EB),
                  fontSize: 15,
                  height: 1.5,
                ),
                strong: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFFF7931A),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                em: TextStyle(
                  color: isUser ? Colors.white.withValues(alpha: 0.9) : const Color(0xFFA78BFA),
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
                listBullet: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFFF7931A),
                ),
                h1: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFFF7931A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                h2: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFFF7931A),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                h3: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFFF7931A),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                blockquote: TextStyle(
                  color: isUser ? Colors.white.withValues(alpha: 0.8) : const Color(0xFF9CA3AF),
                  fontStyle: FontStyle.italic,
                ),
                code: TextStyle(
                  backgroundColor: isUser
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.3),
                  color: isUser ? Colors.white : const Color(0xFFA78BFA),
                  fontFamily: 'monospace',
                ),
              ),
              selectable: true,
            ),
    );
  }

  /// Build the timestamp
  Widget _buildTimestamp(BuildContext context) {
    final format = DateFormat.jm();
    final time = format.format(message.timestamp);

    return Padding(
      padding: EdgeInsets.only(
        left: message.sender == MessageSender.ai ? 8 : 0,
        right: message.sender == MessageSender.user ? 8 : 0,
      ),
      child: Text(
        time,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Typing indicator widget for AI messages
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B4EE6), Color(0xFF8B5CF6)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B4EE6).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text('₿', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1F4E),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: const Color(0xFF6B4EE6).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA78BFA),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      delay: Duration(milliseconds: index * 200),
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(0.5, 0.5),
                      duration: 600.ms,
                    );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
