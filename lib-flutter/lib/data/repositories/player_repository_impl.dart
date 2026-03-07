import '../datasources/local_data_source.dart';
import '../models/player_model.dart';

/// Implementation of player repository
class PlayerRepositoryImpl {
  final LocalDataSource _localDataSource;

  PlayerRepositoryImpl({required LocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  /// Get current player
  Future<Player?> getPlayer() async {
    return _localDataSource.getPlayer();
  }

  /// Create new player
  Future<Player> createPlayer(String name) async {
    return _localDataSource.createPlayer(name);
  }

  /// Update player data
  Future<Player> updatePlayer(Player player) async {
    await _localDataSource.savePlayer(player);
    return player;
  }

  /// Add XP to player
  Future<Player> addXp(Player player, int xp) async {
    return _localDataSource.addXp(player, xp);
  }

  /// Complete a mission
  Future<Player> completeMission(Player player, String missionId, int xpReward) async {
    final updatedPlayer = await _localDataSource.completeMission(player, missionId);
    return addXp(updatedPlayer, xpReward);
  }

  /// Add badge to player
  Future<Player> addBadge(Player player, String badgeId) async {
    final badge = BitQuestBadges.findById(badgeId);
    var updatedPlayer = await _localDataSource.addBadge(player, badgeId);
    
    // Add XP bonus from badge
    if (badge != null && badge.xpBonus > 0) {
      updatedPlayer = await addXp(updatedPlayer, badge.xpBonus);
    }
    
    return updatedPlayer;
  }

  /// Update player stats
  Future<Player> updateStats(
    Player player,
    PlayerStats Function(PlayerStats) updater,
  ) async {
    return _localDataSource.updateStats(player, updater);
  }

  /// Check if player has badge
  bool hasBadge(Player player, String badgeId) {
    return player.badges.contains(badgeId);
  }

  /// Check if mission is completed
  bool isMissionCompleted(Player player, String missionId) {
    return player.completedMissions.contains(missionId);
  }

  /// Get player's earned badges
  List<Badge> getEarnedBadges(Player player) {
    return player.badges
        .map((id) => BitQuestBadges.findById(id))
        .whereType<Badge>()
        .toList();
  }

  /// Check for new badges based on achievements
  Future<List<Badge>> checkForNewBadges(Player player) async {
    final newBadges = <Badge>[];
    
    // Check for quiz master badge
    if (!hasBadge(player, 'quiz_master') && 
        player.stats.quizzesPassed >= 5 &&
        player.stats.quizAccuracy == 100) {
      newBadges.add(BitQuestBadges.findById('quiz_master')!);
    }
    
    // Check for bitcoin scholar badge (all beginner missions completed)
    // This would be checked against the actual mission count
    
    // Check for mining expert badge
    if (!hasBadge(player, 'mining_expert') && 
        player.stats.blocksMined >= 10) {
      newBadges.add(BitQuestBadges.findById('hash_master')!);
    }
    
    // Add new badges to player
    for (final badge in newBadges) {
      await addBadge(player, badge.id);
    }
    
    return newBadges;
  }

  /// Reset player progress
  Future<void> resetPlayer() async {
    await _localDataSource.clearPlayerData();
  }
}
