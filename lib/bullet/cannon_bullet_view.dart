import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/base/moving_component.dart';

class CannonBulletView extends GameComponent with MovingComponent {
  Sprite bulletSprite;
  bool visible = false;

  CannonBulletView({@required Position initPosition, Size size, double angle})
      : super(initPosition: initPosition, size: size) {
    bulletSprite = Sprite('cannon/Bullet_Cannon.png');
    this.angle = angle;
    this.speed = 500;
  }

  int priority() => 110;

  void show() {
    visible = true;
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
