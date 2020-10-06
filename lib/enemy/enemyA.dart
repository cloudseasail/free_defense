import 'dart:ui';
import 'package:flame/spritesheet.dart';
import 'package:mindcraft/base/game_component.dart';
import 'package:mindcraft/enemy/enemy_component.dart';
import 'package:flame/position.dart';

class EnemyA extends GameComponent with EnemyComponent {
  EnemyA({
    Position initPosition,
    Size size,
    double life,
  }) : super(initPosition: initPosition, size: size) {
    final spriteSheet = SpriteSheet(
      imageName: 'enemy/enemyA.png',
      textureWidth: 89,
      textureHeight: 58,
      columns: 4,
      rows: 1,
    );
    animation = spriteSheet.createAnimation(0, stepTime: 0.1, to: 2);
    this.life = life;
    this.maxLife = life;
  }
}
