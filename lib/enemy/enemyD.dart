import 'dart:ui';

import 'package:freedefense/enemy/enemyV1.dart';
import 'package:freedefense/enemy/enemy_component.dart';
import 'package:flame/position.dart';

class EnemyD extends EnemyComponent with EnemyV1 {
  EnemyD({
    Position initPosition,
    Size size,
    double life = 100,
  }) : super(initPosition: initPosition, size: size, life: life) {
    this.life = life;
    this.maxLife = life;
    initSpriteSheet('enemy/enemyD.png');
  }
  @override
  void initialize() {
    setLiveAnimation();
    life = 300;
    speed = 40;
    size = size * 1.5;
  }
}
