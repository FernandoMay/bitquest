import '../entities/mission_entity.dart';

/// Abstract repository interface for missions
abstract class MissionRepository {
  /// Load all missions
  Future<List<MissionEntity>> loadMissions();

  /// Get a specific mission by ID
  Future<MissionEntity?> getMission(String id);

  /// Unlock a mission
  Future<MissionEntity> unlockMission(String missionId);

  /// Mark a level as completed
  Future<MissionEntity> completeLevel(String missionId, String levelId);

  /// Get player progress for a mission
  Future<double> getMissionProgress(String missionId);

  /// Check if a mission is unlocked for the player
  Future<bool> isMissionUnlocked(String missionId);
}
