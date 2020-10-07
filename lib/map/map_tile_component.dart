import 'dart:ui';

import 'package:flame/position.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/building/weapon/cannon.dart';
import 'package:freedefense/game/game_controller.dart';

enum MapTileBuildStatus { Empty, BuildPreview, BuildDone }
enum MapTileBuildEvent { None, BuildPreview, BuildDone, BuildCancel }

class MapTileComponent extends GameComponent {
  MapTileBuildStatus buildStatus = MapTileBuildStatus.Empty;
  GameComponent refComponent;
  MapTileComponent({Position initPosition, Size size})
      : super(initPosition: initPosition, size: size);

  MapTileBuildEvent buildProgress(bool build, GameController controller) {
    MapTileBuildEvent event = MapTileBuildEvent.None;
    if (build) {
      if (buildStatus == MapTileBuildStatus.Empty) {
        refComponent = controller.buildCannon(position.clone());
        buildStatus = MapTileBuildStatus.BuildPreview;
        event = MapTileBuildEvent.BuildPreview;
      } else if (buildStatus == MapTileBuildStatus.BuildPreview) {
        controller.activateCannon(refComponent as Cannon);
        buildStatus = MapTileBuildStatus.BuildDone;
        event = MapTileBuildEvent.BuildDone;
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
}
