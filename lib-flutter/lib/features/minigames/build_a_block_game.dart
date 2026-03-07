import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/game_button.dart';
import 'components/xp_popup.dart';
import 'components/game_progress.dart';
import 'components/game_over_overlay.dart';

/// Build a Block Game - Drag and drop game where user arranges block components
/// Components: transactions, timestamp, previous hash, nonce
class BuildABlockGame extends StatefulWidget {
  final int difficulty; // 1 = easy, 2 = medium, 3 = hard
  final VoidCallback? onComplete;

  const BuildABlockGame({
    super.key,
    this.difficulty = 1,
    this.onComplete,
  });

  @override
  State<BuildABlockGame> createState() => _BuildABlockGameState();
}

class _BuildABlockGameState extends State<BuildABlockGame> {
  late BuildABlockGameInstance _game;
  bool _showTutorial = true;
  bool _isGameOver = false;
  bool _isWin = false;
  int _score = 0;
  int _xpEarned = 0;
  int _currentRound = 1;
  final int _totalRounds = 3;

  @override
  void initState() {
    super.initState();
    _game = BuildABlockGameInstance(
      difficulty: widget.difficulty,
      onScoreUpdate: _onScoreUpdate,
      onRoundComplete: _onRoundComplete,
    );
  }

  void _onScoreUpdate(int points) {
    setState(() {
      _score += points;
      _xpEarned += (points ~/ 10);
    });
  }

  void _onRoundComplete(bool success) {
    if (success) {
      if (_currentRound < _totalRounds) {
        setState(() {
          _currentRound++;
        });
        _game.nextRound();
      } else {
        setState(() {
          _isGameOver = true;
          _isWin = true;
        });
      }
    } else {
      setState(() {
        _isGameOver = true;
        _isWin = false;
      });
    }
  }

  void _restartGame() {
    setState(() {
      _isGameOver = false;
      _isWin = false;
      _score = 0;
      _xpEarned = 0;
      _currentRound = 1;
      _game = BuildABlockGameInstance(
        difficulty: widget.difficulty,
        onScoreUpdate: _onScoreUpdate,
        onRoundComplete: _onRoundComplete,
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
                  child: GameWidget<BuildABlockGameInstance>(
                    game: _game,
                  ),
                ),
              ],
            ),
            if (_showTutorial)
              TutorialOverlay(
                title: 'Build a Block',
                steps: [
                  const TutorialStep(
                    title: 'Build a Bitcoin Block!',
                    description:
                        'Learn how Bitcoin blocks are structured by assembling the components in the correct order.',
                    icon: Icons.widgets,
                  ),
                  const TutorialStep(
                    title: 'Drag Components',
                    description:
                        'Drag each component (Transactions, Timestamp, Previous Hash, Nonce) into the block structure.',
                    icon: Icons.drag_indicator,
                  ),
                  const TutorialStep(
                    title: 'Correct Order',
                    description:
                        'Place components in the right slots. Green glow means correct position!',
                    icon: Icons.check_circle,
                  ),
                ],
                onStart: () => setState(() => _showTutorial = false),
                onSkip: () => setState(() => _showTutorial = false),
              ),
            if (_isGameOver)
              GameOverOverlay(
                isWin: _isWin,
                score: _score,
                xpEarned: _xpEarned,
                stars: _isWin ? _calculateStars() : 0,
                onPlayAgain: _restartGame,
                onMainMenu: () => Navigator.of(context).pop(),
                message: _isWin
                    ? 'You understand Bitcoin block structure!'
                    : 'Try again to master block building!',
              ),
          ],
        ),
      ),
    );
  }

  int _calculateStars() {
    if (_score >= 300) return 3;
    if (_score >= 200) return 2;
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
                    'Build a Block',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Round $_currentRound/$_totalRounds',
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
          StepProgress(
            currentStep: _currentRound - 1,
            totalSteps: _totalRounds,
          ),
        ],
      ),
    );
  }
}

/// Flame game instance for Build a Block
class BuildABlockGameInstance extends FlameGame with HasCollisionDetection {
  final int difficulty;
  final Function(int) onScoreUpdate;
  final Function(bool) onRoundComplete;

  late BlockStructure _blockStructure;
  late List<DraggableComponent> _draggableComponents;
  late DropZoneManager _dropZoneManager;
  int _placedCorrectly = 0;
  int _totalComponents = 4;

  BuildABlockGameInstance({
    required this.difficulty,
    required this.onScoreUpdate,
    required this.onRoundComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initializeGame();
  }

  void _initializeGame() {
    // Add background
    add(GameBackground());

    // Create block structure (drop zones)
    _blockStructure = BlockStructure();
    add(_blockStructure);

    // Create draggable components
    _draggableComponents = [];
    _createDraggableComponents();

    // Create drop zone manager
    _dropZoneManager = DropZoneManager(
      onComponentPlaced: _onComponentPlaced,
    );
    add(_dropZoneManager);
  }

  void _createDraggableComponents() {
    final components = [
      BlockComponentData(
        id: 'transactions',
        name: 'Transactions',
        icon: Icons.receipt_long,
        color: const Color(0xFF00D26A),
        description: 'List of all transactions in this block',
      ),
      BlockComponentData(
        id: 'timestamp',
        name: 'Timestamp',
        icon: Icons.access_time,
        color: const Color(0xFF3498DB),
        description: 'When this block was created',
      ),
      BlockComponentData(
        id: 'previous_hash',
        name: 'Previous Hash',
        icon: Icons.link,
        color: const Color(0xFF9B59B6),
        description: 'Hash of the previous block in the chain',
      ),
      BlockComponentData(
        id: 'nonce',
        name: 'Nonce',
        icon: Icons.shuffle,
        color: const Color(0xFFF7931A),
        description: 'Number that makes the block hash valid',
      ),
    ];

    // Shuffle components for game challenge
    components.shuffle();

    double startY = 100;
    for (var i = 0; i < components.length; i++) {
      final draggable = DraggableComponent(
        data: components[i],
        position: Vector2(size.x - 150, startY + i * 90),
        onDragEnded: _handleDragEnd,
      );
      _draggableComponents.add(draggable);
      add(draggable);
    }
  }

  void _handleDragEnd(DraggableComponent component, Vector2 position) {
    _dropZoneManager.checkDrop(component, position);
  }

  void _onComponentPlaced(String componentId, bool isCorrect) {
    if (isCorrect) {
      _placedCorrectly++;
      onScoreUpdate(100);

      // Play success sound placeholder
      // Haptic feedback
      HapticFeedback.mediumImpact();

      if (_placedCorrectly >= _totalComponents) {
        onRoundComplete(true);
      }
    } else {
      HapticFeedback.lightImpact();
    }
  }

  void nextRound() {
    // Reset for next round
    _placedCorrectly = 0;

    // Remove old components
    for (var component in _draggableComponents) {
      remove(component);
    }
    _draggableComponents.clear();

    // Reset drop zones
    _blockStructure.reset();

    // Create new shuffled components
    _createDraggableComponents();
  }
}

/// Game background component
class GameBackground extends Component with HasGameRef {
  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawRect(Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y), paint);

    // Draw grid pattern
    final gridPaint = Paint()
      ..color = const Color(0xFF16213E)
      ..strokeWidth = 1;

    const gridSize = 40.0;
    for (double x = 0; x < gameRef.size.x; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, gameRef.size.y),
        gridPaint,
      );
    }
    for (double y = 0; y < gameRef.size.y; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(gameRef.size.x, y),
        gridPaint,
      );
    }
  }
}

/// Block structure with drop zones
class BlockStructure extends PositionComponent {
  final List<DropZone> dropZones = [];
  final bitcoinOrange = const Color(0xFFF7931A);

  @override
  Future<void> onLoad() async {
    size = Vector2(250, 400);
    position = Vector2(50, 100);

    // Create drop zones for each component
    final zoneData = [
      ('transactions', 'Transactions', const Color(0xFF00D26A)),
      ('timestamp', 'Timestamp', const Color(0xFF3498DB)),
      ('previous_hash', 'Previous Hash', const Color(0xFF9B59B6)),
      ('nonce', 'Nonce', const Color(0xFFF7931A)),
    ];

    for (var i = 0; i < zoneData.length; i++) {
      final zone = DropZone(
        id: zoneData[i].$1,
        label: zoneData[i].$2,
        color: zoneData[i].$3,
        position: Vector2(10, 20.0 + i * 95),
        size: Vector2(230, 80),
      );
      dropZones.add(zone);
      add(zone);
    }
  }

  void reset() {
    for (var zone in dropZones) {
      zone.reset();
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw block container
    final paint = Paint()
      ..color = const Color(0xFF16213E)
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(16),
    );
    canvas.drawRRect(rrect, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = bitcoinOrange.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);

    // Draw header
    final headerPaint = Paint()..color = bitcoinOrange;
    final headerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, 50),
      const Radius.circular(16),
    );
    canvas.drawRRect(headerRRect, headerPaint);

    // Draw block title
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '📦 Bitcoin Block',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(20, 15));
  }
}

/// Drop zone for component placement
class DropZone extends PositionComponent with HasGameRef {
  final String id;
  final String label;
  final Color color;
  bool isOccupied = false;
  bool isCorrect = false;
  String? placedComponentId;

  DropZone({
    required this.id,
    required this.label,
    required this.color,
    required super.position,
    required super.size,
  });

  void reset() {
    isOccupied = false;
    isCorrect = false;
    placedComponentId = null;
  }

  @override
  void render(Canvas canvas) {
    // Draw zone background
    final paint = Paint()
      ..color = isCorrect
          ? color.withOpacity(0.3)
          : (isOccupied ? Colors.red.withOpacity(0.3) : Colors.black26);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, paint);

    // Draw border
    final borderPaint = Paint()
      ..color = isCorrect
          ? color
          : (isOccupied ? Colors.red : color.withOpacity(0.5))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rrect, borderPaint);

    // Draw label if not occupied
    if (!isOccupied) {
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.drag_handle.codePoint),
          style: TextStyle(
            color: color.withOpacity(0.5),
            fontSize: 24,
            fontFamily: Icons.drag_handle.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      iconPainter.paint(canvas, Offset((size.x - 24) / 2, 10));

      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
          canvas, Offset((size.x - textPainter.width) / 2, 45));
    }
  }

  bool checkDrop(String componentId, Vector2 globalPosition) {
    final localPos = globalPosition - absolutePosition;
    if (containsLocalPoint(localPos)) {
      return true;
    }
    return false;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return point.x >= 0 &&
        point.x <= size.x &&
        point.y >= 0 &&
        point.y <= size.y;
  }
}

/// Data class for block components
class BlockComponentData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  BlockComponentData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

/// Draggable component
class DraggableComponent extends PositionComponent
    with DragCallbacks, HasGameRef {
  final BlockComponentData data;
  final Function(DraggableComponent, Vector2) onDragEnded;

  bool _isDragging = false;
  bool _isPlaced = false;
  Vector2? _originalPosition;

  DraggableComponent({
    required this.data,
    required super.position,
    required this.onDragEnded,
  }) : super(size: Vector2(120, 70));

  @override
  Future<void> onLoad() async {
    _originalPosition = position.clone();
  }

  @override
  bool onDragStart(DragStartEvent event) {
    if (_isPlaced) return false;
    _isDragging = true;
    priority = 100; // Bring to front while dragging
    return true;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    if (!_isDragging) return false;
    position += event.localDelta;
    return true;
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    _isDragging = false;
    priority = 0;
    onDragEnded(this, position);
    return true;
  }

  void snapBack() {
    if (_originalPosition != null) {
      position = _originalPosition!.clone();
    }
  }

  void placed() {
    _isPlaced = true;
  }

  @override
  void render(Canvas canvas) {
    if (_isPlaced) return;

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black38
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, 4, size.x, size.y),
        const Radius.circular(12),
      ),
      shadowPaint,
    );

    // Draw background
    final bgPaint = Paint()..color = const Color(0xFF16213E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(12),
      ),
      bgPaint,
    );

    // Draw border
    final borderPaint = Paint()
      ..color = data.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(12),
      ),
      borderPaint,
    );

    // Draw icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(data.icon.codePoint),
        style: TextStyle(
          color: data.color,
          fontSize: 24,
          fontFamily: data.icon.fontFamily,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    iconPainter.paint(canvas, const Offset(10, 15));

    // Draw name
    final textPainter = TextPainter(
      text: TextSpan(
        text: data.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(10, 48));
  }
}

/// Drop zone manager
class DropZoneManager extends Component with HasGameRef<BuildABlockGameInstance> {
  final Function(String, bool) onComponentPlaced;

  DropZoneManager({required this.onComponentPlaced});

  void checkDrop(DraggableComponent component, Vector2 position) {
    final blockStructure = gameRef.children.whereType<BlockStructure>().first;

    for (var zone in blockStructure.dropZones) {
      if (zone.checkDrop(component.data.id, position)) {
        // Check if correct placement
        final isCorrect = zone.id == component.data.id;

        zone.isOccupied = true;
        zone.isCorrect = isCorrect;
        zone.placedComponentId = component.data.id;

        if (isCorrect) {
          component.placed();
        } else {
          component.snapBack();
          zone.reset();
        }

        onComponentPlaced(component.data.id, isCorrect);
        return;
      }
    }

    // No valid drop zone, snap back
    component.snapBack();
  }
}
