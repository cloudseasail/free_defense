import 'dart:math';

import 'package:flame/components.dart';
import '../base/game_component.dart';
import '../game/game_setting.dart';
import '../weapon/bullet_component.dart';
import '../weapon/weapon_component.dart';

class Cannon extends WeaponComponent {
  static final WeaponSetting setting =
      GameSetting().weapons.weapon[WeaponType.cannon.index];
  Cannon({
    required Vector2 position,
  }) : super(position: position, size: setting.size) {
    this.size = setting.size;
    this.weaponType = WeaponType.cannon;
    this.range = setting.range;
    this.fireInterval = setting.fireInterval;
    this.sprite = setting.tower;
    this.barrel.sprite = setting.barrel[0];
    this.barrel.size = size;
    this.barrel.rotateSpeed = setting.rotateSpeed;
  }

  @override
  void fireBullet(Vector2 target) {
    BulletComponent bullet =
        BulletComponent(position: _bulletPosition(), size: setting.bulletSize)
          ..angle = barrel.angle
          ..damage = setting.damage
          ..sprite = setting.bullet
          ..speed = setting.bulletSpeed
          ..onExplosion = bulletExplosion;
    bullet.moveTo(target);
    parent?.add(bullet);
  }

  Vector2 _bulletPosition() {
    // double bulletR = (setting.bulletSize.x + setting.bulletSize.y) / 4;
    double r = radius /*+ bulletR*/;
    Vector2 localPosition =
        Vector2(r * sin(barrel.angle), -r * cos(barrel.angle));
    localPosition += (size / 2);
    return positionOf(localPosition);
  }

  void bulletExplosion(GameComponent enemy) {
    enemy.add(ExplosionComponent(
        position: enemy.size / 2, size: setting.explosionSize)
      ..animation = SpriteAnimation.spriteList(setting.explosionSprites,
          stepTime: 0.06, loop: false));
  }
}
