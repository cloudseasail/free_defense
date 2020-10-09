import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/time.dart';
import 'package:freedefense/base/flame_game.dart';
import 'package:freedefense/base/game_component.dart';

class TimerComponent extends GameComponent {
  Timer _timer;
  TimerComponent(double limit, {bool repeat = false, void Function() callback})
      : super(initPosition: Position(0, 0), size: Size(0, 0)) {
    _timer = Timer(limit, repeat: repeat, callback: callback);
  }
  TimerComponent start() {
    _timer.start();
    return this;
  }

  void stop() => _timer.stop();
  void update(double t) {
    super.update(t);
    _timer.update(t);
    if (_timer.isFinished()) {
      this.remove();
    }
  }
}

class GameUtil {
  FlameGame gameRef;
  GameUtil(this.gameRef);
  TimerComponent timer(double limit,
      {bool repeat = false, void Function() callback}) {
    TimerComponent tc =
        TimerComponent(limit, repeat: repeat, callback: callback);
    gameRef.add(tc);
    return tc;
  }
}
