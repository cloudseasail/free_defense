import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/time.dart';
import 'package:flutter/gestures.dart';
import 'package:freedefense/base/flame_game.dart';
import 'package:freedefense/base/object_sensor.dart';
import 'package:freedefense/building/weapon/cannon_view.dart';
import 'package:freedefense/bullet/cannon_bullet.dart';
import 'package:freedefense/enemy/enemy_component.dart';

class Cannon extends CannonView {
  bool _preview = true;
  ObjectSensor sensor;
  double range;
  double fireInterval;
  Timer sensorTimer;

  Cannon({
    Position initPosition,
    Size size,
    this.range,
    this.fireInterval,
    double life = 100,
  }) : super(initPosition: initPosition, size: size, life: life) {
    preview = true;
    addSensor();
  }

  set preview(bool p) => setPreview(p);
  get preview => _preview;
  get activate => !_preview;
  void setPreview(bool p) {
    _preview = p;
    super.setPreview(p);
    // (p == true)
    //     ? registerGestureEvent(GestureType.TapDown)
    //     : deregisterGestureEvent(GestureType.TapDown);
    if (p == false) {
      sensor.active = true;
    }
  }

  @override
  void update(double t) {
    super.update(t);
    sensorTimer.update(t);
  }

  void addSensor() {
    void onSenseEnemy(EnemyComponent enemy) {
      fire(enemy.position);
      sensor.active = false;
      sensorTimer.start();
    }

    /* add range later because cannot access gameRef here */
    sensor = ObjectSensor<EnemyComponent>(
        initPosition = position, size = size, range = range, onSenseEnemy);
    sensorTimer = Timer(fireInterval, callback: () => sensor.active = true);
  }

  void remove() {
    super.remove();
    sensor.remove();
  }

  void registerToGame(FlameGame game, {bool later = false}) {
    super.registerToGame(game, later: later);
    sensor.registerToGame(game, later: later);
  }

  double absoluteRadiansFromPosition(Position target) {
    double radians = acos((-target.y + position.y) / position.distance(target));
    if (target.x < position.x) {
      radians = pi * 2 - radians;
    }
    return radians;
  }

  void fire(Position target) {
    double radians = absoluteRadiansFromPosition(target);
    CannonBullet bullet = fireBullet(target, radians);
    rotateTo(radians, () => bullet.show());
  }

  CannonBullet fireBullet(Position target, double angle) {
    Size bulletSize = gameRef.setting.cannonBulletSize;
    CannonBullet bullet = CannonBullet(
        initPosition: position,
        size: bulletSize,
        angle: angle,
        range: range,
        damage: gameRef.setting.cannonBulletDamage);
    bullet.registerToGame(gameRef, later: true);
    bullet.moveTo(target);
    return bullet;
  }

  void onTapDown(TapDownDetails details) {}
}
