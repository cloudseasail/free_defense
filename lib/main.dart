import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freedefense/game/game_main.dart';

// import 'package:freedefense/game/game_main.dart';
import 'package:freedefense/game/game_test.dart';
import 'package:freedefense/view/weaponview_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setOrientation(DeviceOrientation.portraitUp);

  GameTest game = GameTest();

  runApp(
    GameWidget<GameMain>(
      game: game,
      overlayBuilderMap: {
        "${WeaponViewWidget.name}-0": WeaponViewWidget.builder,
        "${WeaponViewWidget.name}-1": WeaponViewWidget.builder,
        'start': _pauseMenuBuilder,
        'gameover': _gameOverBuilder,
      },
      initialActiveOverlays: const ['start'],
    ),
  );
}

Widget _pauseMenuBuilder(BuildContext buildContext, GameMain game) {
  return Center(
      child: Container(
    width: 100,
    height: 100,
    color: Colors.orange,
    child: Center(
        child: TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, padding: const EdgeInsets.all(16.0),
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        game.start();
        game.overlays.remove('start');
      },
      child: const Text('Start'),
    )),
  ));
}

Widget _gameOverBuilder(BuildContext buildContext, GameMain game) {
  return Center(
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
        child: Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                game.overlays.remove('gameover');
              },
              child: const Text('Game Over'),
            )),
      ));
}

void test() {}
