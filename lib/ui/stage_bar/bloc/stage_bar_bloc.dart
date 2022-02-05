import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../ui/inventory/bloc/inventory_bloc.dart';

part 'stage_bar_state.dart';
part 'stage_bar_event.dart';

class StageBarBloc extends Bloc<StageBarEvent, StageBarState> {
  final InventoryBloc _bloc;
  StageBarBloc({required InventoryBloc bloc})
      : _bloc = bloc,
        super(const StageBarState.reset()) {
    on<SbSetKilled>(_onSetKilled);
    on<SbAddKilled>(_onAddKilled);
    on<SbSetMissed>(_onSetMissed);
    on<SbAddMissed>(_onAddMissed);
    on<SbSetWave>(_onSetWave);
    on<SbAddWave>(_onAddWave);
    on<SbSetMinerals>(_onSetMinerals);
    on<SbAddMinerals>(_onAddMinerals);
    on<SbSubtractMinerals>(_onSubtractMinerals);
    on<SbReset>(_onReset);
  }

  void _onSetKilled(SbSetKilled event, Emitter<StageBarState> emit) =>
      emit(state.setKilled(event.killed));

  void _onAddKilled(SbAddKilled event, Emitter<StageBarState> emit) =>
      emit(state.setKilled(event.killed + state.killed));

  void _onSetMissed(SbSetMissed event, Emitter<StageBarState> emit) =>
      emit(state.setMissed(event.missed));

  void _onAddMissed(SbAddMissed event, Emitter<StageBarState> emit) =>
      emit(state.setMissed(event.missed + state.missed));

  void _onSetWave(SbSetWave event, Emitter<StageBarState> emit) =>
      emit(state.setWave(event.wave));

  void _onAddWave(SbAddWave event, Emitter<StageBarState> emit) =>
      emit(state.setWave(event.wave + state.wave));

  void _onSetMinerals(SbSetMinerals event, Emitter<StageBarState> emit) =>
      emit(state.setMinerals(event.minerals));

  void _onAddMinerals(SbAddMinerals event, Emitter<StageBarState> emit) {
    emit(state.setMinerals(event.minerals + state.minerals));
  }

  void _onSubtractMinerals(
      SbSubtractMinerals event, Emitter<StageBarState> emit) {
    final int cost = _bloc.state.weaponCost[event.indexWeaponCost];
    int minerals = state.minerals - cost;
    minerals = minerals < 0 ? 0 : minerals;
    emit(state.setMinerals(minerals));
  }

  void _onReset(SbReset event, Emitter<StageBarState> emit) =>
      emit(const StageBarState.reset());

  @override
  Future<void> close() {
    return super.close();
  }
}
