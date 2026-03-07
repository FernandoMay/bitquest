import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'game_button.dart';

/// Game completion screen overlay
class GameOverOverlay extends StatefulWidget {
  final bool isWin;
  final int score;
  final int xpEarned;
  final int? highScore;
  final int stars; // 0-3 stars rating
  final VoidCallback onPlayAgain;
  final VoidCallback? onNextLevel;
  final VoidCallback onMainMenu;
  final String? title;
  final String? message;

  const GameOverOverlay({
    super.key,
    required this.isWin,
    required this.score,
    required this.xpEarned,
    this.highScore,
    this.stars = 0,
    required this.onPlayAgain,
    this.onNextLevel,
    required this.onMainMenu,
    this.title,
    this.message,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _starsController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _starsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Curves.easeOutCubic,
      ),
    );

    _mainController.forward().then((_) {
      if (widget.isWin && widget.stars > 0) {
        _starsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkBg = const Color(0xFF1A1A2E);
    final darkCard = const Color(0xFF16213E);
    final green = const Color(0xFF00D26A);
    final red = const Color(0xFFFF4757);

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: darkCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: widget.isWin
                              ? green.withOpacity(0.5)
                              : red.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (widget.isWin ? green : red).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          Text(
                            widget.title ?? (widget.isWin ? 'Victory!' : 'Game Over'),
                            style: TextStyle(
                              color: widget.isWin ? green : red,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Stars (if won)
                          if (widget.isWin) _buildStars(),
                          if (widget.isWin) const SizedBox(height: 16),
                          // Score
                          _buildStatRow(
                            'Score',
                            '${widget.score}',
                            bitcoinOrange,
                            Icons.score,
                          ),
                          const SizedBox(height: 12),
                          // XP Earned
                          _buildStatRow(
                            'XP Earned',
                            '+${widget.xpEarned}',
                            green,
                            Icons.star,
                          ),
                          if (widget.highScore != null) ...[
                            const SizedBox(height: 12),
                            _buildStatRow(
                              'High Score',
                              '${widget.highScore}',
                              Colors.purple,
                              Icons.emoji_events,
                            ),
                          ],
                          if (widget.message != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              widget.message!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          const SizedBox(height: 24),
                          // Buttons
                          if (widget.isWin && widget.onNextLevel != null) ...[
                            GameButton(
                              text: 'Next Level',
                              onPressed: widget.onNextLevel!,
                              icon: Icons.arrow_forward,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 12),
                          ],
                          GameButton(
                            text: 'Play Again',
                            onPressed: widget.onPlayAgain,
                            isOutlined: true,
                            width: double.infinity,
                          ),
                          const SizedBox(height: 12),
                          GameButton(
                            text: 'Main Menu',
                            onPressed: widget.onMainMenu,
                            backgroundColor: Colors.grey.shade700,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStars() {
    return AnimatedBuilder(
      animation: _starsController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isFilled = index < widget.stars;
            final delay = index * 0.3;
            final animationValue = Curves.elasticOut.transform(
              (_starsController.value - delay).clamp(0.0, 1.0),
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Transform.scale(
                scale: isFilled ? animationValue : 1.0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: isFilled ? 1 : 0),
                  duration: Duration(milliseconds: 500 + (index * 200)),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: isFilled ? value * math.pi * 2 : 0,
                      child: Icon(
                        Icons.star,
                        size: 48,
                        color: isFilled
                            ? const Color(0xFFFFD700)
                            : Colors.grey.shade600,
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildStatRow(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pause menu overlay
class PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;

  const PauseOverlay({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onMainMenu,
  });

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkCard = const Color(0xFF16213E);

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: darkCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: bitcoinOrange.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.pause_circle_filled,
                  size: 64,
                  color: bitcoinOrange,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Paused',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                GameButton(
                  text: 'Resume',
                  onPressed: onResume,
                  icon: Icons.play_arrow,
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                GameButton(
                  text: 'Restart',
                  onPressed: onRestart,
                  isOutlined: true,
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                GameButton(
                  text: 'Main Menu',
                  onPressed: onMainMenu,
                  backgroundColor: Colors.grey.shade700,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tutorial overlay for game instructions
class TutorialOverlay extends StatefulWidget {
  final String title;
  final List<TutorialStep> steps;
  final VoidCallback onStart;
  final VoidCallback onSkip;

  const TutorialOverlay({
    super.key,
    required this.title,
    required this.steps,
    required this.onStart,
    required this.onSkip,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      widget.onStart();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkCard = const Color(0xFF16213E);
    final step = widget.steps[_currentStep];

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: widget.onSkip,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                const Spacer(),
                // Content
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: darkCard,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      if (step.icon != null) ...[
                        Icon(
                          step.icon,
                          size: 64,
                          color: bitcoinOrange,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        step.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        step.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.steps.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentStep
                            ? bitcoinOrange
                            : Colors.grey.shade600,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Navigation buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: GameButton(
                          text: 'Back',
                          onPressed: _previousStep,
                          isOutlined: true,
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 16),
                    Expanded(
                      child: GameButton(
                        text: _currentStep < widget.steps.length - 1
                            ? 'Next'
                            : 'Start Game',
                        onPressed: _nextStep,
                        icon: _currentStep < widget.steps.length - 1
                            ? Icons.arrow_forward
                            : Icons.play_arrow,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorialStep {
  final String title;
  final String description;
  final IconData? icon;

  const TutorialStep({
    required this.title,
    required this.description,
    this.icon,
  });
}
