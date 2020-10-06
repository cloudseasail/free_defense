import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/scheduler.dart';
import 'package:mindcraft/base/game_component.dart';

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
      GameComponent firstObject = intrestedObjects.firstWhere(
          (o) => (this.position.distance(o.position) <= range),
          orElse: () => null);
      if (onSensed != null && firstObject != null) {
        onSensed(firstObject as T);
      }
    }
  }

  // void update(double t) {}
  // void render(Canvas c) {}
}
