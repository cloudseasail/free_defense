import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import '../base/game_ref.dart';
import '../game/game_main.dart';

class GameComponent extends PositionComponent with GameRef<GameMain>, HasPaint {
  Sprite? sprite;
  SpriteAnimation? animation;
  bool? playing = true;

  // set sprite(Sprite s) => this.sprite = s;

  GameComponent({
    Vector2? position,
    Vector2? size,
    int? priority,
  }) : super(
            position: position,
            size: size,
            priority: priority,
            anchor: Anchor.center);

  bool active = true;
  get length => (size.x + size.y) / 2;
  get radius => length / 2;
  // loadedImage(imagePath) =>
  //     Sprite.fromImage(Flame.images.loadedFiles[imagePath].loadedImage);

  @override
  void render(Canvas canvas) {
    sprite?.render(
      canvas,
      size: size,
      overridePaint: paint,
    );

    animation?.getSprite().render(
          canvas,
          size: size,
          overridePaint: paint,
        );
    super.render(canvas);
  }

  @override
  void update(double dt) {
    if ((animation != null) && playing!) {
      animation!.update(dt);
    }
    super.update(dt);
  }

  double angleNearTo(Vector2 target) {
    double distance = position.distanceTo(target);
    if (distance == 0) return 0;
    double radians = acos((-target.y + position.y) / distance);
    if (target.x < position.x) {
      radians = pi * 2 - radians;
    }
    return radians;
  }

  Vector2 positionInPrarent(Vector2 point) {
    return point + position;
  }

  Vector2 screenPosition() {
    return gameRef.camera.worldToScreen(
      position,
    );
  }
}
