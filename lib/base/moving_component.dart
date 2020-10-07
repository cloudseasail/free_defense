import 'package:flame/position.dart';
import 'package:freedefense/base/game_component.dart';
import 'dart:math';

mixin MovingComponent on GameComponent {
  double speed;
  Function onMoveFinish;
  bool _finish = true;
  // final Curve curve = Curves.linear;
  // double get progress => curve.transform(progress);

  Position _direction;
  double _totalLength;
  double _movedLength;

  // MovingComponent({@required Position initPosition, Size size})
  //     : super(initPosition: initPosition, size: size);

  double absoluteRadiansFromPosition(Position target) {
    double radians = acos((-target.y + position.y) / position.distance(target));
    if (target.x < position.x) {
      radians = pi * 2 - radians;
    }
    return radians;
  }

  void moveTo(Position to, [Function onFinish]) {
    moveFromTo(position, to, onFinish);
  }

  void moveFromTo(Position from, Position to, [Function onFinish]) {
    // position = from;
    double dx = to.x - from.x;
    double dy = to.y - from.y;
    double dl = sqrt(pow(dx, 2) + pow(dy, 2));
    _totalLength = dl;
    _direction = Position(dx / dl, dy / dl);
    _movedLength = 0;
    _finish = false;
    onMoveFinish = onFinish;
    angle = absoluteRadiansFromPosition(to);
  }

  void moveUpdate(double t) {
    // super.update(t);
    if (!_finish) {
      /*finish on the next tick,  to make sure the position is able to be sensored*/
      if (_movedLength > _totalLength) {
        moveFinish();
      }
      double _delta = t * speed;
      double dx = _delta * _direction.x;
      double dy = _delta * _direction.y;
      //overwirte position to make sure it update area.
      position = position.add(Position(dx, dy));
      //OPT: check only after time expire, to avoid pow cacl in very tick
      _movedLength += sqrt(pow(dx, 2) + pow(dy, 2));
    }
  }

  void moveFinish() {
    _finish = true;
    onMoveFinish?.call();
  }
}
