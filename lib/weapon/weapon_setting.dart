import 'dart:convert';
import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import '../game/game_setting.dart';

class WeaponSetting {
  String label = "";
  int cost = 0;
  late Vector2 size;
  late Vector2 bulletSize;
  double damage = 0;
  double range = 0;
  double fireInterval = 0;
  double rotateSpeed = pi * 2;

  /*r per sec */
  double bulletSpeed = 0;

  /* d per sec */

  double damageDelta = 0;
  double rangeDelta = 0;
  double fireIntervalDelta = 0;
  double rotateSpeedDelta = 0;
  double bulletSpeedDelta = 0;

  double currentDamage = 0;
  double currentBulletSpeed = 0;

  late final Sprite tower;
  late final List<Sprite?> barrel = List.filled(3, null);
  late final List<String?> paths = List.filled(3, null);
  late final Sprite bullet;
  late final SpriteSheet explosion;
  late final Vector2 explosionSize;
  late final List<Sprite> explosionSprites;

  WeaponSetting.empty() {}

  fill(gameSetting, weaponParam, tileSize, weaponTower, images) async {
    label = weaponParam['label'];
    cost = weaponParam['cost'];
    range = weaponParam['range'] * tileSize;
    damage = weaponParam['damage'];
    currentDamage = damage;
    fireInterval = weaponParam['fireInterval'];
    rotateSpeed = pi * weaponParam['rotateSpeed'];
    bulletSpeed = tileSize * weaponParam['bulletSpeed'];
    currentBulletSpeed = bulletSpeed;
    size = gameSetting.scaleOnMapTile(Vector2(weaponParam['sizeX'], weaponParam['sizeY']));
    bulletSize = gameSetting.scaleOnMapTile(Vector2(weaponParam['bulletSizeX'], weaponParam['bulletSizeY']));
    explosionSize = gameSetting.scaleOnMapTile(Vector2(weaponParam['explosionSizeX'], weaponParam['explosionSizeY']));
    tower = weaponTower;
    paths[0] = 'weapon/${weaponParam['barrelImg0']}.png';
    paths[1] = 'weapon/${weaponParam['barrelImg1']}.png';
    paths[2] = 'weapon/${weaponParam['barrelImg2']}.png';
    barrel[0] = Sprite(await images.load(paths[0]));
    barrel[1] = Sprite(await images.load(paths[1]));
    barrel[2] = Sprite(await images.load(paths[2]));
    bullet = Sprite(await images.load('weapon/${weaponParam['bulletImg']}.png'));

    damageDelta = weaponParam['damageDelta'];
    rangeDelta = weaponParam['rangeDelta'];
    fireIntervalDelta = weaponParam['fireIntervalDelta'];
    rotateSpeedDelta = weaponParam['rotateSpeedDelta'];
    bulletSpeedDelta = weaponParam['bulletSpeedDelta'];
  }

  void createExpolosionAnimation(List<Vector2> frameLocation, double stepTime) {
    List<Sprite> sprites = [];
    frameLocation.forEach((v) => sprites.add(explosion.getSprite(v.x.toInt(), v.y.toInt())));
    explosionSprites = sprites;
    // explosionAnimation =
    //     SpriteAnimation.spriteList(sprites, stepTime: stepTime, loop: false);
  }
}

class WeaponSettingV1 {
  List<WeaponSetting> weapon = [];

  WeaponSettingV1();

  Future<void> load(gameSetting) async {
    final images = Images();
    Sprite weaponTower = Sprite(await images.load('weapon/Tower.png'));
    double tileSize = gameSetting.mapTileSize.length;

    String weaponParamsString = await loadAsset('assets/weaponParams.json');
    final weaponParams = json.decode(weaponParamsString);

    // Preloading these fixes issue with GameBar not showing Missile_Launcher barrel
    for (var weaponParam in weaponParams) {
      await images.load('weapon/${weaponParam['barrelImg0']}.png');
    }

    for (var weaponParam in weaponParams) {
      List<Vector2> expFrame = [];
      List<dynamic> vector2List = weaponParam['expFrame'];
      for (int i = 0; i < vector2List.length; i++) {
        List<dynamic> vector2 = vector2List[i];
        expFrame.add(Vector2(vector2[0], vector2[1]));
      }

      WeaponSetting w = WeaponSetting.empty()
        ..explosion = SpriteSheet.fromColumnsAndRows(
          image: await images.load(weaponParam['explosionImage']),
          columns: weaponParam['columns'],
          rows: weaponParam['rows'],
        );
      w.fill(gameSetting, weaponParam, tileSize, weaponTower, images);

      double explosionTimeStep = weaponParam['explosionTimeStep'];
      w.createExpolosionAnimation(expFrame, explosionTimeStep);
      weapon.add(w);
    }
  }
}
