import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/game/game_controller.dart';

enum MapTileBuildStatus { Empty, BuildPreview, BuildDone }
enum MapTileBuildEvent { None, BuildPreview, BuildDone, BuildCancel }

class MapTileComponent extends GameComponent with Tappable {
  MapTileBuildStatus buildStatus = MapTileBuildStatus.Empty;
  GameComponent? refComponent;
  bool ableToBuild = true;
  Sprite? background;

  MapTileComponent({
    Vector2? position,
    Vector2? size,
  }) : super(
          position: position,
          size: size,
        );

  void render(Canvas c) {
    super.render(c);
    // if (background != null) {
    // background!.renderRect(c, size.toRect());
    c.drawRect(
        size.toRect(),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.green);
  }

  @override
  bool onTapDown(TapDownInfo event) {
    gameRef.gameController.send(this, GameControl.WEAPON_BUILDING);
    return false;
  }
}
