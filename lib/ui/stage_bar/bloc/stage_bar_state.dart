part of 'stage_bar_bloc.dart';

class StageBarState extends Equatable {
  final int killed;
  final int missed;
  final int wave;
  final int minerals;

  const StageBarState._({
    this.killed = 0,
    this.missed = 0,
    this.wave = 0,
    this.minerals = 0,
  });

  StageBarState setKilled(int killed) => _copyWith(killed: killed);
  StageBarState setMissed(int missed) => _copyWith(missed: missed);
  StageBarState setWave(int wave) => _copyWith(wave: wave);
  StageBarState setMinerals(int minerals) => _copyWith(minerals: minerals);
  const StageBarState.reset() : this._();

  StageBarState _copyWith({
    int? killed,
    int? missed,
    int? wave,
    int? minerals,
  }) {
    return StageBarState._(
      killed: killed ?? this.killed,
      missed: missed ?? this.missed,
      wave: wave ?? this.wave,
      minerals: minerals ?? this.minerals,
    );
  }

  @override
  List<Object> get props => [killed, missed, wave, minerals];
}
