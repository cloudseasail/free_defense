import 'dart:ui';

import 'package:flame/components.dart';
import 'package:freedefense/astar/astarnode.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/base/life_indicator.dart';
import 'package:freedefense/base/movable.dart';
import 'package:freedefense/base/scanable.dart';
import 'dart:math';

import 'package:freedefense/game/game_controller.dart';

enum EnemyType { ENEMYA, ENEMYB, ENEMYC, ENEMYD }

class EnemyComponent extends GameComponent
    with Scanable, Movable, EnemySmartMove, LifeIndicator {
  double maxLife = 0;
  double life = 0;
  bool dead = false;
  late EnemyType enemyType;
  EnemyComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, priority: 30);

  @override
  void update(double t) {
    super.update(t);

    if (life < 0) {
      if (!dead) onKilled();
      dead = true;
      active = false;
    }

    if (active) {
      updateMovable(t);
    }
  }

  @override
  void render(Canvas c) {
    super.render(c);
    renderLifIndicator(c);
  }

  @override
  void onRemove() {
    pathNode = null;
    super.onRemove();
  }

  void receiveDamage(double damage) {
    life -= damage;
  }

  void onArrived() {
    if (!dead) {
      active = false;
      gameRef.gameController.send(this, GameControl.ENEMY_MISSED);
      this.removeFromParent();
    }
  }

  void onKilled() {
    active = false;
    gameRef.gameController.send(this, GameControl.ENEMY_KILLED);
    this.removeFromParent();
  }
}

mixin EnemySmartMove on GameComponent {
  /*Enemy move path controller */
  AstarNode? pathNode;
  void moveSmart(Vector2 to) {
    pathNode = gameRef.mapController.astarMapResolve(position, to);
    if (pathNode != null) {
      pathNextMove();
    }
  }

  void pathNextMove() {
    if (pathNode != null) {
      pathNode = pathNode!.next;
      if (pathNode != null) {
        (this as Movable).moveTo(moveRadomPosition(pathNode!), pathNextMove);
      }
    }
  }

  Vector2 moveRadomPosition(AstarNode node) {
    if (node.next == null) {
      /*target goto center*/
      Vector2 lefttop = gameRef.mapController.nodeToPosition(node);
      return lefttop + (gameRef.mapController.tileSize / 2);
    } else {
      Vector2 lefttop = gameRef.mapController.nodeToPosition(node);
      Vector2 randomArea = Vector2(
          gameRef.mapController.tileSize.x - this.size.x,
          gameRef.mapController.tileSize.y - this.size.y);
      lefttop = lefttop + Vector2(this.size.x / 2, this.size.y / 2);
      double rndx = Random().nextDouble();
      double rndy = Random().nextDouble();
      return lefttop + Vector2(randomArea.x * rndx, randomArea.y * rndy);
    }
  }
}
