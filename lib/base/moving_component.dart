import 'package:flame/position.dart';
import 'package:mindcraft/base/game_component.dart';
import 'dart:math';

mixin MovingComponent on GameComponent {
  double speed;
  Function onMoveFinish;
  bool _finish = false;
  // final Curve curve = Curves.linear;
  // double get progress => curve.transform(progress);

  Position _direction;
  double _totalLength;
  double _movedLength;

  // MovingComponent({@required Position initPosition, Size size})
  //     : super(initPosition: initPosition, size: size);

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
  }

  void update(double t) {
    super.update(t);
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
