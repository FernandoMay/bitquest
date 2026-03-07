import 'package:flutter/material.dart';

/// Mission entity for domain layer
class MissionEntity {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final int order;
  final int xpReward;
  final bool unlocked;
  final List<LevelEntity> levels;
  final String category;

  const MissionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.order = 0,
    this.xpReward = 100,
    this.unlocked = false,
    this.levels = const [],
    this.category = 'basics',
  });

  /// Calculate progress percentage
  double get progress {
    if (levels.isEmpty) return 0;
    final completedCount = levels.where((l) => l.completed).length;
    return completedCount / levels.length;
  }

  /// Check if mission is completed
  bool get isCompleted {
    if (levels.isEmpty) return false;
    return levels.every((l) => l.completed);
  }
}

/// Level entity for domain layer
class LevelEntity {
  final String id;
  final String missionId;
  final String title;
  final String content;
  final int order;
  final bool completed;
  final int xpReward;
  final List<QuizQuestionEntity> quiz;

  const LevelEntity({
    required this.id,
    required this.missionId,
    required this.title,
    required this.content,
    this.order = 0,
    this.completed = false,
    this.xpReward = 25,
    this.quiz = const [],
  });
}

/// Quiz question entity for domain layer
class QuizQuestionEntity {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const QuizQuestionEntity({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  String get correctAnswer => options[correctIndex];
}
