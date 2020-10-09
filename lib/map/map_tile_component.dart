import 'dart:ui';

import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/building/weapon/cannon.dart';
import 'package:freedefense/game/game_controller.dart';

enum MapTileBuildStatus { Empty, BuildPreview, BuildDone }
enum MapTileBuildEvent { None, BuildPreview, BuildDone, BuildCancel }

class MapTileComponent extends GameComponent {
  MapTileBuildStatus buildStatus = MapTileBuildStatus.Empty;
  GameComponent refComponent;
  bool ableToBuild = true;
  Sprite background;

  MapTileComponent({Position initPosition, Size size})
      : super(initPosition: initPosition, size: size);

  MapTileBuildEvent buildProcess(bool build, GameController controller) {
    MapTileBuildEvent event = MapTileBuildEvent.None;
    if (build) {
      if (buildStatus == MapTileBuildStatus.Empty) {
        refComponent = controller.buildCannon(position.clone());
        buildStatus = MapTileBuildStatus.BuildPreview;
        event = MapTileBuildEvent.BuildPreview;
      } else if (buildStatus == MapTileBuildStatus.BuildPreview) {
        if (ableToBuild) {
          controller.activateCannon(refComponent as Cannon);
          buildStatus = MapTileBuildStatus.BuildDone;
          event = MapTileBuildEvent.BuildDone;
        }
      }
    } else {
      if (buildStatus == MapTileBuildStatus.BuildPreview) {
        controller.destroyCannon(refComponent as Cannon);
        refComponent = null;
        buildStatus = MapTileBuildStatus.Empty;
        event = MapTileBuildEvent.BuildCancel;
      }
    }
    return event;
  }

  MapTileBuildEvent destroyProcess(bool destroy, GameController controller) {
    MapTileBuildEvent event = MapTileBuildEvent.None;
    if (destroy) {
      if (buildStatus == MapTileBuildStatus.BuildDone) {
        controller.deactiveCannon(refComponent as Cannon);
        buildStatus = MapTileBuildStatus.BuildPreview;
        event = MapTileBuildEvent.BuildPreview;
      }
    } else {
      if (buildStatus == MapTileBuildStatus.BuildPreview) {
        controller.destroyCannon(refComponent as Cannon);
        refComponent = null;
        buildStatus = MapTileBuildStatus.Empty;
        event = MapTileBuildEvent.BuildCancel;
      }
    }
    return event;
  }

  void render(Canvas c) {
    if (background != null) {
      background.renderRect(c, area);
    }
    if (buildStatus == MapTileBuildStatus.BuildPreview) {
      Color color = ableToBuild ? Colors.green[200] : Colors.red[200];
      c.drawRect(this.area, Paint()..color = color.withOpacity(0.3));
    } else {
      c.drawRect(
          this.area,
          Paint()
            ..color = Colors.green[200].withOpacity(0.2)
            ..style = PaintingStyle.stroke);
    }
  }
}
