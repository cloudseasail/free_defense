import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/game/game_util.dart';

import 'game_component.dart';

class ObjectSensor<T extends GameComponent> extends GameComponent {
  bool _active = false;
  Function onSensed;
  double range;
  TimerComponent cdTimer;
  // double range;
  ObjectSensor(Position initPosition, Size size, this.range, this.onSensed)
      : super(initPosition: initPosition, size: size) {
    active = false;
  }

  int priority() => 200;

  set active(bool a) {
    _active = a;
    if (cdTimer != null) {
      cdTimer.stop();
      cdTimer = null;
    }
  }

  get active => _active;

  void scan(Iterable<GameComponent> objects) {
    bool scanable(GameComponent element) {
      bool rt = false;
      if (element is T) {
        rt = true;
        if (element.scanable != null) {
          rt = element.scanable();
        }
      }
      return rt;
    }

    if (active) {
      Iterable<GameComponent> intrestedObjects =
          objects.where((element) => scanable(element));
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

  void coolDown(double time) {
    active = false;
    cdTimer = gameRef.util.timer(time, callback: () => active = true).start();
  }
}
