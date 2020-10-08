import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/time.dart';

import '../base/game_component.dart';
import '../enemy/enemyA.dart';

class EnemySpawner extends GameComponent {
  Timer spawnTimer;
  EnemySpawner() : super(initPosition: Position(0, 0), size: Size(0, 0)) {
    spawnTimer = Timer(5, repeat: true, callback: spawn);
    spawnTimer.start();
  }
  void spawn() {
    EnemyA enemy = EnemyA(
        initPosition: Position(0, 0),
        size: gameRef.setting.enemySize,
        life: 100);
    enemy.registerToGame(gameRef);
    enemy.moveToWithPath(gameRef.setting.enemyTarget);
  }

  @override
  void update(double t) {
    super.update(t);
    spawnTimer.update(t);
  }
}
