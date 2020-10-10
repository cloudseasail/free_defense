import 'dart:ui';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:freedefense/base/flame_game.dart';
import 'package:freedefense/game/game_controller.dart';
import 'package:freedefense/game/game_setting.dart';
import 'package:freedefense/game/game_util.dart';
import 'package:freedefense/game/game_view.dart';
import 'package:freedefense/game/status_bar.dart';
import 'package:freedefense/map/easy_map.dart';

import 'enemy_spawner.dart';

class GameMain extends FlameGame {
  EasyMap easyMap;
  Canvas canvas;
  bool started = false;

  GameView view = GameView();
  GameSetting setting = GameSetting();
  GameController controller = GameController();
  EnemySpawner enemySpawner = EnemySpawner();
  StatusBar statusBar;
  GameUtil util;

  bool recordFps() => true;

  GameMain() {
    initialize();
  }

  void initialize() async {
    await Flame.init(
      fullScreen: true,
      // orientation: DeviceOrientation.portraitUp,
    );

    resize(await Flame.util.initialDimensions());
    util = GameUtil(this);

    easyMap = EasyMap(
        tileSize: setting.tileSize,
        mapScale: setting.mapScale,
        mapSize: setting.mapSize);
    statusBar = StatusBar(
        initPosition: setting.statusBarPosition, size: setting.statusBarSize);

    easyMap.registerToGame(this);
    controller.registerToGame(this);
    statusBar.registerToGame(this);
    enemySpawner.registerToGame(this);
  }

  void resize(Size size) {
    setting.setScreenSize(size);
    super.resize(size);
  }

  @override
  void update(double t) {
    super.update(t);
    // if (recordFps()) {
    //   double _fps = fps();
    //   int len = components.length;
    //   print('GameMain FPS $_fps, components $len');
    // }
    // Iterable<GameComponent> test = components
    //     .where((o) => o is! MapTileComponent)
    //     .where((o) => o is!  0x7d2b523304a0) (first time)
    // print(test.length);
  }

  void onTapDown(TapDownDetails details) {
    if (!started) {
      started = true;
      statusBar.removeStartIndicator();
      enemySpawner.start();
    } else {
      super.onTapDown(details);
    }
  }

  int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  int timeRecord = 0;
  void recordTime() {
    timeRecord = currentTimeMillis();
    print('timeRecord is $timeRecord');
  }

  void timeDelay() {
    if (timeRecord > 0) {
      int d = currentTimeMillis() - timeRecord;
      print('timeDelay $d');
      timeRecord = 0;
    }
  }
}
