import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/enemy/enemy_component.dart';

import '../base/game_component.dart';
import '../enemy/enemyA.dart';
import '../enemy/enemyB.dart';
import '../enemy/enemyC.dart';
import '../enemy/enemyD.dart';

class EnemySpawner extends GameComponent {
  int currentWave = 0;
  int _spwanCount = 0;
  double _interval = 1;
  EnemySpawner() : super(initPosition: Position(0, 0), size: Size(0, 0));

  void initialize() {}

  void start() => nextWave();

  void nextWave() {
    currentWave++;
    gameRef.statusBar.setWaveStatus(currentWave);
    switch (currentWave) {
      case 1:
        spawnEnemy(20, 1.2, spawnEnemyA);
        break;
      case 2:
        spawnEnemy(30, 0.8, spawnEnemyB);
        break;
      case 3:
        spawnEnemy(15, 2, spawnEnemyC);
        break;
      case 4:
        spawnEnemy(10, 1.5, spawnEnemyD);
        break;
      default:
        spawnEnemy(10, 2, spawnEnemyMix);
        break;
    }
  }

  void spawnEnemy(int number, double interval, Function spawnF) {
    _spwanCount = number;
    _interval = interval;
    spawnEnemyLoop(spawnF);
  }

  void spawnEnemyLoop(Function spawnF) {
    if (_spwanCount <= 0) {
      gameRef.util.timer(_interval, repeat: false, callback: nextWave).start();
    } else {
      spawnF();
      gameRef.util
          .timer(_interval,
              repeat: false, callback: () => spawnEnemyLoop(spawnF))
          .start();
      _spwanCount--;
    }
  }

  void spawnEnemyA() => spawnOneEnemy<EnemyA>();
  void spawnEnemyB() => spawnOneEnemy<EnemyB>();
  void spawnEnemyC() => spawnOneEnemy<EnemyC>();
  void spawnEnemyD() => spawnOneEnemy<EnemyD>();
  void spawnEnemyMix() {
    math.Random rnd = math.Random();
    int r = rnd.nextInt(4);
    switch (r) {
      case 0:
        return spawnEnemyA();
        break;
      case 1:
        return spawnEnemyB();
        break;
      case 2:
        return spawnEnemyC();
        break;
      case 3:
        return spawnEnemyD();
        break;
    }
  }

  Map enemyModel = {
    EnemyA: (p, s) => EnemyA(initPosition: p, size: s),
    EnemyB: (p, s) => EnemyB(initPosition: p, size: s),
    EnemyC: (p, s) => EnemyC(initPosition: p, size: s),
    EnemyD: (p, s) => EnemyD(initPosition: p, size: s),
  };

  EnemyComponent spawnOneEnemy<T extends EnemyComponent>() {
    EnemyComponent enemy;
    Position initPosition = gameRef.setting.enemySpawn;
    Size size = gameRef.setting.enemySize;
    enemy = enemyModel[T](initPosition, size);
    enemy.registerToGame(gameRef);
    rescaleEnemy(enemy);
    enemy.moveToWithPath(gameRef.setting.enemyTarget);
    return enemy;
  }

  void rescaleEnemy(EnemyComponent enemy) {
    num exp = (currentWave - 1);
    enemy.life *= math.pow(1.1, exp);
  }
}
