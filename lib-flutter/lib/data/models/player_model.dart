import '../../core/utils/extensions.dart';

/// Core player model representing the user's progress
class Player {
  final String id;
  final String name;
  final int level;
  final int totalXp;
  final int currentLevelXp;
  final List<String> completedMissions;
  final List<String> badges;
  final DateTime createdAt;
  final DateTime lastActive;
  final PlayerStats stats;

  Player({
    required this.id,
    required this.name,
    this.level = 1,
    this.totalXp = 0,
    this.currentLevelXp = 0,
    this.completedMissions = const [],
    this.badges = const [],
    required this.createdAt,
    required this.lastActive,
    this.stats = const PlayerStats(),
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Bitcoiner',
      level: json['level'] as int? ?? 1,
      totalXp: json['totalXp'] as int? ?? 0,
      currentLevelXp: json['currentLevelXp'] as int? ?? 0,
      completedMissions: (json['completedMissions'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
      badges: (json['badges'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'])
          : DateTime.now(),
      stats: json['stats'] != null
          ? PlayerStats.fromJson(json['stats'])
          : const PlayerStats(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'totalXp': totalXp,
      'currentLevelXp': currentLevelXp,
      'completedMissions': completedMissions,
      'badges': badges,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'stats': stats.toJson(),
    };
  }

  Player copyWith({
    String? id,
    String? name,
    int? level,
    int? totalXp,
    int? currentLevelXp,
    List<String>? completedMissions,
    List<String>? badges,
    DateTime? createdAt,
    DateTime? lastActive,
    PlayerStats? stats,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      currentLevelXp: currentLevelXp ?? this.currentLevelXp,
      completedMissions: completedMissions ?? this.completedMissions,
      badges: badges ?? this.badges,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      stats: stats ?? this.stats,
    );
  }

  /// Create a new player with default values
  factory Player.create({required String name}) {
    final now = DateTime.now();
    return Player(
      id: 'player_${now.millisecondsSinceEpoch}',
      name: name,
      createdAt: now,
      lastActive: now,
    );
  }
}

/// Player statistics
class PlayerStats {
  final int quizzesCompleted;
  final int quizzesPassed;
  final int gamesPlayed;
  final int gamesWon;
  final int questionsAnsweredCorrectly;
  final int totalQuestionsAnswered;
  final int blocksMined;
  final int transactionsSent;

  const PlayerStats({
    this.quizzesCompleted = 0,
    this.quizzesPassed = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.questionsAnsweredCorrectly = 0,
    this.totalQuestionsAnswered = 0,
    this.blocksMined = 0,
    this.transactionsSent = 0,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      quizzesCompleted: json['quizzesCompleted'] as int? ?? 0,
      quizzesPassed: json['quizzesPassed'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      gamesWon: json['gamesWon'] as int? ?? 0,
      questionsAnsweredCorrectly:
          json['questionsAnsweredCorrectly'] as int? ?? 0,
      totalQuestionsAnswered: json['totalQuestionsAnswered'] as int? ?? 0,
      blocksMined: json['blocksMined'] as int? ?? 0,
      transactionsSent: json['transactionsSent'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizzesCompleted': quizzesCompleted,
      'quizzesPassed': quizzesPassed,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'questionsAnsweredCorrectly': questionsAnsweredCorrectly,
      'totalQuestionsAnswered': totalQuestionsAnswered,
      'blocksMined': blocksMined,
      'transactionsSent': transactionsSent,
    };
  }

  PlayerStats copyWith({
    int? quizzesCompleted,
    int? quizzesPassed,
    int? gamesPlayed,
    int? gamesWon,
    int? questionsAnsweredCorrectly,
    int? totalQuestionsAnswered,
    int? blocksMined,
    int? transactionsSent,
  }) {
    return PlayerStats(
      quizzesCompleted: quizzesCompleted ?? this.quizzesCompleted,
      quizzesPassed: quizzesPassed ?? this.quizzesPassed,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      questionsAnsweredCorrectly:
          questionsAnsweredCorrectly ?? this.questionsAnsweredCorrectly,
      totalQuestionsAnswered:
          totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      blocksMined: blocksMined ?? this.blocksMined,
      transactionsSent: transactionsSent ?? this.transactionsSent,
    );
  }

  /// Calculate quiz accuracy percentage
  double get quizAccuracy {
    if (totalQuestionsAnswered == 0) return 0;
    return (questionsAnsweredCorrectly / totalQuestionsAnswered) * 100;
  }

  /// Calculate game win rate
  double get gameWinRate {
    if (gamesPlayed == 0) return 0;
    return (gamesWon / gamesPlayed) * 100;
  }
}

/// Badge model
class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String type;
  final DateTime? earnedAt;
  final int xpBonus;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    this.earnedAt,
    this.xpBonus = 0,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      type: json['type'] as String,
      earnedAt: json['earnedAt'] != null
          ? DateTime.parse(json['earnedAt'])
          : null,
      xpBonus: json['xpBonus'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'type': type,
      'earnedAt': earnedAt?.toIso8601String(),
      'xpBonus': xpBonus,
    };
  }
}

/// Predefined badges for BitQuest
class BitQuestBadges {
  BitQuestBadges._();

  static const List<Badge> allBadges = [
    Badge(
      id: 'first_block',
      name: 'First Block',
      description: 'Completed your first lesson',
      icon: '🎓',
      type: 'learning',
      xpBonus: 25,
    ),
    Badge(
      id: 'hash_master',
      name: 'Hash Master',
      description: 'Successfully mined 10 blocks in the Mine Hash game',
      icon: '⛏️',
      type: 'game',
      xpBonus: 50,
    ),
    Badge(
      id: 'lightning_fast',
      name: 'Lightning Fast',
      description: 'Complete the Lightning Race game in under 60 seconds',
      icon: '⚡',
      type: 'game',
      xpBonus: 75,
    ),
    Badge(
      id: 'quiz_master',
      name: 'Quiz Master',
      description: 'Get 100% on 5 quizzes',
      icon: '🏆',
      type: 'quiz',
      xpBonus: 100,
    ),
    Badge(
      id: 'early_adopter',
      name: 'Early Adopter',
      description: 'Joined BitQuest during the beta phase',
      icon: '🌟',
      type: 'special',
      xpBonus: 200,
    ),
    Badge(
      id: 'bitcoin_scholar',
      name: 'Bitcoin Scholar',
      description: 'Complete all beginner missions',
      icon: '📚',
      type: 'learning',
      xpBonus: 150,
    ),
    Badge(
      id: 'mining_expert',
      name: 'Mining Expert',
      description: 'Reach difficulty level 10 in Mine Hash',
      icon: '💎',
      type: 'game',
      xpBonus: 100,
    ),
    Badge(
      id: 'lightning_ninja',
      name: 'Lightning Ninja',
      description: 'Win 20 Lightning Race games',
      icon: '🥷',
      type: 'game',
      xpBonus: 150,
    ),
  ];

  static Badge? findById(String id) {
    try {
      return allBadges.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}
