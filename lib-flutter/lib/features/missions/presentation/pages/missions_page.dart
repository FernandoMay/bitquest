import 'package:bitquest/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/missions_bloc.dart';
import '../../data/repositories/mission_repository_impl.dart';

/// Missions page showing all available learning missions
class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MissionsBloc(
        repository: MissionRepositoryImpl(),
      )..add(LoadMissions()),
      child: const MissionsView(),
    );
  }
}

class MissionsView extends StatelessWidget {
  const MissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        title: const Text('Missions'),
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
      ),
      body: BlocBuilder<MissionsBloc, MissionsState>(
        builder: (context, state) {
          if (state is MissionsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.bitcoinOrange,
              ),
            );
          }

          if (state is MissionsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading missions',
                    style: context.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MissionsBloc>().add(LoadMissions());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is MissionsLoaded) {
            if (state.missions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.explore_off,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No missions available',
                      style: context.textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.bitcoinOrange,
              onRefresh: () async {
                context.read<MissionsBloc>().add(LoadMissions());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.missions.length,
                itemBuilder: (context, index) {
                  final mission = state.missions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MissionCard(
                      mission: mission,
                      onTap: () {
                        context.read<MissionsBloc>().add(
                          SelectMission(mission.id),
                        );
                        _showMissionDetail(context, mission);
                      },
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showMissionDetail(BuildContext context, mission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.gray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: mission.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        mission.icon,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: context.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${mission.levels.length} levels • ${mission.xpReward} XP',
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                mission.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Levels',
                style: context.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: mission.levels.length,
                  itemBuilder: (context, index) {
                    final level = mission.levels[index];
                    return _buildLevelTile(context, level, index, mission);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelTile(BuildContext context, level, int index, mission) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: level.completed
              ? AppColors.success.withOpacity(0.2)
              : AppColors.grayLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: level.completed
              ? const Icon(Icons.check, color: AppColors.success)
              : Text(
                  '${index + 1}',
                  style: context.textTheme.titleMedium,
                ),
        ),
      ),
      title: Text(level.title),
      subtitle: Text('${level.xpReward} XP'),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {
        Navigator.pop(context);
        // Navigate to level detail
      },
    );
  }
}
