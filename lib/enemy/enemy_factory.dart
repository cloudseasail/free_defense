import 'package:flame/components.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/enemy/enemy_component.dart';
import 'package:freedefense/enemy/enmey_v1.dart';
import 'dart:math' as math;

import 'package:freedefense/game/game_controller.dart';

class EnemyFactory extends GameComponent {
  EnemyFactory() : super(position: Vector2.zero(), size: Vector2.zero()) {
    active = false;
  }

  EnemyComponent spawnEnemey(Vector2 anchor, EnemyType type) {
    late EnemyComponent enemy;
    enemy = EnemyV1(position: anchor, type: type);

    return enemy;
  }

  EnemyComponent spawnOneEnemy(EnemyType type) {
    EnemyComponent enemy;
    Vector2 initPosition = gameRef.gameController.gateStart.position;
    enemy = spawnEnemey(initPosition, type);
    gameRef.gameController.add(enemy);
    enpowerEnemy(enemy);
    enemy.moveSmart(gameRef.gameController.gateEnd.position);
    return enemy;
  }

  int currentWave = 0;
  int _spwanCount = 0;
  double _interval = 1;
  bool gameOver = false;

  void start() {
    gameOver = false;
    nextWave();
  }

  void stop() {
    gameOver = true;
  }

  void nextWave() {
    currentWave++;
    if (!gameOver) {
      gameRef.gameController.send(this, GameControl.ENEMY_NEXT_WAVE);
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
  }

  void spawnEnemy(int number, double interval, Function spawnF) {
    _spwanCount = number;
    _interval = interval;
    spawnEnemyLoop(spawnF);
  }

  void spawnEnemyLoop(Function spawnF) {
    if (_spwanCount <= 0) {
      add(TimerComponent(
          period: _interval,
          repeat: false,
          removeOnFinish: true,
          onTick: () => nextWave()));
    } else {
      spawnF();
      add(TimerComponent(
          period: _interval,
          repeat: false,
          removeOnFinish: true,
          onTick: () => spawnEnemyLoop(spawnF)));
      _spwanCount--;
    }
  }

  void spawnEnemyA() => spawnOneEnemy(EnemyType.ENEMYA);
  void spawnEnemyB() => spawnOneEnemy(EnemyType.ENEMYB);
  void spawnEnemyC() => spawnOneEnemy(EnemyType.ENEMYC);
  void spawnEnemyD() => spawnOneEnemy(EnemyType.ENEMYD);
  void spawnEnemyMix() {
    math.Random rnd = math.Random();
    int r = rnd.nextInt(4);
    spawnOneEnemy(EnemyType.values[r]);
  }

  void enpowerEnemy(EnemyComponent enemy) {
    num exp = (currentWave - 1);
    enemy.maxLife *= math.pow(1.1, exp);
  }
}
