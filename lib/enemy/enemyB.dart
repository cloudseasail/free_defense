import 'dart:ui';

import 'package:freedefense/enemy/enemyV1.dart';
import 'package:freedefense/enemy/enemy_component.dart';
import 'package:flame/position.dart';

class EnemyB extends EnemyComponent with EnemyV1 {
  EnemyB({
    Position initPosition,
    Size size,
    double life = 100,
  }) : super(initPosition: initPosition, size: size, life: life) {
    this.life = life;
    this.maxLife = life;
    initSpriteSheet('enemy/enemyB.png');
  }
  @override
  void initialize() {
    setLiveAnimation();
    life = 150;
    speed = 60;
    size = size * 1.0;
  }
}
