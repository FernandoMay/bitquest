import 'package:flutter/material.dart';

/// Progress indicator for games with visual feedback
class GameProgress extends StatelessWidget {
  final int current;
  final int total;
  final double height;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showLabel;
  final String? label;

  const GameProgress({
    super.key,
    required this.current,
    required this.total,
    this.height = 12,
    this.progressColor,
    this.backgroundColor,
    this.showLabel = true,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkCard = const Color(0xFF16213E);
    final progress = total > 0 ? current / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label ?? 'Progress',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$current / $total',
                style: TextStyle(
                  color: progressColor ?? bitcoinOrange,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        if (showLabel) const SizedBox(height: 8),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? darkCard,
            borderRadius: BorderRadius.circular(height / 2),
            border: Border.all(
              color: (progressColor ?? bitcoinOrange).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          progressColor ?? bitcoinOrange,
                          (progressColor ?? bitcoinOrange).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: (progressColor ?? bitcoinOrange).withOpacity(0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Circular progress indicator for games
class CircularGameProgress extends StatelessWidget {
  final int current;
  final int total;
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;
  final Widget? center;

  const CircularGameProgress({
    super.key,
    required this.current,
    required this.total,
    this.size = 80,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkCard = const Color(0xFF16213E);
    final progress = total > 0 ? current / total : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            color: backgroundColor ?? darkCard,
          ),
          // Progress circle
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                color: progressColor ?? bitcoinOrange,
                strokeCap: StrokeCap.round,
              );
            },
          ),
          // Center content
          center ??
              (showPercentage
                  ? Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: progressColor ?? bitcoinOrange,
                        fontSize: size * 0.2,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

/// Step progress indicator for multi-stage games
class StepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double lineWidth;

  const StepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 12,
    this.lineWidth = 40,
  });

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkCard = const Color(0xFF16213E);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isLast = index == totalSteps - 1;

        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? (activeColor ?? bitcoinOrange) : (inactiveColor ?? darkCard),
                border: Border.all(
                  color: (activeColor ?? bitcoinOrange).withOpacity(isActive ? 1 : 0.3),
                  width: 2,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: (activeColor ?? bitcoinOrange).withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
            if (!isLast)
              Container(
                width: lineWidth,
                height: 2,
                color: index < currentStep
                    ? (activeColor ?? bitcoinOrange)
                    : (inactiveColor ?? darkCard),
              ),
          ],
        );
      }),
    );
  }
}

/// Timer progress bar for timed games
class TimerProgress extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimeout;
  final bool isPaused;
  final double height;

  const TimerProgress({
    super.key,
    required this.duration,
    required this.onTimeout,
    this.isPaused = false,
    this.height = 8,
  });

  @override
  State<TimerProgress> createState() => _TimerProgressState();
}

class _TimerProgressState extends State<TimerProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimeout();
      }
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(TimerProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused && !_controller.isCompleted) {
      _controller.stop();
    } else if (!widget.isPaused && !_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final red = Colors.red;
    final darkCard = const Color(0xFF16213E);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = 1.0 - _controller.value;
        final color = progress > 0.3 ? bitcoinOrange : red;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: darkCard,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: constraints.maxWidth * progress,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(widget.height / 2),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
