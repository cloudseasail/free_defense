part of 'stage_bar_bloc.dart';

abstract class StageBarEvent extends Equatable {
  const StageBarEvent();
  @override
  List<Object> get props => [];
}

class SbSetKilled extends StageBarEvent {
  const SbSetKilled(this.killed);
  final int killed;
}

class SbAddKilled extends StageBarEvent {
  const SbAddKilled(this.killed);
  final int killed;
}

class SbSetMissed extends StageBarEvent {
  const SbSetMissed(this.missed);
  final int missed;
}

class SbAddMissed extends StageBarEvent {
  const SbAddMissed(this.missed);
  final int missed;
}

class SbSetWave extends StageBarEvent {
  const SbSetWave(this.wave);
  final int wave;
}

class SbAddWave extends StageBarEvent {
  const SbAddWave(this.wave);
  final int wave;
}

class SbSetMinerals extends StageBarEvent {
  const SbSetMinerals(this.minerals);
  final int minerals;
}

class SbAddMinerals extends StageBarEvent {
  const SbAddMinerals(this.minerals);
  final int minerals;
}

class SbSubtractMinerals extends StageBarEvent {
  const SbSubtractMinerals(this.indexWeaponCost);
  final int indexWeaponCost;
}

class SbReset extends StageBarEvent {}
