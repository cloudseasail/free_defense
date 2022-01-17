import 'package:flame/components.dart';
import 'package:freedefense/base/game_component.dart';
import 'dart:math';

mixin Movable on GameComponent {
  double speed = 0;
  Function? onMoveFinish;
  bool _finish = true;

  Vector2 _direction = Vector2.zero();
  double _totalLength = 0;
  double _movedLength = 0;

  @override
  void update(double dt) {
    super.update(dt);
    if (active) {
      moveUpdate(dt);
    }
  }

  @override
  void onRemove() {
    onMoveFinish = null;
    super.onRemove();
  }

  void moveTo(Vector2 to, [Function? onFinish]) {
    moveFromTo(position, to, onFinish);
  }

  void moveFromTo(Vector2 from, Vector2 to, [Function? onFinish]) {
    // Vector2 = from;
    double dx = to.x - from.x;
    double dy = to.y - from.y;
    double dl = sqrt(pow(dx, 2) + pow(dy, 2));
    _totalLength = dl;
    _direction = Vector2(dx / dl, dy / dl);
    _movedLength = 0;
    _finish = false;
    onMoveFinish = onFinish;
    angle = angleNearTo(to);
  }

  void moveUpdate(double t) {
    // super.update(t);
    if (!_finish) {
      /*finish on the next tick,  to make sure the Vector2 is able to be sensored*/
      if (_movedLength > _totalLength) {
        moveFinish();
      }
      double _delta = t * speed;
      double dx = _delta * _direction.x;
      double dy = _delta * _direction.y;
      //overwirte Vector2 to make sure it update area.
      position = position + Vector2(dx, dy);
      //OPT: check only after time expire, to avoid pow cacl in very tick
      _movedLength += sqrt(pow(dx, 2) + pow(dy, 2));
    }
  }

  void moveFinish() {
    _finish = true;
    onMoveFinish?.call();
  }
}
