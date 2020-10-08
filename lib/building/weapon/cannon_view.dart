import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/smart_rotation_effect.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/building/weapon/weapon_component.dart';

class BarrelView extends GameComponent {
  Sprite barrelSprite;
  CannonView cannonView;

  BarrelView(this.cannonView)
      : super(initPosition: cannonView.position, size: cannonView.size) {
    barrelSprite = loadedImage('cannon/Cannon.png');
  }

  @override
  void render(Canvas c) {
    super.render(c);
    barrelSprite.renderRect(c, area, overridePaint: cannonView.overridePaint);
  }

  void rotateTo(double radians, Function onComplete) {
    clearEffects();
    addEffect(SmartRotatorEffect(
        toAngle: radians,
        speed: 8.0,
        curve: Curves.easeOut,
        onComplete: onComplete));
  }
}

class CannonView extends WeaponComponent {
  Sprite towerSprite;
  BarrelView barrelView;
  Paint overridePaint;

  CannonView({
    Position initPosition,
    Size size,
    double life = 100,
  }) : super(initPosition: initPosition, size: size, life: life) {
    barrelView = BarrelView(this);
    towerSprite = loadedImage('cannon/Tower.png');
  }

  void setPreview(bool p) {
    double opacity = p ? 0.3 : 1.0;
    overridePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(opacity);
  }
  /*donot add angle in tower*/
  // get angle => barrelView.angle;

  @override
  void update(double t) {
    super.update(t);
    barrelView.update(t);
  }

  void render(Canvas c) {
    c.save();
    super.render(c);
    towerSprite.renderRect(c, area, overridePaint: overridePaint);
    c.restore();
    barrelView.render(c);
  }

  void rotateTo(double radians, Function onComplete) =>
      barrelView.rotateTo(radians, onComplete);
}
