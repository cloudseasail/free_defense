import 'dart:math';

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;

import 'package:flame/sprite.dart';

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

  Vector2 mapGrid = Vector2(12, 12);
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
    print('optimizeMapGrid size $size');
    double grid = math.min(mapGrid.x, mapGrid.y);
    Vector2 optSize = size / grid;
    grid = math.min(optSize.x, optSize.y);

    /*Bar at top*/
    barPosition = Vector2(size.x / 2, grid / 2);
    barSize = Vector2(size.x, grid);
    viewPosition = Vector2(size.x / 2, size.y - (grid / 2));
    viewSize = Vector2(size.x, grid);
    /*Map in the middle*/
    mapPosition = Vector2(size.x / 2, size.y / 2);
    mapSize = Vector2(size.x - 2, size.y - (grid * 2) - 2);
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

  void createExpolosionAnimation(List<Vector2> frameLocation, double stepTime) {
    List<Sprite> sprites = [];
    frameLocation.forEach(
        (v) => sprites.add(explosion.getSprite(v.x.toInt(), v.y.toInt())));
    explosionSprites = sprites;
    // explosionAnimation =
    //     SpriteAnimation.spriteList(sprites, stepTime: stepTime, loop: false);
  }
}

class WeaponSettingV1 {
  List<WeaponSetting> weapon = [];
  WeaponSettingV1();
  Future<void> load() async {
    final images = Images();
    Sprite weaponTower = Sprite(await images.load('weapon/Tower.png'));
    double tileSize = gameSetting.mapTileSize.length;
    List<Vector2> expFrame = [];

    WeaponSetting w = WeaponSetting()
      ..cost = 10
      ..range = 1.5 * tileSize
      ..damage = 30
      ..fireInterval = 0.8
      ..rotateSpeed = pi * 2
      ..bulletSpeed = tileSize * 2
      ..size = gameSetting.scaleOnMapTile(Vector2(0.8, 0.8))
      ..bulletSize = gameSetting.scaleOnMapTile(Vector2(0.1, 0.2))
      ..explosionSize = gameSetting.scaleOnMapTile(Vector2(0.8, 0.8))
      ..tower = weaponTower
      ..barrel[0] = Sprite(await images.load('weapon/Cannon.png'))
      ..barrel[1] = Sprite(await images.load('weapon/Cannon2.png'))
      ..barrel[2] = Sprite(await images.load('weapon/Cannon3.png'))
      ..bullet = Sprite(await images.load('weapon/Bullet1.png'))
      ..explosion = SpriteSheet.fromColumnsAndRows(
        image: await images.load('weapon/explosion1.png'),
        columns: 8,
        rows: 8,
      );
    expFrame = [];
    expFrame = List<Vector2>.generate(8, (i) => Vector2(i % 8, 4));
    w.createExpolosionAnimation(expFrame, 1.5);
    weapon.add(w);

    w = WeaponSetting()
      ..cost = 15
      ..range = 2 * tileSize
      ..damage = 10
      ..fireInterval = 0.2
      ..rotateSpeed = pi * 4
      ..bulletSpeed = tileSize * 5
      ..size = gameSetting.scaleOnMapTile(Vector2(0.8, 0.8))
      ..bulletSize = gameSetting.scaleOnMapTile(Vector2(0.1, 0.3))
      ..explosionSize = gameSetting.scaleOnMapTile(Vector2(0.5, 0.5))
      ..tower = weaponTower
      ..barrel[0] = Sprite(await images.load('weapon/MG.png'))
      ..barrel[1] = Sprite(await images.load('weapon/MG2.png'))
      ..barrel[2] = Sprite(await images.load('weapon/MG3.png'))
      ..bullet = Sprite(await images.load('weapon/Bullet2.png'))
      ..explosion = SpriteSheet.fromColumnsAndRows(
        image: await images.load('weapon/explosion2.png'),
        columns: 6,
        rows: 1,
      );
    expFrame = [];
    expFrame = List<Vector2>.generate(6, (i) => Vector2(0, i % 6));
    w.createExpolosionAnimation(expFrame, 0.05);
    weapon.add(w);

    w = WeaponSetting()
      ..cost = 30
      ..range = 3 * tileSize
      ..damage = 100
      ..fireInterval = 1.5
      ..rotateSpeed = pi * 1
      ..bulletSpeed = tileSize * 0.7
      ..size = gameSetting.scaleOnMapTile(Vector2(0.9, 0.9))
      ..bulletSize = gameSetting.scaleOnMapTile(Vector2(0.3, 0.4))
      ..explosionSize = gameSetting.scaleOnMapTile(Vector2(0.7, 0.7))
      ..tower = weaponTower
      ..barrel[0] = Sprite(await images.load('weapon/Missile_Launcher.png'))
      ..barrel[1] = Sprite(await images.load('weapon/Missile_Launcher2.png'))
      ..barrel[2] = Sprite(await images.load('weapon/Missile_Launcher3.png'))
      ..bullet = Sprite(await images.load('weapon/Missile.png'))
      ..explosion = SpriteSheet.fromColumnsAndRows(
        image: await images.load('weapon/explosion3.png'),
        columns: 5,
        rows: 3,
      );
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
