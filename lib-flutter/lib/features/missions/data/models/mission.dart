import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

/// Mission model representing a learning path in BitQuest
class Mission {
  final String id;
  final String title;
  final String description;
  final String icon;
  final Color color;
  final int order;
  final int xpReward;
  final bool unlocked;
  final List<Level> levels;
  final String category;

  const Mission({
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

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '📚',
      color: _parseColor(json['color'] as String?),
      order: json['order'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 100,
      unlocked: json['unlocked'] as bool? ?? false,
      levels: (json['levels'] as List?)
          ?.map((e) => Level.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      category: json['category'] as String? ?? 'basics',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color.value.toString(),
      'order': order,
      'xpReward': xpReward,
      'unlocked': unlocked,
      'levels': levels.map((e) => e.toJson()).toList(),
      'category': category,
    };
  }

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    Color? color,
    int? order,
    int? xpReward,
    bool? unlocked,
    List<Level>? levels,
    String? category,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      order: order ?? this.order,
      xpReward: xpReward ?? this.xpReward,
      unlocked: unlocked ?? this.unlocked,
      levels: levels ?? this.levels,
      category: category ?? this.category,
    );
  }

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

  static Color _parseColor(String? colorStr) {
    if (colorStr == null) return AppColors.bitcoinOrange;
    try {
      final value = int.parse(colorStr);
      return Color(value);
    } catch (_) {
      return AppColors.bitcoinOrange;
    }
  }
}

/// Level model for mission sub-tasks
class Level {
  final String id;
  final String missionId;
  final String title;
  final String content;
  final int order;
  final bool completed;
  final int xpReward;
  final List<QuizQuestion> quiz;
  final String? videoUrl;
  final String? imageUrl;

  const Level({
    required this.id,
    required this.missionId,
    required this.title,
    required this.content,
    this.order = 0,
    this.completed = false,
    this.xpReward = 25,
    this.quiz = const [],
    this.videoUrl,
    this.imageUrl,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'] as String? ?? '',
      missionId: json['missionId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      xpReward: json['xpReward'] as int? ?? 25,
      quiz: (json['quiz'] as List?)
          ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      videoUrl: json['videoUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'missionId': missionId,
      'title': title,
      'content': content,
      'order': order,
      'completed': completed,
      'xpReward': xpReward,
      'quiz': quiz.map((e) => e.toJson()).toList(),
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
    };
  }

  Level copyWith({
    String? id,
    String? missionId,
    String? title,
    String? content,
    int? order,
    bool? completed,
    int? xpReward,
    List<QuizQuestion>? quiz,
    String? videoUrl,
    String? imageUrl,
  }) {
    return Level(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      title: title ?? this.title,
      content: content ?? this.content,
      order: order ?? this.order,
      completed: completed ?? this.completed,
      xpReward: xpReward ?? this.xpReward,
      quiz: quiz ?? this.quiz,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

/// Quiz question model
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      options: (json['options'] as List?)
          ?.map((e) => e as String)
          .toList() ?? [],
      correctIndex: json['correctIndex'] as int? ?? 0,
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
    };
  }

  /// Get correct answer
  String get correctAnswer => options[correctIndex];
}
