import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:mindcraft/base/flame_game.dart';
import 'package:mindcraft/base/game_component.dart';
import 'package:mindcraft/game/game_controller.dart';
import 'package:mindcraft/game/game_setting.dart';
import 'package:mindcraft/game/game_view.dart';
import 'package:mindcraft/map/easy_map.dart';
import 'package:mindcraft/map/map_tile_component.dart';

class GameMain extends FlameGame {
  EasyMap easyMap;
  Canvas canvas;

  GameView view = GameView();
  GameSetting setting = GameSetting();
  GameController controller = GameController();

  bool recordFps() => true;

  GameMain() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    easyMap = EasyMap(
        tileSize: setting.tileSize,
        mapScale: setting.mapScale,
        mapSize: setting.mapSize);
    easyMap.registerToGame(this);
    controller.registerToGame(this);
  }

  void resize(Size size) {
    setting.setScreenSize(size);
    super.resize(size);
  }

  @override
  void update(double t) {
    // TODO: implement update
    super.update(t);
    if (recordFps()) {
      double _fps = fps();
      print('GameMain FPS $_fps');
    }
    // Iterable<GameComponent> test = components
    //     .where((o) => o is! MapTileComponent)
    //     .where((o) => o is! EasyMap);
    // print(test.length);
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);
    this.canvas = canvas;
  }

  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
  }
}
