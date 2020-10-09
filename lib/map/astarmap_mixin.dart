import 'dart:ui';

import 'package:flame/position.dart';
import 'package:freedefense/astar/astarmap.dart';
import 'package:freedefense/astar/astarnode.dart';

mixin AstarMapMixin {
  AstarMap astarMap;
  Size tileSize;

  void astarMapInit(Size size) {
    astarMap = AstarMap(size.width.toInt(), size.height.toInt());
  }

  void astarMapAddObstacle(Position position) {
    AstarNode node = _positionToNode(position);
    astarMap.addObstacle(node.x, node.y);
  }

  void astarMapRemoveObstacle(Position position) {
    AstarNode node = _positionToNode(position);
    astarMap.removeObstacle(node.x, node.y);
  }

  AstarNode astarMapResolve(Position start, Position end) {
    AstarNode _start = _positionToNode(start);
    AstarNode _end = _positionToNode(end);
    AstarNode goal = astarMap.astar(_start, _end);
    AstarNode node = goal;
    if (goal == null) return null;

    while (node.parent != null) {
      node.parent.next = node;
      node = node.parent;
    }
    return node;
  }

  Position astarMapResolveNextPosition(Position start, Position end) {
    AstarNode node = astarMapResolve(start, end);
    return node != null ? nodeToPosition(node.next) : null;
  }

  AstarNode _positionToNode(Position position) {
    return AstarNode(
        position.x ~/ tileSize.width, position.y ~/ tileSize.height);
  }

  // leftTop position
  Position nodeToPosition(AstarNode node) {
    return Position(node.x * tileSize.width, node.y * tileSize.height);
  }
}
