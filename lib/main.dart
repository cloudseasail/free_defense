// import 'package:flame/flame.dart';
import 'package:flame/flame.dart';
import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/game_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // BoxGame game = BoxGame();
  // GameView game = GameView();

  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  GameTest game = GameTest();

  Flame.images.loadAll(<String>[
    'cannon/Tower.png',
    'cannon/Cannon.png',
    'cannon/Bullet_Cannon.png',
    'enemy/enemyA.png',
    'cannon/boom3.png',
    'blackhole.png',
    'whitehole.png',
  ]);
  runApp(game.widget);
}
