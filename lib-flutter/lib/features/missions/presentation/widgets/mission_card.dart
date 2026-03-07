import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../data/models/mission.dart';

/// Card widget for displaying mission information
class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback? onTap;

  const MissionCard({
    super.key,
    required this.mission,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: mission.unlocked 
                ? AppColors.bitcoinOrange.withOpacity(0.3)
                : AppColors.grayLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mission.unlocked 
                    ? AppColors.bitcoinOrange.withOpacity(0.1)
                    : AppColors.grayLight.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Mission icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: mission.unlocked 
                          ? AppColors.bitcoinOrange.withOpacity(0.2)
                          : AppColors.grayLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        mission.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Mission info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDifficultyText(mission.category),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Lock/unlock icon
                  if (!mission.unlocked)
                    const Icon(
                      Icons.lock,
                      color: AppColors.textSecondary,
                      size: 20,
                    )
                  else if (mission.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mission.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Progress and XP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Progress bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: mission.progress,
                              backgroundColor: AppColors.grayLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                mission.isCompleted 
                                    ? AppColors.success
                                    : AppColors.bitcoinOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // XP reward
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Reward',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+${mission.xpReward} XP',
                            style: const TextStyle(
                              color: AppColors.bitcoinOrange,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get difficulty text from category
  String _getDifficultyText(String category) {
    switch (category.toLowerCase()) {
      case 'basics':
        return 'Básico';
      case 'intermediate':
        return 'Intermedio';
      case 'advanced':
        return 'Avanzado';
      case 'lightning':
        return 'Lightning';
      default:
        return 'Básico';
    }
  }
}
