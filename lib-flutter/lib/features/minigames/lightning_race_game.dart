import 'dart:async';
import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/game_button.dart';
import 'components/game_progress.dart';
import 'components/game_over_overlay.dart';

/// Lightning Race Game - Simple payment simulation game
/// Compare speeds: Bank (3 days) vs Bitcoin (10 min) vs Lightning (1 sec)
class LightningRaceGame extends StatefulWidget {
  final VoidCallback? onComplete;

  const LightningRaceGame({
    super.key,
    this.onComplete,
  });

  @override
  State<LightningRaceGame> createState() => _LightningRaceGameState();
}

class _LightningRaceGameState extends State<LightningRaceGame>
    with TickerProviderStateMixin {
  late LightningRaceGameInstance _game;
  bool _showTutorial = true;
  bool _isGameOver = false;
  int _score = 0;
  int _racesCompleted = 0;
  int _xpEarned = 0;

  @override
  void initState() {
    super.initState();
    _game = LightningRaceGameInstance(
      onRaceComplete: _onRaceComplete,
      onScoreUpdate: _onScoreUpdate,
    );
  }

  void _onScoreUpdate(int points) {
    setState(() {
      _score += points;
      _xpEarned += (points ~/ 10);
    });
  }

  void _onRaceComplete() {
    setState(() {
      _racesCompleted++;
    });

    if (_racesCompleted >= 3) {
      setState(() {
        _isGameOver = true;
      });
    }
  }

  void _restartGame() {
    setState(() {
      _isGameOver = false;
      _score = 0;
      _racesCompleted = 0;
      _xpEarned = 0;
      _game = LightningRaceGameInstance(
        onRaceComplete: _onRaceComplete,
        onScoreUpdate: _onScoreUpdate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: GameWidget<LightningRaceGameInstance>(
                    game: _game,
                  ),
                ),
              ],
            ),
            if (_showTutorial)
              _buildTutorialOverlay(),
            if (_isGameOver)
              GameOverOverlay(
                isWin: true,
                score: _score,
                xpEarned: _xpEarned,
                stars: _calculateStars(),
                onPlayAgain: _restartGame,
                onMainMenu: () => Navigator.of(context).pop(),
                message: 'You completed $_racesCompleted payment races!',
              ),
          ],
        ),
      ),
    );
  }

  int _calculateStars() {
    if (_racesCompleted >= 3 && _score >= 300) return 3;
    if (_racesCompleted >= 2) return 2;
    return 1;
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonGame(
                icon: Icons.close,
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
              Column(
                children: [
                  const Text(
                    'Lightning Race',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Race $_racesCompleted/3',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7931A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StepProgress(
            currentStep: _racesCompleted,
            totalSteps: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => setState(() => _showTutorial = false),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16213E),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.flash_on,
                        size: 64,
                        color: Color(0xFFF7931A),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Lightning Race!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      _buildPaymentMethodCard(
                        'Bank Transfer',
                        '3 days',
                        Colors.red,
                        Icons.account_balance,
                      ),
                      const SizedBox(height: 8),
                      _buildPaymentMethodCard(
                        'Bitcoin On-Chain',
                        '10 minutes',
                        const Color(0xFFF7931A),
                        Icons.currency_bitcoin,
                      ),
                      const SizedBox(height: 8),
                      _buildPaymentMethodCard(
                        'Lightning Network',
                        '1 second',
                        const Color(0xFF00D26A),
                        Icons.flash_on,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Watch the payments race!\nTap Start to begin.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GameButton(
                  text: 'Start Race',
                  onPressed: () => setState(() => _showTutorial = false),
                  icon: Icons.play_arrow,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(String name, String time, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Flame game instance for Lightning Race
class LightningRaceGameInstance extends FlameGame with TapCallbacks {
  final VoidCallback onRaceComplete;
  final Function(int) onScoreUpdate;

  late RaceTrack _raceTrack;
  late StartButton _startButton;
  late PaymentInfoPanel _infoPanel;

  bool _isRacing = false;
  int _racesCompleted = 0;

  LightningRaceGameInstance({
    required this.onRaceComplete,
    required this.onScoreUpdate,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add background
    add(RaceBackground());

    // Add race track
    _raceTrack = RaceTrack(
      position: Vector2(20, 100),
      onRaceEnd: _onRaceEnd,
    );
    add(_raceTrack);

    // Add info panel
    _infoPanel = PaymentInfoPanel(position: Vector2(size.x / 2, 60));
    add(_infoPanel);

    // Add start button
    _startButton = StartButton(
      position: Vector2(size.x / 2, size.y - 80),
      onTap: _startRace,
    );
    add(_startButton);
  }

  void _startRace() {
    if (_isRacing) return;

    setState(() {
      _isRacing = true;
    });

    _raceTrack.startRace();
    _infoPanel.showRacing();
    HapticFeedback.mediumImpact();
  }

  void _onRaceEnd(String winner) {
    _isRacing = false;
    _racesCompleted++;

    // Award points based on who won
    if (winner == 'lightning') {
      onScoreUpdate(150);
      _infoPanel.showWinner('Lightning Network', const Color(0xFF00D26A));
    } else if (winner == 'bitcoin') {
      onScoreUpdate(100);
      _infoPanel.showWinner('Bitcoin', const Color(0xFFF7931A));
    } else {
      onScoreUpdate(50);
      _infoPanel.showWinner('Bank', Colors.red);
    }

    HapticFeedback.heavyImpact();

    // Notify parent after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      onRaceComplete();
      _resetRace();
    });
  }

  void _resetRace() {
    _raceTrack.reset();
    _infoPanel.showReady();
    _isRacing = false;
  }
}

/// Race background with track markings
class RaceBackground extends Component with HasGameRef {
  @override
  void render(Canvas canvas) {
    // Dark background
    final paint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );

    // Decorative lines
    final linePaint = Paint()
      ..color = const Color(0xFF16213E)
      ..strokeWidth = 1;

    for (var i = 0; i < gameRef.size.x.toInt(); i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), gameRef.size.y),
        linePaint,
      );
    }
  }
}

/// Race track with three lanes
class RaceTrack extends PositionComponent {
  final Function(String) onRaceEnd;

  late PaymentRunner _bankRunner;
  late PaymentRunner _bitcoinRunner;
  late PaymentRunner _lightningRunner;

  bool _isRacing = false;
  double _elapsedTime = 0;

  RaceTrack({
    required super.position,
    required this.onRaceEnd,
  }) : super(size: Vector2(320, 350));

  @override
  Future<void> onLoad() async {
    // Add track lanes
    add(TrackLane(
      position: Vector2(0, 0),
      label: 'Bank',
      color: Colors.red,
      timeInSeconds: 259200, // 3 days in seconds (scaled for game)
    ));

    add(TrackLane(
      position: Vector2(0, 110),
      label: 'Bitcoin',
      color: const Color(0xFFF7931A),
      timeInSeconds: 600, // 10 minutes
    ));

    add(TrackLane(
      position: Vector2(0, 220),
      label: 'Lightning',
      color: const Color(0xFF00D26A),
      timeInSeconds: 1, // 1 second
    ));

    // Add runners
    _bankRunner = PaymentRunner(
      position: Vector2(30, 35),
      speed: 0.001,
      color: Colors.red,
      icon: Icons.account_balance,
    );
    add(_bankRunner);

    _bitcoinRunner = PaymentRunner(
      position: Vector2(30, 145),
      speed: 0.5,
      color: const Color(0xFFF7931A),
      icon: Icons.currency_bitcoin,
    );
    add(_bitcoinRunner);

    _lightningRunner = PaymentRunner(
      position: Vector2(30, 255),
      speed: 5.0,
      color: const Color(0xFF00D26A),
      icon: Icons.flash_on,
    );
    add(_lightningRunner);

    // Add finish line
    add(FinishLine(position: Vector2(size.x - 40, 0)));
  }

  void startRace() {
    _isRacing = true;
    _elapsedTime = 0;
    _bankRunner.reset();
    _bitcoinRunner.reset();
    _lightningRunner.reset();
  }

  void reset() {
    _isRacing = false;
    _elapsedTime = 0;
    _bankRunner.reset();
    _bitcoinRunner.reset();
    _lightningRunner.reset();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isRacing) return;

    _elapsedTime += dt;

    // Move runners
    _bankRunner.updatePosition(dt);
    _bitcoinRunner.updatePosition(dt);
    _lightningRunner.updatePosition(dt);

    // Check for winner
    final finishX = size.x - 80;

    if (_lightningRunner.position.x >= finishX && _isRacing) {
      _isRacing = false;
      onRaceEnd('lightning');
    } else if (_bitcoinRunner.position.x >= finishX && _isRacing) {
      _isRacing = false;
      onRaceEnd('bitcoin');
    } else if (_bankRunner.position.x >= finishX && _isRacing) {
      _isRacing = false;
      onRaceEnd('bank');
    }
  }

  @override
  void render(Canvas canvas) {
    // Track background
    final paint = Paint()..color = const Color(0xFF0F0F1A);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(16),
    );
    canvas.drawRRect(rrect, paint);

    // Track border
    final borderPaint = Paint()
      ..color = const Color(0xFFF7931A).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);
  }
}

/// Individual track lane
class TrackLane extends PositionComponent {
  final String label;
  final Color color;
  final int timeInSeconds;

  TrackLane({
    required super.position,
    required this.label,
    required this.color,
    required this.timeInSeconds,
  }) : super(size: Vector2(320, 100));

  @override
  void render(Canvas canvas) {
    // Lane background
    final paint = Paint()
      ..color = color.withOpacity(0.1);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    // Lane divider
    final dividerPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.y),
      Offset(size.x, size.y),
      dividerPaint,
    );

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(10, 10));

    // Time estimate
    final timeText = _formatTime(timeInSeconds);
    final timePainter = TextPainter(
      text: TextSpan(
        text: timeText,
        style: TextStyle(
          color: color.withOpacity(0.7),
          fontSize: 11,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    timePainter.paint(canvas, const Offset(10, 30));
  }

  String _formatTime(int seconds) {
    if (seconds >= 86400) {
      return '~${(seconds / 86400).round()} days';
    } else if (seconds >= 3600) {
      return '~${(seconds / 3600).round()} hours';
    } else if (seconds >= 60) {
      return '~${(seconds / 60).round()} min';
    }
    return '$seconds sec';
  }
}

/// Payment runner (moving icon)
class PaymentRunner extends PositionComponent {
  final double speed;
  final Color color;
  final IconData icon;

  double _startX = 0;
  double _progress = 0;
  bool _isMoving = false;
  double _pulsePhase = 0;

  PaymentRunner({
    required super.position,
    required this.speed,
    required this.color,
    required this.icon,
  }) : super(size: Vector2(40, 40)) {
    _startX = position.x;
  }

  void reset() {
    position.x = _startX;
    _progress = 0;
    _isMoving = false;
  }

  void updatePosition(double dt) {
    _isMoving = true;
    _pulsePhase += dt * 5;

    // Calculate movement based on speed
    final targetX = 280.0; // Finish line position
    final distance = targetX - _startX;

    // Different movement patterns
    if (speed >= 5.0) {
      // Lightning - instant burst
      position.x = math.min(position.x + distance * dt * 2, targetX);
    } else if (speed >= 0.5) {
      // Bitcoin - steady progress
      position.x = math.min(position.x + distance * dt * 0.3, targetX);
    } else {
      // Bank - very slow
      position.x = math.min(position.x + distance * dt * 0.05, targetX);
    }
  }

  @override
  void render(Canvas canvas) {
    final scale = _isMoving ? 1.0 + 0.1 * math.sin(_pulsePhase) : 1.0;

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 20 * scale, glowPaint);

    // Background circle
    final bgPaint = Paint()..color = color;
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), 18 * scale, bgPaint);

    // Icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontSize: 20 * scale,
          fontFamily: icon.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size.x - iconPainter.width) / 2,
        (size.y - iconPainter.height) / 2,
      ),
    );
  }
}

/// Finish line component
class FinishLine extends PositionComponent {
  FinishLine({required super.position}) : super(size: Vector2(10, 350));

  @override
  void render(Canvas canvas) {
    // Checkered pattern
    const squareSize = 10.0;
    for (var y = 0; y < size.y / squareSize; y++) {
      for (var x = 0; x < 2; x++) {
        final isWhite = (x + y) % 2 == 0;
        final paint = Paint()..color = isWhite ? Colors.white : Colors.black;
        canvas.drawRect(
          Rect.fromLTWH(x * squareSize, y * squareSize, squareSize, squareSize),
          paint,
        );
      }
    }
  }
}

/// Start button component
class StartButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;
  bool _isPressed = false;
  double _pulseValue = 0;

  StartButton({
    required super.position,
    required this.onTap,
  }) : super(size: Vector2(200, 60));

  @override
  void update(double dt) {
    _pulseValue += dt * 2;
    if (_pulseValue > 1) _pulseValue = 0;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    _isPressed = true;
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    _isPressed = false;
    onTap();
    return true;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    _isPressed = false;
    return true;
  }

  @override
  void render(Canvas canvas) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final scale = _isPressed ? 0.95 : 1.0 + 0.02 * math.sin(_pulseValue * math.pi);

    // Glow
    final glowPaint = Paint()
      ..color = bitcoinOrange.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size.x * scale, height: size.y * scale),
        const Radius.circular(30),
      ),
      glowPaint,
    );

    // Button
    final bgPaint = Paint()..color = bitcoinOrange;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: size.x * scale, height: size.y * scale),
        const Radius.circular(30),
      ),
      bgPaint,
    );

    // Icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.play_arrow.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontSize: 28 * scale,
          fontFamily: Icons.play_arrow.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(-iconPainter.width / 2, -iconPainter.height / 2),
    );

    // Text
    const textPainter = TextPainter(
      text: TextSpan(
        text: '  START RACE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2 + 14, -textPainter.height / 2),
    );
  }
}

/// Payment info panel showing current status
class PaymentInfoPanel extends PositionComponent {
  String _status = 'Ready to race!';
  Color _statusColor = Colors.white54;

  PaymentInfoPanel({required super.position}) : super(size: Vector2(300, 60));

  void showRacing() {
    _status = 'Racing...';
    _statusColor = const Color(0xFFF7931A);
  }

  void showReady() {
    _status = 'Ready to race!';
    _statusColor = Colors.white54;
  }

  void showWinner(String winner, Color color) {
    _status = '$winner wins!';
    _statusColor = color;
  }

  @override
  void render(Canvas canvas) {
    // Status text
    final textPainter = TextPainter(
      text: TextSpan(
        text: _status,
        style: TextStyle(
          color: _statusColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}
