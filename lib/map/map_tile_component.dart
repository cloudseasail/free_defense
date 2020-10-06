import 'dart:ui';

import 'package:flame/position.dart';
import 'package:mindcraft/base/game_component.dart';
import 'package:mindcraft/building/weapon/cannon.dart';
import 'package:mindcraft/game/game_controller.dart';

enum MapTileBuildStatus { Empty, BuildPreview, BuildDone }

class MapTileComponent extends GameComponent {
  MapTileBuildStatus buildStatus = MapTileBuildStatus.Empty;
  GameComponent refComponent;
  MapTileComponent({Position initPosition, Size size})
      : super(initPosition: initPosition, size: size);

  MapTileBuildStatus buildProgress(bool build, GameController controller) {
    if (build) {
      if (buildStatus == MapTileBuildStatus.Empty) {
        refComponent = controller.buildCannon(position.clone());
        buildStatus = MapTileBuildStatus.BuildPreview;
      } else if (buildStatus == MapTileBuildStatus.BuildPreview) {
        controller.activateCannon(refComponent as Cannon);
        buildStatus = MapTileBuildStatus.BuildDone;
      }
    } else {
      if (buildStatus == MapTileBuildStatus.BuildPreview) {
        controller.destroyCannon(refComponent as Cannon);
        refComponent = null;
        buildStatus = MapTileBuildStatus.Empty;
      }
    }
    return buildStatus;
  }
}
