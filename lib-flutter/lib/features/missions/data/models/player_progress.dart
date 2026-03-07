/// Player progress model for tracking mission and level completion
class PlayerProgress {
  final String playerId;
  final int totalXp;
  final int currentLevel;
  final int currentLevelXp;
  final Map<String, MissionProgress> missionProgress;
  final DateTime lastUpdated;

  const PlayerProgress({
    required this.playerId,
    this.totalXp = 0,
    this.currentLevel = 1,
    this.currentLevelXp = 0,
    this.missionProgress = const {},
    this.lastUpdated = const DateTime.now(),
  });

  factory PlayerProgress.fromJson(Map<String, dynamic> json) {
    final missionProgressMap = <String, MissionProgress>{};
    if (json['missionProgress'] != null) {
      (json['missionProgress'] as Map<String, dynamic>).forEach((key, value) {
        missionProgressMap[key] = MissionProgress.fromJson(value);
      });
    }

    return PlayerProgress(
      playerId: json['playerId'] as String? ?? '',
      totalXp: json['totalXp'] as int? ?? 0,
      currentLevel: json['currentLevel'] as int? ?? 1,
      currentLevelXp: json['currentLevelXp'] as int? ?? 0,
      missionProgress: missionProgressMap,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'totalXp': totalXp,
      'currentLevel': currentLevel,
      'currentLevelXp': currentLevelXp,
      'missionProgress': missionProgress.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  PlayerProgress copyWith({
    String? playerId,
    int? totalXp,
    int? currentLevel,
    int? currentLevelXp,
    Map<String, MissionProgress>? missionProgress,
    DateTime? lastUpdated,
  }) {
    return PlayerProgress(
      playerId: playerId ?? this.playerId,
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      currentLevelXp: currentLevelXp ?? this.currentLevelXp,
      missionProgress: missionProgress ?? this.missionProgress,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Get progress for a specific mission
  MissionProgress? getMissionProgress(String missionId) {
    return missionProgress[missionId];
  }

  /// Calculate overall completion percentage
  double get overallCompletion {
    if (missionProgress.isEmpty) return 0;
    final totalProgress = missionProgress.values
        .map((m) => m.progressPercentage)
        .reduce((a, b) => a + b);
    return totalProgress / missionProgress.length;
  }
}

/// Mission progress model
class MissionProgress {
  final String missionId;
  final bool unlocked;
  final bool completed;
  final List<String> completedLevels;
  final int currentLevelIndex;
  final int totalXpEarned;
  final int attempts;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const MissionProgress({
    required this.missionId,
    this.unlocked = false,
    this.completed = false,
    this.completedLevels = const [],
    this.currentLevelIndex = 0,
    this.totalXpEarned = 0,
    this.attempts = 0,
    this.startedAt,
    this.completedAt,
  });

  factory MissionProgress.fromJson(Map<String, dynamic> json) {
    return MissionProgress(
      missionId: json['missionId'] as String? ?? '',
      unlocked: json['unlocked'] as bool? ?? false,
      completed: json['completed'] as bool? ?? false,
      completedLevels: (json['completedLevels'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
      currentLevelIndex: json['currentLevelIndex'] as int? ?? 0,
      totalXpEarned: json['totalXpEarned'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'missionId': missionId,
      'unlocked': unlocked,
      'completed': completed,
      'completedLevels': completedLevels,
      'currentLevelIndex': currentLevelIndex,
      'totalXpEarned': totalXpEarned,
      'attempts': attempts,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  MissionProgress copyWith({
    String? missionId,
    bool? unlocked,
    bool? completed,
    List<String>? completedLevels,
    int? currentLevelIndex,
    int? totalXpEarned,
    int? attempts,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return MissionProgress(
      missionId: missionId ?? this.missionId,
      unlocked: unlocked ?? this.unlocked,
      completed: completed ?? this.completed,
      completedLevels: completedLevels ?? this.completedLevels,
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      attempts: attempts ?? this.attempts,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// Calculate progress percentage
  double get progressPercentage {
    if (completedLevels.isEmpty) return 0;
    // This would need the total level count from the mission
    return completedLevels.length / 5; // Assuming 5 levels per mission
  }

  /// Check if a level is completed
  bool isLevelCompleted(String levelId) {
    return completedLevels.contains(levelId);
  }

  /// Add a completed level
  MissionProgress addCompletedLevel(String levelId, int xpEarned) {
    if (completedLevels.contains(levelId)) return this;
    
    return copyWith(
      completedLevels: [...completedLevels, levelId],
      totalXpEarned: totalXpEarned + xpEarned,
    );
  }
}
