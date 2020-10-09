import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';
import 'package:freedefense/astar/astarnode.dart';
import 'package:freedefense/base/game_component.dart';

import '../base/moving_component.dart';

class EnemyComponent extends GameComponent with MovingComponent {
  double life;
  double maxLife;
  double speed;
  bool dead = false;

  EnemyComponent({
    Position initPosition,
    Size size,
    this.life = 100,
  }) : super(initPosition: initPosition, size: size) {
    maxLife = life;
  }

  void setType(String name) {}

  bool scanable() => !dead;

  @override
  void update(double t) {
    super.update(t);

    if (life < 0) {
      if (!dead) onKilled();
      dead = true;
    }

    if (!dead) {
      moveUpdate(t);
    }
  }

  void receiveDamage(double damage) {
    life -= damage;
  }

  void reachTarget() {
    if (!dead) {
      gameRef.controller.onEnemyMissed();
      this.remove();
    }
  }

  void onKilled() {
    gameRef.controller.onEnemyKilled();
    this.remove();
  }

  // void moveTo(Position to, [Function onFinish]) => pathMoveTo(to);

  /*Enemy move path controller */
  AstarNode pathNode;
  void moveToWithPath(Position to) {
    pathNode = gameRef.easyMap.astarMapResolve(position, to);
    if (pathNode != null) {
      pathNextMove();
    }
  }

  void pathNextMove() {
    if (pathNode != null) {
      pathNode = pathNode.next;
      if (pathNode != null) {
        moveTo(pathRadomPosition(pathNode), pathNextMove);
      }
    }
  }

  Position pathRadomPosition(AstarNode node) {
    Position lefttop = gameRef.easyMap.nodeToPosition(node);
    Offset randomArea = Offset(gameRef.easyMap.tileSize.width - this.size.width,
        gameRef.easyMap.tileSize.height - this.size.height);
    lefttop = lefttop + Position(this.size.width / 2, this.size.height / 2);
    double rndx = Random().nextDouble();
    double rndy = Random().nextDouble();
    return lefttop +
        Position.fromOffset(Offset(randomArea.dx * rndx, randomArea.dy * rndy));
  }
}
