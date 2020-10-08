import 'dart:ui';

import 'package:flame/position.dart';
import 'package:freedefense/base/game_component.dart';

import 'game_component.dart';

class ObjectSensor<T extends GameComponent> extends GameComponent {
  bool _active = false;
  Function onSensed;
  double range;
  // double range;
  ObjectSensor(Position initPosition, Size size, this.range, this.onSensed)
      : super(initPosition: initPosition, size: size) {
    active = false;
  }

  int priority() => 200;

  set active(bool a) => (_active = a);
  get active => _active;

  void scan(Iterable<GameComponent> objects) {
    if (active) {
      Iterable<GameComponent> intrestedObjects =
          objects.where((element) => element is T);
      GameComponent firstObject = intrestedObjects
          .firstWhere((o) => collisionDetect(o), orElse: () => null);
      if (onSensed != null && firstObject != null) {
        onSensed(firstObject as T);
      }
    }
  }

  /*target size/2 */
  bool collisionDetect(GameComponent o) {
    Size collisionSize = o.size / 4.0;
    double collisionDistance =
        (collisionSize.width + collisionSize.height) / 2.0;
    return this.position.distance(o.position) <= (range + collisionDistance);
  }

  // void update(double t) {}
  // void render(Canvas c) {}
}
