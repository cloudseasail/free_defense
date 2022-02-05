import 'dart:convert';
import 'dart:math';

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;

import 'package:flame/sprite.dart';
import 'package:flutter/services.dart';

GameSetting gameSetting = GameSetting();

class GameSetting {
  GameSetting._privateConstructor();

  static final GameSetting _instance = GameSetting._privateConstructor();

  factory GameSetting() {
    return _instance;
  }

  EnemySettingV1 enemies = EnemySettingV1();
  WeaponSettingV1 weapons = WeaponSettingV1();
  NeutualSetting neutual = NeutualSetting();

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

    print(
        'screenSize $screenSize,  mapGrid $mapGrid, mapTileSize $mapTileSize');
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
    mapGrid =
        Vector2(mapGrid.x.toInt().toDouble(), mapGrid.y.toInt().toDouble());
    mapTileSize = dotDivide(mapSize, mapGrid);
  }

  Future<void> onLoad() async {
    await neutual.load();
    await weapons.load();
    await enemies.load();
  }
}

class NeutualSetting {
  late Sprite mine;
  late Sprite mineCluster;
  Future<void> load() async {
    final images = Images();
    mine = Sprite(await images.load('neutual/mine.png'));
    mineCluster = Sprite(await images.load('neutual/mine_cluster.png'));
  }
}

class WeaponSetting {
  String label = "";
  int cost = 0;
  late Vector2 size;
  late Vector2 bulletSize;
  double damage = 0;
  double range = 0;
  double fireInterval = 0;
  double rotateSpeed = pi * 2; /*r per sec */
  double bulletSpeed = 0; /* d per sec */
  late final Sprite tower;
  late final List<Sprite?> barrel = List.filled(3, null);
  late final Sprite bullet;
  late final SpriteSheet explosion;
  late final Vector2 explosionSize;
  late final List<Sprite> explosionSprites;

  WeaponSetting.empty();

  fill(weaponParam, tileSize, weaponTower, images) async {
    label = weaponParam['label'];
    cost = weaponParam['cost'];
    range = weaponParam['range'] * tileSize;
    damage = weaponParam['damage'];
    fireInterval = weaponParam['fireInterval'];
    rotateSpeed = pi * weaponParam['rotateSpeed'];
    bulletSpeed = tileSize * weaponParam['bulletSpeed'];
    size = gameSetting
        .scaleOnMapTile(Vector2(weaponParam['sizeX'], weaponParam['sizeY']));
    bulletSize = gameSetting.scaleOnMapTile(
        Vector2(weaponParam['bulletSizeX'], weaponParam['bulletSizeY']));
    explosionSize = gameSetting.scaleOnMapTile(
        Vector2(weaponParam['explosionSizeX'], weaponParam['explosionSizeY']));
    tower = weaponTower;
    barrel[0] =
        Sprite(await images.load('weapon/${weaponParam['barrelImg0']}.png'));
    barrel[1] =
        Sprite(await images.load('weapon/${weaponParam['barrelImg1']}.png'));
    barrel[2] =
        Sprite(await images.load('weapon/${weaponParam['barrelImg2']}.png'));
    bullet =
        Sprite(await images.load('weapon/${weaponParam['bulletImg']}.png'));
  }

  void createExpolosionAnimation(List<Vector2> frameLocation, double stepTime) {
    List<Sprite> sprites = [];
    frameLocation.forEach(
        (v) => sprites.add(explosion.getSprite(v.x.toInt(), v.y.toInt())));
    explosionSprites = sprites;
    // explosionAnimation =
    //     SpriteAnimation.spriteList(sprites, stepTime: stepTime, loop: false);
  }
}

Future<String> loadAsset(String assetFileName) async {
  return await rootBundle.loadString(assetFileName);
}

class WeaponSettingV1 {
  List<WeaponSetting> weapon = [];
  WeaponSettingV1();
  Future<void> load() async {
    final images = Images();
    Sprite weaponTower = Sprite(await images.load('weapon/Tower.png'));
    double tileSize = gameSetting.mapTileSize.length;
    List<Vector2> expFrame = [];

    String weaponParamsString =
        await rootBundle.loadString('assets/weaponParams.json');

    final weaponParams = json.decode(weaponParamsString);

    WeaponSetting w = WeaponSetting.empty()
      ..explosion = SpriteSheet.fromColumnsAndRows(
        image: await images.load('weapon/explosion1.png'),
        columns: 8,
        rows: 8,
      );
    w.fill(weaponParams[0], tileSize, weaponTower, images);

    expFrame = [];
    expFrame = List<Vector2>.generate(8, (i) => Vector2(i % 8, 4));
    w.createExpolosionAnimation(expFrame, 1.5);
    weapon.add(w);

    w = WeaponSetting.empty()
      ..explosion = SpriteSheet.fromColumnsAndRows(
        image: await images.load('weapon/explosion2.png'),
        columns: 6,
        rows: 1,
      );
    w.fill(weaponParams[1], tileSize, weaponTower, images);

    expFrame = [];
    expFrame = List<Vector2>.generate(6, (i) => Vector2(0, i % 6));
    w.createExpolosionAnimation(expFrame, 0.05);
    weapon.add(w);

    w = WeaponSetting.empty()
      ..explosion = SpriteSheet.fromColumnsAndRows(
        image: await images.load('weapon/explosion3.png'),
        columns: 5,
        rows: 3,
      );
    w.fill(weaponParams[2], tileSize, weaponTower, images);

    expFrame = [];
    expFrame = List<Vector2>.generate(6, (i) => Vector2(i / 2, (i % 2) * 3));
    w.createExpolosionAnimation(expFrame, 0.1);
    weapon.add(w);
  }
}

class EnemySetting {
  late final double life;
  late final double speed;
  late final double scale;
  late final double enemySize;
  late final SpriteSheet spriteSheet;
  EnemySetting();
}

class EnemySettingV1 {
  List<EnemySetting> enemy = [];
  EnemySettingV1();
  final images = Images();

  Future<void> load() async {
    enemy.add(EnemySetting()
      ..life = 80
      ..speed = 50
      ..scale = 0.8
      ..spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await images.load('enemy/enemyA.png'),
        columns: 2,
        rows: 3,
      ));
    enemy.add(EnemySetting()
      ..life = 150
      ..speed = 60
      ..scale = 1.0
      ..spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await images.load('enemy/enemyB.png'),
        columns: 2,
        rows: 3,
      ));
    enemy.add(EnemySetting()
      ..life = 80
      ..speed = 100
      ..scale = 1.1
      ..spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await images.load('enemy/enemyC.png'),
        columns: 2,
        rows: 3,
      ));
    enemy.add(EnemySetting()
      ..life = 300
      ..speed = 40
      ..scale = 1.5
      ..spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: await images.load('enemy/enemyD.png'),
        columns: 2,
        rows: 3,
      ));
  }
}
