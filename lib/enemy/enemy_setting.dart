import 'dart:convert';

import 'package:flame/cache.dart';
import 'package:flame/sprite.dart';

import '../game/game_setting.dart';

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
    String enemyParamsString = await loadAsset('assets/enemyParams.json');
    final enemyParams = json.decode(enemyParamsString);
    print("EnemySettingV1 enemyParams = ${enemyParams}");

    for (var enemyParam in enemyParams) {
      print("EnemySettingV1 enemyParam = ${enemyParam}");

      enemy.add(EnemySetting()
        ..life = enemyParam['life'].toDouble()
        ..speed = enemyParam['speed'].toDouble()
        ..scale = enemyParam['scale'].toDouble()
        ..spriteSheet = SpriteSheet.fromColumnsAndRows(
          image: await images.load('${enemyParam['image']}'),
          columns: enemyParam['columns'],
          rows: enemyParam['rows'],
        ));
    }

    print("EnemySettingV1 = ${enemy}");
    print("EnemySettingV1 = ${enemy.length}");
  }
}
