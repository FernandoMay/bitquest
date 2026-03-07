/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'BitQuest';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Learn Bitcoin through play';

  // XP and Leveling
  static const int baseXpPerLevel = 100;
  static const double xpMultiplier = 1.5;
  static const int maxLevel = 100;

  // Mission Configuration
  static const int missionsPerChapter = 5;
  static const int quizQuestionsPerMission = 5;
  static const int passingScorePercentage = 70;

  // Mini-game Rewards
  static const int buildABlockXp = 50;
  static const int mineHashXp = 75;
  static const int inflationSimXp = 60;
  static const int lightningRaceXp = 100;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 48.0;

  // Storage Keys
  static const String playerKey = 'player_data';
  static const String missionsKey = 'missions_data';
  static const String settingsKey = 'settings_data';
  static const String onboardingKey = 'onboarding_complete';

  // Badge Types
  static const List<String> badgeTypes = [
    'first_block',
    'hash_master',
    'lightning_fast',
    'quiz_master',
    'early_adopter',
    'bitcoin_scholar',
    'mining_expert',
    'lightning_ninja',
  ];

  // Bitcoin Education Topics
  static const List<String> learningTopics = [
    'What is Bitcoin?',
    'How Bitcoin Works',
    'Mining and Consensus',
    'Bitcoin Transactions',
    'Wallets and Security',
    'Lightning Network',
    'Bitcoin Economics',
    'Advanced Concepts',
  ];
}

/// Level calculation helper
class LevelCalculator {
  /// Calculate required XP for a given level
  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    return (AppConstants.baseXpPerLevel * 
            (level - 1) * 
            AppConstants.xpMultiplier)
        .round();
  }

  /// Calculate level from total XP
  static int levelFromXp(int totalXp) {
    int level = 1;
    int xpNeeded = AppConstants.baseXpPerLevel;
    
    while (totalXp >= xpNeeded && level < AppConstants.maxLevel) {
      totalXp -= xpNeeded;
      level++;
      xpNeeded = (xpNeeded * AppConstants.xpMultiplier).round();
    }
    
    return level;
  }

  /// Calculate XP progress within current level (0.0 to 1.0)
  static double progressInLevel(int totalXp) {
    final currentLevel = levelFromXp(totalXp);
    final xpForCurrentLevel = xpRequiredForLevel(currentLevel);
    final xpForNextLevel = xpRequiredForLevel(currentLevel + 1);
    final xpInCurrentLevel = totalXp - xpForCurrentLevel;
    final xpNeededForNext = xpForNextLevel - xpForCurrentLevel;
    
    return (xpInCurrentLevel / xpNeededForNext).clamp(0.0, 1.0);
  }
}
