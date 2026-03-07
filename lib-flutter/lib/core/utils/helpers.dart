import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Utility helper functions for BitQuest
class Helpers {
  Helpers._();

  /// Generate a random ID
  static String generateId({int length = 16}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// Calculate XP reward based on difficulty and performance
  static int calculateXpReward({
    required int baseXp,
    required double difficultyMultiplier,
    int bonusPercent = 0,
  }) {
    final bonus = baseXp * (bonusPercent / 100);
    return ((baseXp * difficultyMultiplier) + bonus).round();
  }

  /// Format large numbers (K, M, B)
  static String formatLargeNumber(num number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  /// Calculate quiz score percentage
  static double calculateScore(int correct, int total) {
    if (total == 0) return 0;
    return (correct / total) * 100;
  }

  /// Check if score is passing
  static bool isPassingScore(double score, {double threshold = 70}) {
    return score >= threshold;
  }

  /// Get difficulty label
  static String getDifficultyLabel(int level) {
    if (level <= 2) return 'Beginner';
    if (level <= 4) return 'Intermediate';
    if (level <= 6) return 'Advanced';
    return 'Expert';
  }

  /// Get difficulty color
  static Color getDifficultyColor(int level) {
    if (level <= 2) return AppColors.success;
    if (level <= 4) return AppColors.info;
    if (level <= 6) return AppColors.warning;
    return AppColors.error;
  }

  /// Generate a random hash-like string (for mining game simulation)
  static String generateRandomHash() {
    final random = Random();
    final buffer = StringBuffer();
    for (var i = 0; i < 64; i++) {
      final value = random.nextInt(16);
      buffer.write(value.toRadixString(16));
    }
    return buffer.toString();
  }

  /// Check if hash meets difficulty target (for mining game simulation)
  static bool hashMeetsTarget(String hash, int difficulty) {
    if (difficulty == 0) return true;
    final prefix = '0' * difficulty;
    return hash.startsWith(prefix);
  }

  /// Calculate block reward (halving logic)
  static double calculateBlockReward(int blockHeight) {
    const initialReward = 50.0;
    const halvingInterval = 210000;
    
    final int halvings = blockHeight ~/ halvingInterval;
    if (halvings >= 64) return 0; // Beyond maximum halvings
    
    return initialReward / (1 << halvings);
  }

  /// Get Bitcoin symbol
  static String getBitcoinSymbol({bool withCode = false}) {
    return withCode ? '₿ BTC' : '₿';
  }

  /// Convert satoshis to BTC
  static double satoshisToBtc(int satoshis) {
    return satoshis / 100000000;
  }

  /// Convert BTC to satoshis
  static int btcToSatoshis(double btc) {
    return (btc * 100000000).round();
  }
}

/// Animation helper for common animations
class AnimationHelper {
  AnimationHelper._();

  /// Create a curved animation
  static CurvedAnimation createCurvedAnimation({
    required AnimationController parent,
    Curve curve = Curves.easeInOut,
  }) {
    return CurvedAnimation(parent: parent, curve: curve);
  }

  /// Create a slide animation
  static Animation<Offset> createSlideAnimation({
    required AnimationController controller,
    Offset begin = const Offset(1, 0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Create a fade animation
  static Animation<double> createFadeAnimation({
    required AnimationController controller,
    double begin = 0,
    double end = 1,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// Create a scale animation
  static Animation<double> createScaleAnimation({
    required AnimationController controller,
    double begin = 0.8,
    double end = 1,
    Curve curve = Curves.easeInOut,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }
}

/// Quiz helper for quiz-related operations
class QuizHelper {
  QuizHelper._();

  /// Shuffle a list of questions
  static List<T> shuffleQuestions<T>(List<T> questions) {
    final shuffled = List<T>.from(questions);
    shuffled.shuffle(Random.secure());
    return shuffled;
  }

  /// Get feedback message based on score
  static String getScoreFeedback(double score) {
    if (score == 100) {
      return 'Perfect! You\'re a Bitcoin master! 🎉';
    } else if (score >= 90) {
      return 'Excellent work! Almost perfect! 🌟';
    } else if (score >= 80) {
      return 'Great job! You\'re learning fast! 💪';
    } else if (score >= 70) {
      return 'Good work! Keep learning! 📚';
    } else if (score >= 50) {
      return 'Not bad! Try reviewing the material. 📖';
    } else {
      return 'Keep trying! Practice makes perfect. 🔄';
    }
  }

  /// Calculate XP bonus based on score
  static int calculateScoreBonus(double score) {
    if (score == 100) return 50;
    if (score >= 90) return 30;
    if (score >= 80) return 20;
    if (score >= 70) return 10;
    return 0;
  }
}

/// Debouncer for limiting function calls
class Debouncer {
  Debouncer({this.milliseconds = 300});

  final int milliseconds;
  bool _isWaiting = false;

  /// Run a function after debounce delay
  void run(VoidCallback action) {
    if (_isWaiting) return;
    
    _isWaiting = true;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      _isWaiting = false;
      action();
    });
  }

  /// Reset the debouncer
  void reset() {
    _isWaiting = false;
  }
}

/// Throttler for limiting function call rate
class Throttler {
  Throttler({this.milliseconds = 300});

  final int milliseconds;
  DateTime? _lastRun;

  /// Run a function with throttling
  void run(VoidCallback action) {
    final now = DateTime.now();
    
    if (_lastRun == null || 
        now.difference(_lastRun!).inMilliseconds >= milliseconds) {
      _lastRun = now;
      action();
    }
  }

  /// Reset the throttler
  void reset() {
    _lastRun = null;
  }
}
