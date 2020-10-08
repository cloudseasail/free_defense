import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/base/moving_component.dart';
import 'package:freedefense/bullet/explosion.dart';

class CannonBulletView extends GameComponent with MovingComponent {
  Sprite bulletSprite;
  bool visible = false;

  CannonBulletView({@required Position initPosition, Size size, double angle})
      : super(initPosition: initPosition, size: size) {
    bulletSprite = loadedImage('cannon/Bullet_Cannon.png');
    this.angle = angle;
    this.speed = 500;
  }

  int priority() => 110;

  void show() {
    visible = true;
  }

  void addExplosion() {
    double expSize = (size.width + size.height) * 3;
    Explosion exp =
        Explosion(initPosition: position, size: Size(expSize, expSize));
    exp.registerToGame(gameRef);
  }

  void render(Canvas c) {
    if (!bulletSprite.loaded()) return;
    if (visible) {
      super.render(c);
      bulletSprite.renderRect(c, area);
    }
  }

  @override
  void update(double t) {
    super.update(t);
    moveUpdate(t);
  }
}
