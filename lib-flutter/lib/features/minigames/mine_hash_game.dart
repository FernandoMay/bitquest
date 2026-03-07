import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/game_button.dart';
import 'components/xp_popup.dart';
import 'components/game_progress.dart';
import 'components/game_over_overlay.dart';

/// Mine the Hash Game - Interactive mining simulation
/// User clicks/taps to try different nonces and find valid hashes
class MineHashGame extends StatefulWidget {
  final int difficulty; // 1 = easy, 2 = medium, 3 = hard
  final bool timedMode;
  final VoidCallback? onComplete;

  const MineHashGame({
    super.key,
    this.difficulty = 1,
    this.timedMode = false,
    this.onComplete,
  });

  @override
  State<MineHashGame> createState() => _MineHashGameState();
}

class _MineHashGameState extends State<MineHashGame> with TickerProviderStateMixin {
  late MineHashGameInstance _game;
  bool _showTutorial = true;
  bool _isGameOver = false;
  bool _isWin = false;
  int _score = 0;
  int _xpEarned = 0;
  int _blocksMined = 0;
  final int _targetBlocks = 3;

  // Timer for timed mode
  late AnimationController _timerController;
  int _remainingTime = 60;

  @override
  void initState() {
    super.initState();
    _game = MineHashGameInstance(
      difficulty: widget.difficulty,
      onScoreUpdate: _onScoreUpdate,
      onBlockMined: _onBlockMined,
      onHashGenerated: _onHashGenerated,
    );

    _timerController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingTime),
    );

    if (widget.timedMode) {
      _timerController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _endGame();
        }
      });
    }
  }

  void _onScoreUpdate(int points) {
    setState(() {
      _score += points;
      _xpEarned += (points ~/ 10);
    });
  }

  void _onBlockMined() {
    setState(() {
      _blocksMined++;
    });

    if (_blocksMined >= _targetBlocks && !widget.timedMode) {
      _endGame(isWin: true);
    }
  }

  void _onHashGenerated(String hash, bool isValid) {
    // Visual feedback for hash generation
  }

  void _startTimer() {
    _timerController.forward();
  }

  void _endGame({bool isWin = false}) {
    setState(() {
      _isGameOver = true;
      _isWin = isWin || _blocksMined > 0;
    });
  }

  void _restartGame() {
    setState(() {
      _isGameOver = false;
      _isWin = false;
      _score = 0;
      _xpEarned = 0;
      _blocksMined = 0;
      _remainingTime = 60;
      _timerController.reset();
      _game = MineHashGameInstance(
        difficulty: widget.difficulty,
        onScoreUpdate: _onScoreUpdate,
        onBlockMined: _onBlockMined,
        onHashGenerated: _onHashGenerated,
      );
    });
    if (widget.timedMode) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
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
                  child: GameWidget<MineHashGameInstance>(
                    game: _game,
                  ),
                ),
              ],
            ),
            if (_showTutorial)
              TutorialOverlay(
                title: 'Mine the Hash',
                steps: const [
                  TutorialStep(
                    title: 'Become a Bitcoin Miner!',
                    description:
                        'Try to find a hash that starts with zeros (the difficulty target). Click to try different nonces!',
                    icon: Icons.memory,
                  ),
                  TutorialStep(
                    title: 'Change the Nonce',
                    description:
                        'Each click changes the nonce and generates a new hash. Find one with enough leading zeros!',
                    icon: Icons.touch_app,
                  ),
                  TutorialStep(
                    title: 'Difficulty Matters',
                    description:
                        'Higher difficulty = more zeros needed. Easy: 1 zero, Medium: 2 zeros, Hard: 3 zeros',
                    icon: Icons.trending_up,
                  ),
                ],
                onStart: () {
                  setState(() => _showTutorial = false);
                  if (widget.timedMode) {
                    _startTimer();
                  }
                },
                onSkip: () {
                  setState(() => _showTutorial = false);
                  if (widget.timedMode) {
                    _startTimer();
                  }
                },
              ),
            if (_isGameOver)
              GameOverOverlay(
                isWin: _isWin,
                score: _score,
                xpEarned: _xpEarned,
                stars: _calculateStars(),
                onPlayAgain: _restartGame,
                onMainMenu: () => Navigator.of(context).pop(),
                message: _isWin
                    ? 'You mined $_blocksMined blocks!'
                    : 'Keep trying! Mining takes patience.',
              ),
          ],
        ),
      ),
    );
  }

  int _calculateStars() {
    if (_blocksMined >= 3) return 3;
    if (_blocksMined >= 2) return 2;
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
                  Text(
                    'Mine the Hash',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.timedMode
                        ? 'Time: ${(_remainingTime * (1 - _timerController.value)).round()}s'
                        : 'Blocks: $_blocksMined/$_targetBlocks',
                    style: TextStyle(
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
          if (widget.timedMode)
            TimerProgress(
              duration: Duration(seconds: _remainingTime),
              onTimeout: _endGame,
              height: 8,
            )
          else
            StepProgress(
              currentStep: _blocksMined,
              totalSteps: _targetBlocks,
            ),
        ],
      ),
    );
  }
}

/// Flame game instance for Mine the Hash
class MineHashGameInstance extends FlameGame with TapCallbacks {
  final int difficulty;
  final Function(int) onScoreUpdate;
  final Function() onBlockMined;
  final Function(String, bool) onHashGenerated;

  late HashDisplay _hashDisplay;
  late MiningButton _miningButton;
  late DifficultyIndicator _difficultyIndicator;
  late BlockPreview _blockPreview;

  int _currentNonce = 0;
  String _currentHash = '';
  int _targetZeros = 1;
  bool _foundValidHash = false;

  MineHashGameInstance({
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onBlockMined,
    required this.onHashGenerated,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _targetZeros = difficulty;

    // Add background
    add(MiningBackground());

    // Add block preview
    _blockPreview = BlockPreview(position: Vector2(size.x / 2, 100));
    add(_blockPreview);

    // Add hash display
    _hashDisplay = HashDisplay(position: Vector2(size.x / 2, 250));
    add(_hashDisplay);

    // Add difficulty indicator
    _difficultyIndicator = DifficultyIndicator(
      difficulty: difficulty,
      position: Vector2(size.x / 2, 350),
    );
    add(_difficultyIndicator);

    // Add mining button
    _miningButton = MiningButton(
      position: Vector2(size.x / 2, size.y - 150),
      onTap: _mineNextHash,
    );
    add(_miningButton);

    // Generate initial hash
    _generateHash();
  }

  void _generateHash() {
    // Simulate hash generation with realistic-looking hash
    final random = math.Random();
    final hashBuffer = StringBuffer();

    for (var i = 0; i < 64; i++) {
      hashBuffer.write(random.nextInt(16).toRadixString(16));
    }

    _currentHash = hashBuffer.toString();
    _hashDisplay.updateHash(_currentHash, false);
    onHashGenerated(_currentHash, false);
  }

  void _mineNextHash() {
    if (_foundValidHash) return;

    HapticFeedback.lightImpact();
    _currentNonce++;

    // Random chance to find valid hash based on difficulty
    final random = math.Random();
    final findChance = 1.0 / (math.pow(16, _targetZeros) * (5 - difficulty));

    if (random.nextDouble() < findChance || _currentNonce > 20) {
      // Found a valid hash!
      _foundValidHash = true;

      // Generate hash with leading zeros
      final hashBuffer = StringBuffer();
      for (var i = 0; i < _targetZeros; i++) {
        hashBuffer.write('0');
      }
      for (var i = _targetZeros; i < 64; i++) {
        hashBuffer.write(random.nextInt(16).toRadixString(16));
      }

      _currentHash = hashBuffer.toString();
      _hashDisplay.updateHash(_currentHash, true);
      _blockPreview.showSuccess();

      HapticFeedback.heavyImpact();
      onScoreUpdate(100 * difficulty);
      onHashGenerated(_currentHash, true);

      // Reset for next block after delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        onBlockMined();
        _resetForNextBlock();
      });
    } else {
      _generateHash();
      _blockPreview.incrementNonce(_currentNonce);
    }
  }

  void _resetForNextBlock() {
    _foundValidHash = false;
    _currentNonce = 0;
    _blockPreview.reset();
    _generateHash();
  }
}

/// Mining background with particle effects
class MiningBackground extends Component with HasGameRef {
  final List<MiningParticle> _particles = [];

  @override
  Future<void> onLoad() async {
    // Add ambient particles
    for (var i = 0; i < 20; i++) {
      final particle = MiningParticle();
      _particles.add(particle);
      add(particle);
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw gradient background
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, gameRef.size.y),
        [
          const Color(0xFF1A1A2E),
          const Color(0xFF0F0F1A),
        ],
      );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );

    // Draw circuit pattern
    final linePaint = Paint()
      ..color = const Color(0xFFF7931A).withOpacity(0.1)
      ..strokeWidth = 1;

    for (var i = 0; i < gameRef.size.x.toInt(); i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), gameRef.size.y),
        linePaint,
      );
    }
    for (var i = 0; i < gameRef.size.y.toInt(); i += 30) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(gameRef.size.x, i.toDouble()),
        linePaint,
      );
    }
  }
}

/// Mining particle effect
class MiningParticle extends PositionComponent with HasGameRef {
  double _speed = 0;
  double _opacity = 0;

  @override
  Future<void> onLoad() async {
    position = Vector2(
      gameRef.size.x * math.Random().nextDouble(),
      gameRef.size.y * math.Random().nextDouble(),
    );
    _speed = 20 + math.Random().nextDouble() * 30;
    _opacity = math.Random().nextDouble() * 0.3;
  }

  @override
  void update(double dt) {
    position.y -= _speed * dt;
    if (position.y < -10) {
      position.y = gameRef.size.y + 10;
      position.x = gameRef.size.x * math.Random().nextDouble();
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFF7931A).withOpacity(_opacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, 2, paint);
  }
}

/// Block preview showing mining progress
class BlockPreview extends PositionComponent {
  int _nonce = 0;
  bool _showingSuccess = false;
  final bitcoinOrange = const Color(0xFFF7931A);

  BlockPreview({required super.position}) : super(size: Vector2(300, 120));

  void incrementNonce(int nonce) {
    _nonce = nonce;
  }

  void showSuccess() {
    _showingSuccess = true;
  }

  void reset() {
    _nonce = 0;
    _showingSuccess = false;
  }

  @override
  void render(Canvas canvas) {
    // Draw block container
    final paint = Paint()
      ..color = _showingSuccess
          ? const Color(0xFF00D26A).withOpacity(0.2)
          : const Color(0xFF16213E);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      const Radius.circular(16),
    );
    canvas.drawRRect(rrect, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = _showingSuccess ? const Color(0xFF00D26A) : bitcoinOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);

    // Draw block icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(
            _showingSuccess ? Icons.verified.codePoint : Icons.widgets.codePoint),
        style: TextStyle(
          color: _showingSuccess ? const Color(0xFF00D26A) : bitcoinOrange,
          fontSize: 32,
          fontFamily: Icons.widgets.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(canvas, const Offset(-16, -50));

    // Draw nonce
    final noncePainter = TextPainter(
      text: TextSpan(
        text: 'Nonce: $_nonce',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    noncePainter.paint(canvas, Offset(-noncePainter.width / 2, 0));

    // Draw status
    final statusPainter = TextPainter(
      text: TextSpan(
        text: _showingSuccess ? '✓ Block Mined!' : 'Mining...',
        style: TextStyle(
          color: _showingSuccess ? const Color(0xFF00D26A) : Colors.white54,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    statusPainter.paint(canvas, Offset(-statusPainter.width / 2, 30));
  }
}

/// Hash display component
class HashDisplay extends PositionComponent {
  String _hash = '';
  bool _isValid = false;
  int _highlightZeros = 0;

  HashDisplay({required super.position}) : super(size: Vector2(320, 80));

  void updateHash(String hash, bool isValid) {
    _hash = hash;
    _isValid = isValid;
    _highlightZeros = 0;
    for (var i = 0; i < hash.length; i++) {
      if (hash[i] == '0') {
        _highlightZeros++;
      } else {
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw container
    final paint = Paint()..color = const Color(0xFF0F0F1A);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = _isValid
          ? const Color(0xFF00D26A)
          : const Color(0xFFF7931A).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rrect, borderPaint);

    // Draw hash in two lines
    if (_hash.isNotEmpty) {
      final hashLine1 = _hash.substring(0, 32);
      final hashLine2 = _hash.substring(32);

      _drawHashLine(canvas, hashLine1, -12);
      _drawHashLine(canvas, hashLine2, 12);
    }
  }

  void _drawHashLine(Canvas canvas, String hash, double yOffset) {
    double x = -size.x / 2 + 10;
    const charWidth = 8.0;

    for (var i = 0; i < hash.length; i++) {
      final isZero = hash[i] == '0' &&
          i < _highlightZeros ||
          (hash.length == 32 && i < _highlightZeros - 32);

      final textPainter = TextPainter(
        text: TextSpan(
          text: hash[i],
          style: TextStyle(
            color: isZero ? const Color(0xFF00D26A) : Colors.white70,
            fontSize: 12,
            fontFamily: 'Courier',
            fontWeight: isZero ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(x, yOffset - 6));
      x += charWidth;
    }
  }
}

/// Difficulty indicator showing required zeros
class DifficultyIndicator extends PositionComponent {
  final int difficulty;

  DifficultyIndicator({
    required this.difficulty,
    required super.position,
  }) : super(size: Vector2(200, 40));

  @override
  void render(Canvas canvas) {
    // Draw label
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'Target: ',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, const Offset(-100, -10));

    // Draw required zeros
    double x = -30;
    for (var i = 0; i < 3; i++) {
      final isActive = i < difficulty;
      final textPainter = TextPainter(
        text: TextSpan(
          text: '0',
          style: TextStyle(
            color: isActive ? const Color(0xFF00D26A) : Colors.grey.shade700,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(x, -12));
      x += 25;
    }
  }
}

/// Mining button component
class MiningButton extends PositionComponent with TapCallbacks {
  final VoidCallback onTap;
  bool _isPressed = false;
  double _pulseValue = 0;

  MiningButton({
    required super.position,
    required this.onTap,
  }) : super(size: Vector2(180, 60));

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
    final scale = _isPressed ? 0.95 : 1.0 + 0.02 * math.sin(_pulseValue * 3.14159);

    // Draw glow
    final glowPaint = Paint()
      ..color = bitcoinOrange.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset.zero, 50 * scale, glowPaint);

    // Draw button background
    final bgPaint = Paint()
      ..color = _isPressed ? bitcoinOrange.withOpacity(0.8) : bitcoinOrange;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.x * scale,
        height: size.y * scale,
      ),
      const Radius.circular(30),
    );
    canvas.drawRRect(rrect, bgPaint);

    // Draw icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.touch_app.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontSize: 28 * scale,
          fontFamily: Icons.touch_app.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(-iconPainter.width / 2, -iconPainter.height / 2 - 5),
    );

    // Draw text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'TAP TO MINE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, 15),
    );
  }
}


