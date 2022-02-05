import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../base/game_component.dart';

import '../game/game_setting.dart';
import '../game_controller/game_controller.dart';
import '../map/map_controller.dart';
import '../ui/stage_bar/bloc/stage_bar_bloc.dart';

class GameMain extends FlameBlocGame with HasTappables {
  late MapController mapController;
  // late WeaponFactoryView weaponFactory;
  GameController gameController;
  // late GamebarView gamebarView;
  bool started = false;

  bool loadDone = false;

  // GameView view = GameView();
  GameSetting setting = GameSetting();
  // GameController controller = GameController();
  // EnemySpawner enemySpawner = EnemySpawner();
  // StatusBar statusBar;
  // GameUtil util;

  GameMain({required this.gameController});

  @override
  void onGameResize(Vector2 size) {
    if (!loadDone) setting.setScreenSize(size);
    super.onGameResize(size);
  }

  int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> onLoad() async {
    int timeRecord = currentTimeMillis();
    await super.onLoad();

    // await setting.onLoad();
    await setting.neutual.load();

    mapController = MapController(
        tileSize: setting.mapTileSize,
        mapGrid: setting.mapGrid,
        position: setting.mapPosition,
        size: setting.mapSize);
    /*game controller should have same range as map */
    gameController = gameController
      ..position = setting.mapPosition
      ..size = setting.mapSize;

    // gamebarView = GamebarView();
    // weaponFactory = WeaponFactoryView();

    await setting.weapons.load();

    add(mapController);
    add(gameController);
    // add(gamebarView);
    // add(weaponFactory);
    // await add(interface ?? GameInterface());
    setting.enemies.load();

    loadDone = true;
    int d = currentTimeMillis() - timeRecord;
    print("GameMain onLoad done takke $d");
    pauseEngine();
  }

  @override
  void update(double t) {
    super.update(t);
    // if (recordFps()) {
    //   double _fps = fps();
    //   int len = components.length;
    //   print('GameMain FPS $_fps, components $len');
    // }
    // Iterable<Component> test = components
    //     .where((o) => o is! MapTileComponent)
    //     .where((o) => o is!  0x7d2b523304a0) (first time)
    // print(test.length);
  }

  void start() {
    if (loadDone) {
      gameController.send(GameComponent(), GameControl.enemySpawn);
      read<StageBarBloc>().add(const SbSetKilled(0));
      read<StageBarBloc>().add(const SbSetMissed(0));
      read<StageBarBloc>().add(const SbSetMinerals(400));
    }
  }
}
