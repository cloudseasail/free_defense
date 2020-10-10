import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:freedefense/bullet/cannon_bullet.dart';
import 'package:freedefense/building/weapon/cannon.dart';
import 'package:freedefense/enemy/enemyA.dart';
import 'package:freedefense/game/game_main.dart';
import 'package:freedefense/game/game_util.dart';
import 'package:freedefense/map/map_tile_component.dart';

class GameTest extends GameMain {
  Cannon cannon;
  void initialize() {
    super.initialize();
  }

  // bool debugMode() => true;
  bool recordFps() => true;

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

  @override
  void update(double t) {
    super.update(t);
    debug(t);
  }

  void debug(double t) {
    if (debugMode()) {
      double _fps = fps();
      print('GameMain FPS $_fps');

      var total = components.length;
      var timers =
          components.where((element) => element is TimerComponent).length;
      var tiles = components.where((element) => element is MapTileComponent);
      var cannons = components.where((element) => element is Cannon).length;
      var enemies = controller.enemies.length;
      var sensors = controller.sensors.length;
      var bullets = controller.bullets.length;

      print(
          'total components $total, timers $timers, tiles $tiles, cannons $cannons, enemies $enemies, sensors $sensors, bullets $bullets');
    }
  }
}
