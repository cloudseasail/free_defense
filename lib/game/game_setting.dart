import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../enemy/enemy_setting.dart';
import '../neutral/neutral_setting.dart';
import '../weapon/weapon_setting.dart';

GameSetting gameSetting = GameSetting();

class GameSetting {
  GameSetting._privateConstructor();

  static final GameSetting _instance = GameSetting._privateConstructor();

  factory GameSetting() {
    return _instance;
  }

  EnemySettingV1 enemies = EnemySettingV1();
  WeaponSettingV1 weapons = WeaponSettingV1();
  NeutralSetting neutral = NeutralSetting();

  Vector2 mapGrid = Vector2(10, 10);
  late Vector2 mapPosition;
  late Vector2 mapSize;
  late Vector2 viewPosition;
  late Vector2 viewSize;
  late Vector2 barPosition;
  late Vector2 barSize;
  late Vector2 mapTileSize;

  double cannonBulletSpeed = 400;
  double cannonBulletDamage = 10;

  Vector2 enemySizeCale = Vector2(0.5, 0.5);
  late Vector2 enemySize;
  late Vector2 enemySpawn;
  late Vector2 enemyTarget;
  double enemySpeed = 80;

  late Vector2 screenSize;

  Vector2 dotMultiple(Vector2 x, Vector2 y) {
    return Vector2(x.x * y.x, x.y * y.y);
  }

  Vector2 dotDivide(Vector2 x, Vector2 y) {
    return Vector2(x.x / y.x, x.y / y.y);
  }

  Vector2 scaleOnMapTile(Vector2 scale) {
    return dotMultiple(mapTileSize, scale);
  }

  void setScreenSize(Vector2 size) {
    screenSize = size;
    optimizeMapGrid(size);

    enemySize = dotMultiple(enemySizeCale, mapTileSize);
    enemySpawn = Vector2(0, 0) + (mapTileSize / 2);
    enemyTarget = (mapSize) - (mapTileSize / 2);

    print('screenSize $screenSize,  mapGrid $mapGrid, mapTileSize $mapTileSize');
  }

  void optimizeMapGrid(Vector2 size) {
    mapGrid = Vector2(10, 10);
    double grid = math.min(mapGrid.x, mapGrid.y);
    Vector2 optSize = size / grid;
    grid = math.min(optSize.x, optSize.y);

    /*Bar at top*/
    barPosition = Vector2(size.x / 2, grid / 2);
    barSize = Vector2(size.x, grid);
    viewPosition = Vector2(size.x / 2, size.y - (grid / 2));
    viewSize = Vector2(size.x, grid * 1.5);
    /*Map in the middle*/
    mapPosition = Vector2(size.x / 2, size.y / 2);
    mapSize = Vector2(size.x - 2, size.y - barSize.y - viewSize.y - 2);
    mapGrid = mapSize / grid;
    mapGrid = Vector2(mapGrid.x.toInt().toDouble(), mapGrid.y.toInt().toDouble());
    mapTileSize = dotDivide(mapSize, mapGrid);
  }

  Future<void> onLoad() async {
    await neutral.load();
    await weapons.load(gameSetting);
    await enemies.load();
  }
}

Future<String> loadAsset(String assetFileName) async {
  return await rootBundle.loadString(assetFileName);
}
