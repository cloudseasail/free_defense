import 'dart:math';

import 'package:flame/animation.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:freedefense/enemy/enemy_component.dart';

mixin EnemyV1 on EnemyComponent {
  SpriteSheet spriteSheet;

  void initSpriteSheet(var path) {
    spriteSheet = SpriteSheet(
      imageName: path,
      textureWidth: 60,
      textureHeight: 50,
      columns: 2,
      rows: 3,
    );
  }

  void moveTo(Position to, [Function onFinish]) {
    super.moveTo(to, onFinish);
    /*fix angle */
    angle = angle - (pi / 2);
  }

  void onKilled() {
    gameRef.controller.onEnemyKilled();
    setDeadAnimation();
    gameRef.util.timer(0.4, repeat: false, callback: remove).start();
  }

  void setLiveAnimation() {
    List<Sprite> sprites = [];
    sprites.add(spriteSheet.getSprite(0, 0));
    sprites.add(spriteSheet.getSprite(0, 1));
    animation = Animation.spriteList(sprites, stepTime: 0.4, loop: true);
  }

  void setDeadAnimation() {
    List<Sprite> sprites = [];
    sprites.add(spriteSheet.getSprite(0, 0));
    sprites.add(spriteSheet.getSprite(1, 0));
    sprites.add(spriteSheet.getSprite(2, 0));
    animation = Animation.spriteList(sprites, stepTime: 0.1, loop: false);
  }
}
