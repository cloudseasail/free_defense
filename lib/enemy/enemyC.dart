import 'dart:ui';

import 'package:freedefense/enemy/enemyV1.dart';
import 'package:freedefense/enemy/enemy_component.dart';
import 'package:flame/position.dart';

class EnemyC extends EnemyComponent with EnemyV1 {
  EnemyC({
    Position initPosition,
    Size size,
    double life = 100,
  }) : super(initPosition: initPosition, size: size, life: life) {
    this.life = life;
    this.maxLife = life;
    initSpriteSheet('enemy/enemyC.png');
  }
  @override
  void initialize() {
    setLiveAnimation();
    life = 80;
    speed = 100;
    size = size * 1.1;
  }
}
