import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/mission.dart';
import '../../data/repositories/mission_repository_impl.dart';

// Events
abstract class MissionsEvent extends Equatable {
  const MissionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadMissions extends MissionsEvent {}

class SelectMission extends MissionsEvent {
  final String missionId;

  const SelectMission(this.missionId);

  @override
  List<Object?> get props => [missionId];
}

class SelectLevel extends MissionsEvent {
  final String levelId;

  const SelectLevel(this.levelId);

  @override
  List<Object?> get props => [levelId];
}

class CompleteLevel extends MissionsEvent {
  final String missionId;
  final String levelId;

  const CompleteLevel(this.missionId, this.levelId);

  @override
  List<Object?> get props => [missionId, levelId];
}

class UnlockMission extends MissionsEvent {
  final String missionId;

  const UnlockMission(this.missionId);

  @override
  List<Object?> get props => [missionId];
}

// States
abstract class MissionsState extends Equatable {
  const MissionsState();

  @override
  List<Object?> get props => [];
}

class MissionsInitial extends MissionsState {}

class MissionsLoading extends MissionsState {}

class MissionsLoaded extends MissionsState {
  final List<Mission> missions;
  final Mission? selectedMission;
  final Level? selectedLevel;

  const MissionsLoaded({
    required this.missions,
    this.selectedMission,
    this.selectedLevel,
  });

  @override
  List<Object?> get props => [missions, selectedMission, selectedLevel];

  MissionsLoaded copyWith({
    List<Mission>? missions,
    Mission? selectedMission,
    Level? selectedLevel,
    bool clearSelection = false,
  }) {
    return MissionsLoaded(
      missions: missions ?? this.missions,
      selectedMission: clearSelection ? null : (selectedMission ?? this.selectedMission),
      selectedLevel: clearSelection ? null : (selectedLevel ?? this.selectedLevel),
    );
  }
}

class MissionsError extends MissionsState {
  final String message;

  const MissionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class MissionsBloc extends Bloc<MissionsEvent, MissionsState> {
  final MissionRepositoryImpl _repository;

  MissionsBloc({required MissionRepositoryImpl repository})
      : _repository = repository,
        super(MissionsInitial()) {
    on<LoadMissions>(_onLoadMissions);
    on<SelectMission>(_onSelectMission);
    on<SelectLevel>(_onSelectLevel);
    on<CompleteLevel>(_onCompleteLevel);
    on<UnlockMission>(_onUnlockMission);
  }

  Future<void> _onLoadMissions(
    LoadMissions event,
    Emitter<MissionsState> emit,
  ) async {
    emit(MissionsLoading());
    try {
      final missions = await _repository.loadMissions();
      emit(MissionsLoaded(missions: missions));
    } catch (e) {
      emit(MissionsError(e.toString()));
    }
  }

  Future<void> _onSelectMission(
    SelectMission event,
    Emitter<MissionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MissionsLoaded) {
      final mission = await _repository.getMission(event.missionId);
      emit(currentState.copyWith(selectedMission: mission));
    }
  }

  void _onSelectLevel(
    SelectLevel event,
    Emitter<MissionsState> emit,
  ) {
    final currentState = state;
    if (currentState is MissionsLoaded && currentState.selectedMission != null) {
      final level = currentState.selectedMission!.levels.firstWhere(
        (l) => l.id == event.levelId,
        orElse: () => currentState.selectedMission!.levels.first,
      );
      emit(currentState.copyWith(selectedLevel: level));
    }
  }

  Future<void> _onCompleteLevel(
    CompleteLevel event,
    Emitter<MissionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MissionsLoaded) {
      try {
        final updatedMission = await _repository.completeLevel(
          event.missionId,
          event.levelId,
        );
        
        final updatedMissions = currentState.missions.map((m) {
          if (m.id == event.missionId) return updatedMission;
          return m;
        }).toList();
        
        emit(currentState.copyWith(
          missions: updatedMissions,
          selectedMission: updatedMission,
        ));
      } catch (e) {
        emit(MissionsError(e.toString()));
      }
    }
  }

  Future<void> _onUnlockMission(
    UnlockMission event,
    Emitter<MissionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is MissionsLoaded) {
      try {
        final updatedMission = await _repository.unlockMission(event.missionId);
        
        final updatedMissions = currentState.missions.map((m) {
          if (m.id == event.missionId) return updatedMission;
          return m;
        }).toList();
        
        emit(currentState.copyWith(missions: updatedMissions));
      } catch (e) {
        emit(MissionsError(e.toString()));
      }
    }
  }
}
