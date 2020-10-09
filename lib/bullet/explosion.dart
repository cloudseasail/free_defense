import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:freedefense/base/game_component.dart';

class Explosion extends GameComponent {
  SpriteSheet spriteSheet;
  Explosion({
    Position initPosition,
    Size size,
  }) : super(initPosition: initPosition, size: size);

  @override
  void initialize() {
    Image boom = loadedImage('cannon/boom3.png').image;
    const columns = 8;
    const rows = 8;
    spriteSheet = SpriteSheet(
      rows: rows,
      columns: columns,
      imageName: 'cannon/boom3.png',
      textureWidth: boom.width ~/ columns,
      textureHeight: boom.height ~/ rows,
    );
    final sprites = List<Sprite>.generate(
      columns,
      (i) => spriteSheet.getSprite(i % rows, i ~/ columns),
    );
    const double step_time = 0.05;
    animation = Animation.spriteList(sprites, stepTime: step_time, loop: false);
    gameRef.util.timer(step_time * (columns + 1), callback: remove).start();
  }
}
