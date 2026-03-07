/// Level progress tracking model
class LevelProgress {
  final String levelId;
  final String missionId;
  final bool completed;
  final int attempts;
  final int bestScore;
  final DateTime? completedAt;
  final DateTime? startedAt;

  const LevelProgress({
    required this.levelId,
    required this.missionId,
    this.completed = false,
    this.attempts = 0,
    this.bestScore = 0,
    this.completedAt,
    this.startedAt,
  });

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      levelId: json['levelId'] as String? ?? '',
      missionId: json['missionId'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      attempts: json['attempts'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'missionId': missionId,
      'completed': completed,
      'attempts': attempts,
      'bestScore': bestScore,
      'completedAt': completedAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
    };
  }

  LevelProgress copyWith({
    String? levelId,
    String? missionId,
    bool? completed,
    int? attempts,
    int? bestScore,
    DateTime? completedAt,
    DateTime? startedAt,
  }) {
    return LevelProgress(
      levelId: levelId ?? this.levelId,
      missionId: missionId ?? this.missionId,
      completed: completed ?? this.completed,
      attempts: attempts ?? this.attempts,
      bestScore: bestScore ?? this.bestScore,
      completedAt: completedAt ?? this.completedAt,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

/// Level difficulty enumeration
enum LevelDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

extension LevelDifficultyExtension on LevelDifficulty {
  String get label {
    switch (this) {
      case LevelDifficulty.beginner:
        return 'Beginner';
      case LevelDifficulty.intermediate:
        return 'Intermediate';
      case LevelDifficulty.advanced:
        return 'Advanced';
      case LevelDifficulty.expert:
        return 'Expert';
    }
  }

  int get value {
    switch (this) {
      case LevelDifficulty.beginner:
        return 1;
      case LevelDifficulty.intermediate:
        return 2;
      case LevelDifficulty.advanced:
        return 3;
      case LevelDifficulty.expert:
        return 4;
    }
  }

  static LevelDifficulty fromValue(int value) {
    switch (value) {
      case 1:
        return LevelDifficulty.beginner;
      case 2:
        return LevelDifficulty.intermediate;
      case 3:
        return LevelDifficulty.advanced;
      case 4:
        return LevelDifficulty.expert;
      default:
        return LevelDifficulty.beginner;
    }
  }
}
