import 'dart:math';

import 'package:flame/components.dart';
import '../base/game_component.dart';
import '../game/game_setting.dart';
import '../weapon/bullet_component.dart';
import '../weapon/weapon_component.dart';

class MachineGun extends WeaponComponent {
  static final WeaponSetting setting =
      GameSetting().weapons.weapon[WeaponType.mg.index];
  MachineGun({
    required Vector2 position,
  }) : super(position: position, size: setting.size) {
    size = setting.size;
    weaponType = WeaponType.mg;
    range = setting.range;
    fireInterval = setting.fireInterval;
    sprite = setting.tower;
    barrel.sprite = setting.barrel[0];
    barrel.size = size;
    barrel.rotateSpeed = setting.rotateSpeed;
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
