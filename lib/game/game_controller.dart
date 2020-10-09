import 'dart:ui';

import 'package:flame/position.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/building/weapon/cannon.dart';
import 'package:freedefense/base/object_sensor.dart';
import 'package:freedefense/enemy/enemy_component.dart';

import '../enemy/enemy_component.dart';

class GameController extends GameComponent {
  GameController() : super(initPosition: Position(0, 0), size: Size(0, 0));

  Iterable<GameComponent> visableComponents = List();
  Iterable<GameComponent> enemies = List();
  Iterable<GameComponent> sensors = List();
  Iterable<GameComponent> bullets = List();

  bool _mapComponentUpdate = false;

  Cannon buildCannon(Position p) {
    Cannon cannon = Cannon(
      initPosition: p,
      size: gameRef.setting.cannonSize,
      range: gameRef.setting.cannonRange,
      fireInterval: gameRef.setting.cannonFireInterval,
      life: gameRef.setting.cannonLife,
    );
    cannon.registerToGame(gameRef, later: true);
    return cannon;
  }

  void activateCannon(Cannon cannon) {
    cannon.preview = false;
  }

  void deactiveCannon(Cannon cannon) {
    cannon.preview = true;
  }

  void destroyCannon(Cannon cannon) {
    cannon.remove();
  }

  void mapComponentUpdate() {
    _mapComponentUpdate = true;
  }

  void onEnemyKilled() {
    gameRef.statusBar.killedEnemey++;
  }

  void onEnemyMissed() {
    gameRef.statusBar.missedEnemey++;
  }

  @override
  void update(double t) {
    super.update(t);
    updateComponentList();

    /*ObjectSensor */
    sensors.forEach((element) {
      (element as ObjectSensor).scan(visableComponents);
    });

    /*Opt, when map component updated, reschdule the enimies move path */
    if (_mapComponentUpdate) {
      enemies.forEach((element) => (element as EnemyComponent)
          .moveToWithPath(gameRef.setting.enemyTarget));
      _mapComponentUpdate = false;
    }

    /*check enmeiy enter target. TODO: to optimize this with enemy sensor*/
    enemies
        .where((element) =>
            element.area.contains(gameRef.setting.enemyTarget.toOffset()))
        .forEach((element) => (element as EnemyComponent).reachTarget());
  }

  void updateComponentList() {
    visableComponents = gameRef.components.where((element) {
      return (element is GameComponent) && (element).isVisibleInCamera();
    }).cast();

    enemies = visableComponents
        .where(
            (element) => (element is EnemyComponent) && element.dead == false)
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
}
