import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../game/game_setting.dart';
import '../enemy/enemy_component.dart';

GameSetting setting = GameSetting();

class EnemyV1 extends EnemyComponent {
  late SpriteSheet spriteSheet;
  EnemyV1({required Vector2 position, required EnemyType type})
      : super(position: position, size: Vector2.zero()) {
    enemyType = type;
    EnemySetting s = setting.enemies.enemy[enemyType.index];
    maxLife = s.life;
    speed = s.speed;
    size = setting.enemySize * s.scale;
    spriteSheet = s.spriteSheet;
  }

  double initAngle = pi / 2;

  set angle(double a) {
    super.angle = a - initAngle;
  }

  @override
  Future<void>? onLoad() {
    super.onLoad();
    setLiveAnimation();
  }

  void onKilled() {
    setDeadAnimation();
    super.onKilled();
  }

  void setLiveAnimation() {
    List<Sprite> sprites = [];
    sprites.add(spriteSheet.getSprite(0, 0));
    sprites.add(spriteSheet.getSprite(0, 1));
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.4, loop: true);
  }

  void setDeadAnimation() {
    List<Sprite> sprites = [];
    sprites.add(spriteSheet.getSprite(0, 0));
    sprites.add(spriteSheet.getSprite(1, 0));
    sprites.add(spriteSheet.getSprite(2, 0));
    animation = SpriteAnimation.spriteList(sprites, stepTime: 0.1, loop: false);
  }
}
