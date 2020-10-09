import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';

class GameSetting {
  Size mapScale = Size(9, 15);
  Size mapSize;
  Size cannonScale = Size(0.9, 0.9);
  Size cannonSize;
  double cannonLife = 100;
  double cannonRangeScale = 3;
  double cannonRange;
  double cannonFireInterval = 0.4; //s

  Size cannonBulletScale = Size(0.1, 0.18);
  Size cannonBulletSize;
  double cannonBulletSpeed = 400;
  double cannonBulletDamage = 10;

  Size enemySizeCale = Size(0.5, 0.5);
  Size enemySize;
  Position enemySpawn;
  Position enemyTarget;
  double enemySpeed = 80;

  Size screenSize;
  Size tileSize;

  Position statusBarPosition;
  Size statusBarSize;

  Size dotMultiple(Size x, Size y) {
    return Size(x.width * y.width, x.height * y.height);
  }

  void setScreenSize(Size size) {
    screenSize = size;
    statusBarSize = Size(screenSize.width, screenSize.height / mapScale.height);
    tileSize = Size(screenSize.width / mapScale.width,
        (screenSize.height - statusBarSize.height) / mapScale.height);

    mapSize = dotMultiple(mapScale, tileSize);
    cannonSize = dotMultiple(cannonScale, tileSize);
    cannonBulletSize = dotMultiple(cannonBulletScale, tileSize);
    enemySize = dotMultiple(enemySizeCale, tileSize);

    cannonRange = cannonRangeScale * (tileSize.width + tileSize.height) / 2;

    enemySpawn = Position(0, 0) + Position.fromSize(tileSize / 2);
    enemyTarget = Position.fromSize(mapSize) - Position.fromSize(tileSize / 2);

    statusBarPosition = Position(
        screenSize.width / 2, (screenSize.height + mapSize.height) / 2);

    print('screenSize $screenSize,  tileSize $tileSize');
  }
}
