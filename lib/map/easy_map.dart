import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/astar/astarnode.dart';
import 'package:freedefense/base/game_component.dart';

import 'astarmap_mixin.dart';
import 'map_tile_component.dart';

class EasyMap extends GameComponent with AstarMapMixin {
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
    registerGestureEvent(GestureType.LongPress);
  }

  @override
  void initialize() {
    initBackground();
    astarMapInit(mapScale);
  }

  void initBackground() {
    tileComponents
        .firstWhere((element) =>
            element.area.contains(gameRef.setting.enemySpawn.toOffset()))
        .background = Sprite('whitehole.png');
    tileComponents
        .firstWhere((element) =>
            element.area.contains(gameRef.setting.enemyTarget.toOffset()))
        .background = Sprite('blackhole.png');
  }

  void render(Canvas c) {
    tileComponents.forEach((e) => e.render(c));
  }

  @override
  void update(double t) {
    super.update(t);
  }

  void onTapDown(TapDownDetails details) {
    buildProcess(details.globalPosition);
  }

  void onLongPressStart(LongPressStartDetails details) {
    destroyProcess(details.globalPosition);
  }

  void buildProcess(Offset p) {
    bool build = false;
    for (MapTileComponent tile in tileComponents) {
      if (tile.area.contains(p)) {
        build = true;
      } else {
        build = false;
      }
      MapTileBuildEvent e = tile.buildProcess(build, gameRef.controller);
      handleBuildEvent(tile, e);
    }
  }

  void destroyProcess(Offset p) {
    bool destroy = false;
    for (MapTileComponent tile in tileComponents) {
      if (tile.area.contains(p)) {
        destroy = true;
      } else {
        destroy = false;
      }
      MapTileBuildEvent e = tile.destroyProcess(destroy, gameRef.controller);
      handleBuildEvent(tile, e);
    }
  }

  void handleBuildEvent(MapTileComponent tile, MapTileBuildEvent e) {
    if (e == MapTileBuildEvent.BuildDone) {
      astarMapAddObstacle(tile.position);
      gameRef.controller.mapComponentUpdate();
    }
    if (e == MapTileBuildEvent.BuildPreview) {
      if (_testOverlap(tile) || _testMapBlocking(tile)) {
        tile.ableToBuild = false;
      }
    }

    if (e == MapTileBuildEvent.BuildCancel) {
      tile.ableToBuild = true;
    }
  }

  bool _testOverlap(tile) {
    var enemies = gameRef.controller.enemies;
    var overlapEnemies =
        enemies.where((element) => element.area.overlaps(tile.area));
    return overlapEnemies.length > 0 ? true : false;
  }

  bool _testMapBlocking(tile) {
    astarMapAddObstacle(tile.position);
    AstarNode goal = astarMapResolve(
        gameRef.setting.enemySpawn, gameRef.setting.enemyTarget);
    astarMapRemoveObstacle(tile.position);
    return goal == null ? true : false;
  }
}
