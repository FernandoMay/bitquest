import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../models/player_model.dart';

/// Local data source for offline data persistence
class LocalDataSource {
  final StorageService _storageService;

  LocalDataSource({required StorageService storageService})
      : _storageService = storageService;

  /// Initialize local data source
  static Future<LocalDataSource> init() async {
    await StorageService.init();
    return LocalDataSource(storageService: StorageService.instance);
  }

  // ============ Player Data ============

  /// Save player data
  Future<bool> savePlayer(Player player) async {
    return _storageService.savePlayerData(player.toJson());
  }

  /// Get player data
  Player? getPlayer() {
    final data = _storageService.getPlayerData();
    if (data == null) return null;
    return Player.fromJson(data);
  }

  /// Create new player
  Future<Player> createPlayer(String name) async {
    final player = Player.create(name: name);
    await savePlayer(player);
    return player;
  }

  /// Update player XP
  Future<Player> addXp(Player player, int xp) async {
    final newTotalXp = player.totalXp + xp;
    final newLevelXp = player.currentLevelXp + xp;
    
    // Calculate new level
    final newLevel = LevelCalculator.levelFromXp(newTotalXp);
    
    final updatedPlayer = player.copyWith(
      totalXp: newTotalXp,
      currentLevelXp: newLevelXp,
      level: newLevel,
      lastActive: DateTime.now(),
    );
    
    await savePlayer(updatedPlayer);
    return updatedPlayer;
  }

  /// Mark mission as completed
  Future<Player> completeMission(Player player, String missionId) async {
    if (player.completedMissions.contains(missionId)) {
      return player;
    }
    
    final updatedMissions = [...player.completedMissions, missionId];
    final updatedPlayer = player.copyWith(
      completedMissions: updatedMissions,
      lastActive: DateTime.now(),
    );
    
    await savePlayer(updatedPlayer);
    return updatedPlayer;
  }

  /// Add badge to player
  Future<Player> addBadge(Player player, String badgeId) async {
    if (player.badges.contains(badgeId)) {
      return player;
    }
    
    final updatedBadges = [...player.badges, badgeId];
    final updatedPlayer = player.copyWith(
      badges: updatedBadges,
      lastActive: DateTime.now(),
    );
    
    await savePlayer(updatedPlayer);
    return updatedPlayer;
  }

  /// Update player stats
  Future<Player> updateStats(
    Player player,
    PlayerStats Function(PlayerStats) updater,
  ) async {
    final updatedStats = updater(player.stats);
    final updatedPlayer = player.copyWith(
      stats: updatedStats,
      lastActive: DateTime.now(),
    );
    
    await savePlayer(updatedPlayer);
    return updatedPlayer;
  }

  // ============ Settings ============

  /// Get app settings
  AppSettings getSettings() {
    final data = _storageService.getSettings();
    if (data == null) return AppSettings();
    return AppSettings.fromJson(data);
  }

  /// Save app settings
  Future<bool> saveSettings(AppSettings settings) async {
    return _storageService.saveSettings(settings.toJson());
  }

  // ============ Onboarding ============

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return _storageService.isOnboardingComplete();
  }

  /// Mark onboarding as complete
  Future<bool> setOnboardingComplete(bool value) async {
    return _storageService.setOnboardingComplete(value);
  }

  // ============ Cache ============

  /// Cache a value with expiry
  Future<bool> cacheWithExpiry(
    String key,
    String value,
    Duration expiry,
  ) async {
    final expiryTime = DateTime.now().add(expiry).toIso8601String();
    await _storageService.setString('$key:expiry', expiryTime);
    return _storageService.setString(key, value);
  }

  /// Get cached value if not expired
  String? getCached(String key) {
    final expiryTimeStr = _storageService.getString('$key:expiry');
    if (expiryTimeStr == null) return null;
    
    final expiryTime = DateTime.parse(expiryTimeStr);
    if (DateTime.now().isAfter(expiryTime)) {
      // Cache expired, remove it
      _storageService.remove(key);
      _storageService.remove('$key:expiry');
      return null;
    }
    
    return _storageService.getString(key);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    final keys = _storageService.getAllKeys();
    for (final key in keys) {
      if (key.contains(':expiry') || _storageService.getString('$key:expiry') != null) {
        await _storageService.remove(key);
      }
    }
  }

  // ============ Clear Data ============

  /// Clear all player data (for reset)
  Future<bool> clearPlayerData() async {
    return _storageService.clearPlayerData();
  }

  /// Clear all data
  Future<bool> clearAll() async {
    return _storageService.clearAll();
  }
}

/// Level calculator helper class
class LevelCalculator {
  /// Calculate level from total XP
  static int levelFromXp(int totalXp) {
    int level = 1;
    int xpNeeded = AppConstants.baseXpPerLevel;
    int accumulatedXp = 0;
    
    while (accumulatedXp + xpNeeded <= totalXp && 
           level < AppConstants.maxLevel) {
      accumulatedXp += xpNeeded;
      level++;
      xpNeeded = (xpNeeded * AppConstants.xpMultiplier).round();
    }
    
    return level;
  }

  /// Calculate XP required for a specific level
  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    
    int totalXp = 0;
    int xpNeeded = AppConstants.baseXpPerLevel;
    
    for (int i = 1; i < level; i++) {
      totalXp += xpNeeded;
      xpNeeded = (xpNeeded * AppConstants.xpMultiplier).round();
    }
    
    return totalXp;
  }

  /// Calculate progress within current level (0.0 to 1.0)
  static double progressInLevel(int totalXp) {
    final currentLevel = levelFromXp(totalXp);
    final xpForCurrentLevel = xpRequiredForLevel(currentLevel);
    final xpForNextLevel = xpRequiredForLevel(currentLevel + 1);
    final xpInCurrentLevel = totalXp - xpForCurrentLevel;
    final xpNeededForNext = xpForNextLevel - xpForCurrentLevel;
    
    if (xpNeededForNext <= 0) return 1.0;
    return (xpInCurrentLevel / xpNeededForNext).clamp(0.0, 1.0);
  }

  /// Calculate XP needed to reach next level
  static int xpToNextLevel(int totalXp) {
    final nextLevel = levelFromXp(totalXp) + 1;
    final xpForNextLevel = xpRequiredForLevel(nextLevel);
    return xpForNextLevel - totalXp;
  }
}
