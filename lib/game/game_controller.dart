import 'dart:ui';

import 'package:flame/position.dart';
import 'package:mindcraft/base/game_component.dart';
import 'package:mindcraft/building/weapon/cannon.dart';
import 'package:mindcraft/base/object_sensor.dart';
import 'package:mindcraft/enemy/enemy_component.dart';

class GameController extends GameComponent {
  GameController() : super(initPosition: Position(0, 0), size: Size(0, 0));

  Iterable<GameComponent> visableComponents = List();
  Iterable<GameComponent> enemies = List();
  Iterable<GameComponent> sensors = List();
  Iterable<GameComponent> bullets = List();

  Cannon buildCannon(Position p) {
    Cannon cannon = Cannon(
      initPosition: p,
      size: gameRef.setting.cannonSize,
      range: gameRef.setting.cannonRange,
      fireInterval: gameRef.setting.cannonFireInterval,
      life: gameRef.setting.cannonLife,
    );
    cannon.registerToGame(gameRef);
    return cannon;
  }

  void activateCannon(Cannon cannon) {
    cannon.preview = false;
  }

  void destroyCannon(Cannon cannon) {
    cannon.remove();
  }

  @override
  void update(double t) {
    super.update(t);
    updateComponentList();

    /*ObjectSensor */
    sensors.forEach((element) {
      (element as ObjectSensor).scan(visableComponents);
    });
  }

  void updateComponentList() {
    visableComponents = gameRef.components.where((element) {
      return (element is GameComponent) && (element).isVisibleInCamera();
    }).cast();

    enemies = visableComponents
        .where((element) => (element is EnemyComponent))
        .cast();

    sensors =
        visableComponents.where((element) => (element is ObjectSensor)).cast();
    bullets = visableComponents
        .where((element) => (element is EnemyComponent))
        .cast();
  }

  @override
  void remove() {
    super.remove();
  }

  @override
  bool destroy() {
    bool d = super.destroy();
    if (d) {
      print(d);
    }
    return d;
  }
}
