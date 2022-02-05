import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../base/game_component.dart';
import '../base/radar.dart';
import '../enemy/enemy_component.dart';
import '../game_controller/game_controller.dart';

class SmartRotateEffect extends RotateEffect {
  Function? onComplete;
  SmartRotateEffect.to(double angle, EffectController controller)
      : _destinationAngle = angle,
        super.by(0, controller);

  double _angle = 0;
  double _destinationAngle;

  @override
  void onStart() {
    _angle = _destinationAngle - target.angle;
    if (_angle > pi) {
      _angle = _angle - (pi * 2);
    }
    if (_angle < -pi) {
      _angle = _angle + (pi * 2);
    }
  }

  @override
  void onFinish() {
    if (target.angle < 0) {
      target.angle += (pi * 2);
    }
    if (target.angle > (pi * 2)) {
      target.angle -= (pi * 2);
    }
    onComplete?.call();
  }

  @override
  void apply(double progress) {
    final dProgress = progress - previousProgress;
    target.angle += _angle * dProgress;
    super.apply(progress);
  }
}

enum WeaponType { cannon, mg, missele, minner, none }

class BarrelComponent extends GameComponent {
  BarrelComponent({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, priority: 21);
  double rotateSpeed = 6.0; /* radians/second */
  double rotateTo(double radians, Function onComplete) {
    double duration = (radians - angle).abs() / rotateSpeed;
    if (duration <= 0) {
      onComplete.call();
      return 0;
    }
    add(
      SmartRotateEffect.to(
        radians,
        EffectController(
          duration: duration,
          curve: Curves.easeOut,
          infinite: false,
        ),
      )..onComplete = onComplete,
    );

    return duration;
  }
}

class WeaponComponent extends GameComponent
    with Tappable, Radar<EnemyComponent> {
  late WeaponType weaponType;
  late double range;
  late double fireInterval;
  late BarrelComponent barrel;

  WeaponComponent({
    required Vector2 position,
    required Vector2 size,
    double life = 100,
  }) : super(position: position, size: size, priority: 20) {
    barrel = BarrelComponent(position: size / 2, size: size);
    add(barrel);

    onBuilding();
  }

  bool blockMap = false;
  bool blockEnemy = true;
  bool buildDone = false;
  bool active = true;
  get buildAllowed => ((blockMap == false) && (blockEnemy == false));

  void fire(Vector2 target) {
    _targetEnemy = target;
    double radians = angleNearTo(target);
    double rotatePeriod = barrel.rotateTo(radians, _fireBullet);
    coolDown(rotatePeriod + fireInterval);
  }

  Vector2? _targetEnemy;

  void _fireBullet() {
    if (_targetEnemy != null) {
      fireBullet(_targetEnemy!);
    }
    _targetEnemy = null;
  }

  void fireBullet(Vector2 target) {}

  void coolDown(double period) {
    radarOn = false;
    add(TimerComponent(
        period: period,
        repeat: false,
        removeOnFinish: true,
        onTick: () => radarOn = true));
  }

  void onBuilding() {
    buildDone = false;
    radarOn = true;
    radarRange = (size.x + size.y) / 4;
    radarScanAlert = onEnemyBlock;
    radarScanNothing = onEnymyUnBlock;
    radarCollisionDepth = 0;
  }

  void onBuildDone() {
    buildDone = true;
    radarOn = true;
    radarRange = range;
    radarScanAlert = onEnemyAttack;
    radarScanNothing = null;
    radarCollisionDepth = 0;
  }

  void onEnemyBlock(GameComponent target) {
    blockEnemy = true;
  }

  void onEnymyUnBlock() {
    blockEnemy = false;
  }

  void onEnemyAttack(GameComponent target) {
    fire(target.position);
  }

  @override
  void render(Canvas canvas) {
    if (buildDone == false) {
      Color? color = buildAllowed ? Colors.green[200] : Colors.red[200];
      /*build indicator */
      canvas.drawRect(size.toRect(), Paint()..color = color!.withOpacity(0.3));
      canvas.drawCircle(
          (size / 2).toOffset(),
          range,
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.green);
    }

    super.render(canvas);
  }

  @override
  bool onTapDown(TapDownInfo event) {
    if (buildDone == false) {
      if (buildAllowed) {
        gameRef.gameController.send(this, GameControl.weaponBuildDone);
        onBuildDone();
      }
    } else {
      if (active) {
        gameRef.gameController.send(this, GameControl.weaponShowAction);
      } else {
        return true;
        // gameRef.gameController.send(this, GameControl.WEAPON_SHOW_PROFILE);
      }
    }

    return false;
  }
}
