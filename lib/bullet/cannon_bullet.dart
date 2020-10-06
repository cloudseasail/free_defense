import 'dart:math';

import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:mindcraft/base/flame_game.dart';
import 'package:mindcraft/base/object_sensor.dart';
import 'package:mindcraft/bullet/cannon_bullet_view.dart';
import 'package:mindcraft/enemy/enemy_component.dart';

class CannonBullet extends CannonBulletView {
  ObjectSensor sensor;
  double range;
  double damage;
  CannonBullet(
      {@required Position initPosition,
      Size size,
      double angle,
      this.range,
      this.damage})
      : super(initPosition: initPosition, size: size, angle: angle) {
    addSensor();

    // TODO: remove after out of range
  }

  set position(Position p) {
    super.position = p;
    sensor?.position = p;
  }

  void remove() {
    super.remove();
    sensor.remove();
  }

  void moveFinish() => outOfRange();

  void outOfRange() {
    remove();
  }

  void registerToGame(FlameGame game, {bool later = false}) {
    super.registerToGame(game, later: later);
    sensor.registerToGame(game, later: later);
  }

  void addSensor() {
    void onSensed(EnemyComponent enemy) {
      sensor.active = false;
      enemy.receiveDamage(damage);
      this.remove();
    }

    sensor = ObjectSensor<EnemyComponent>(initPosition = position, size = size,
        range = max(size.width, size.height), onSensed);
    sensor.active = true;
  }
}
