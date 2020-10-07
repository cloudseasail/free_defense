import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:freedefense/bullet/cannon_bullet.dart';
import 'package:freedefense/building/weapon/cannon.dart';
import 'package:freedefense/enemy/enemyA.dart';
import 'package:freedefense/game/game_main.dart';

class GameTest extends GameMain {
  Cannon cannon;
  void initialize() {
    super.initialize();
  }

  // bool debugMode() => true;
  bool recordFps() => false;

  void test2() {
    CannonBullet bullet = CannonBullet(
        initPosition: Position(100, 100), size: Size(10, 10), angle: 3.14);
    bullet.speed = 500;
    add(bullet);
    bullet.moveFromTo(Position(100, 100), Position(200, 300));
  }

  void test3(Offset p) {
    EnemyA enemy = EnemyA(
        initPosition: Position.fromOffset(p),
        size: setting.enemySize,
        life: 20);
    addLater(enemy);
  }

  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    // test4();
  }

  void onLongPressStart(LongPressStartDetails details) {
    test3(details.globalPosition);
  }
}
