import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/chat_message.dart';

/// Widget for the chat input field with send button
class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;
  final List<QuickQuestion>? quickQuestions;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.isLoading = false,
    this.quickQuestions,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showQuickQuestions = true;
  int _charCount = 0;
  static const int _maxChars = 500;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _charCount = _controller.text.length;
      _showQuickQuestions = _controller.text.isEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;

    widget.onSendMessage(text);
    _controller.clear();
    setState(() {
      _charCount = 0;
      _showQuickQuestions = true;
    });
  }

  void _handleQuickQuestion(QuickQuestion question) {
    widget.onSendMessage(question.question);
    setState(() {
      _showQuickQuestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quick questions
            if (_showQuickQuestions && widget.quickQuestions != null)
              _buildQuickQuestions(),
            // Input field
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  /// Build quick questions section
  Widget _buildQuickQuestions() {
    final questions = widget.quickQuestions ?? QuickQuestions.all;

    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return _buildQuickQuestionChip(question, index);
        },
      ),
    );
  }

  /// Build a single quick question chip
  Widget _buildQuickQuestionChip(QuickQuestion question, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: widget.isLoading ? null : () => _handleQuickQuestion(question),
        backgroundColor: const Color(0xFF2D1F4E),
        side: const BorderSide(
          color: Color(0xFF6B4EE6),
          width: 1,
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question.emoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              question.question,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .slideX(begin: 0.3, duration: 300.ms);
  }

  /// Build the input field with send button
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF16162A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _focusNode.hasFocus
                      ? const Color(0xFFF7931A)
                      : const Color(0xFF2D1F4E),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !widget.isLoading,
                    maxLines: 4,
                    minLines: 1,
                    maxLength: _maxChars,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _handleSend(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      counterText: '',
                      suffixIcon: _charCount > 400
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                '$_charCount/$_maxChars',
                                style: TextStyle(
                                  color: _charCount > _maxChars
                                      ? Colors.red
                                      : Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 60,
                        minHeight: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Send button
          _buildSendButton(),
        ],
      ),
    );
  }

  /// Build the send button
  Widget _buildSendButton() {
    final canSend = _controller.text.trim().isNotEmpty && !widget.isLoading;

    return GestureDetector(
      onTap: canSend ? _handleSend : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: canSend
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF7931A), Color(0xFFE5810F)],
                )
              : null,
          color: canSend ? null : const Color(0xFF2D1F4E),
          shape: BoxShape.circle,
          boxShadow: canSend
              ? [
                  BoxShadow(
                    color: const Color(0xFFF7931A).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(
                Icons.send_rounded,
                color: canSend ? Colors.white : Colors.grey[600],
                size: 22,
              ),
      ),
    )
        .animate(target: canSend ? 1 : 0)
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: 200.ms,
        );
  }
}

/// Character counter widget
class CharacterCounter extends StatelessWidget {
  final int current;
  final int max;

  const CharacterCounter({
    super.key,
    required this.current,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final isNearLimit = current > max * 0.8;
    final isOverLimit = current > max;

    return Text(
      '$current/$max',
      style: TextStyle(
        color: isOverLimit
            ? Colors.red
            : isNearLimit
                ? Colors.orange
                : Colors.grey[500],
        fontSize: 11,
      ),
    );
  }
}
