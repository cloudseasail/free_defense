import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:mindcraft/base/game_component.dart';

import 'map_tile_component.dart';

class EasyMap extends GameComponent {
  Size tileSize;
  Size mapScale;
  Size mapSize;
  List<MapTileComponent> tileComponents = [];

  int priority() => 0;

  EasyMap({this.tileSize, this.mapScale, this.mapSize})
      : super(initPosition: Position.fromSize(mapSize / 2), size: mapSize) {
    for (var w = 0; w < mapScale.width; w++) {
      for (var h = 0; h < mapScale.height; h++) {
        tileComponents.add(MapTileComponent(
            initPosition: Position(w * tileSize.width, h * tileSize.height)
                .add(Position(tileSize.width / 2, tileSize.height / 2)),
            size: tileSize));
      }
    }
    registerGestureEvent(GestureType.TapDown);
  }
  void render(Canvas c) {
    for (MapTileComponent tile in tileComponents) {
      c.drawRect(
          tile.area,
          Paint()
            ..color = Colors.green[200]
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  void update(double t) {
    super.update(t);
  }

  void onTapDown(TapDownDetails details) {
    print(details.globalPosition);
    buildProcess(details.globalPosition);
  }

  void buildProcess(Offset p) {
    bool build = false;
    for (MapTileComponent tile in tileComponents) {
      if (tile.area.contains(p)) {
        build = true;
      } else {
        build = false;
      }
      tile.buildProgress(build, gameRef.controller);
    }
  }
}
