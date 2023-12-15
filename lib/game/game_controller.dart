import 'dart:collection';
import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/base/radar.dart';
import 'package:freedefense/base/scanable.dart';
import 'package:freedefense/enemy/enemy_component.dart';
import 'package:freedefense/enemy/enemy_factory.dart';
import 'package:freedefense/game/game_setting.dart';
import 'package:freedefense/view/weapon_factory_view.dart';
import 'package:freedefense/view/weaponview_widget.dart';
import 'package:freedefense/weapon/weapon_component.dart';

import '../neutral/neutual_component.dart';

GameSetting gameSetting = GameSetting();

enum GameControl {
  WEAPON_BUILDING,
  WEAPON_SELECTED,
  /*change type */
  WEAPON_BUILD_DONE,
  WEAPON_DESTROYED,
  WEAPON_SHOW_ACTION,
  WEAPON_SHOW_PROFILE,
  ENEMY_SPAWN,
  ENEMY_MISSED,
  ENEMY_KILLED,
  ENEMY_NEXT_WAVE,
  GAME_OVER
}

class GameInstruction {
  GameControl instruction;
  GameComponent source;

  GameInstruction(this.source, this.instruction);
  void process(GameController controller) {
    switch (instruction) {
      case GameControl.WEAPON_BUILDING:
        WeaponViewWidget.hide();
        WeaponComponent? component = controller.gameRef.weaponFactory.buildWeapon(this.source.position);
        if (component != null) {
          controller.add(component);
          controller.buildingWeapon?.removeFromParent();
          controller.buildingWeapon = component;
          component.blockMap = component.collision(controller.gateStart) ||
              component.collision(controller.gateEnd) ||
              controller.gameRef.mapController.testBlock(component.position);
        }
        break;
      case GameControl.WEAPON_SELECTED:
        WeaponViewWidget.hide();
        controller.gameRef.weaponFactory.select(source as SingleWeaponView);
        if (controller.buildingWeapon != null) {
          controller.send(controller.buildingWeapon!, GameControl.WEAPON_BUILDING);
        }
        break;
      case GameControl.WEAPON_BUILD_DONE:
        // controller.buildingWeapon.buildDone = true;
        controller.gameRef.weaponFactory.onBuildDone(source as WeaponComponent);
        controller.gameRef.mapController.astarMapAddObstacle(source.position);
        controller.buildingWeapon = null;
        controller.processEnemySmartMove();
        break;
      case GameControl.WEAPON_DESTROYED:
        WeaponViewWidget.hide();
        controller.gameRef.weaponFactory.onDestroy(source as WeaponComponent);
        controller.gameRef.mapController.astarMapRemoveObstacle(source.position);
        controller.processEnemySmartMove();
        break;
      case GameControl.ENEMY_SPAWN:
        controller.enemyFactory.start();
        break;
      case GameControl.ENEMY_MISSED:
        controller.gameRef.gamebarView.missedEnemy += 1;
        break;
      case GameControl.ENEMY_KILLED:
        controller.gameRef.gamebarView.killedEnemy += 1;
        break;
      case GameControl.ENEMY_NEXT_WAVE:
        controller.gameRef.gamebarView.wave += 1;
        break;
      case GameControl.WEAPON_SHOW_ACTION:
        WeaponViewWidget.show(source as WeaponComponent);
        break;
      case GameControl.GAME_OVER:
        controller.gameRef.overlays.add('gameover');
        controller.gameRef.pauseEngine();
        break;
      default:
    }
  }
}

class GameController extends GameComponent {
  WeaponComponent? buildingWeapon;
  EnemyFactory enemyFactory = EnemyFactory();
  GameController({
    position,
    size,
  }) : super(position: position, size: size, priority: 10) {
    add(enemyFactory);
  }

  @override
  void update(double dt) {
    processInstruction();
    processRadarScan();
    super.update(dt);
  }

  /* Instruction Queue*/
  Queue _instructQ = new Queue<GameInstruction>();
  send(GameComponent source, GameControl _instruct) {
    _instructQ.add(GameInstruction(source, _instruct));
  }

  void processInstruction() {
    while (_instructQ.isNotEmpty) {
      GameInstruction _instruct = _instructQ.removeFirst();
      _instruct.process(this);
    }
  }

  /* Process Routine */
  void processRadarScan() {
    Iterable<Component> radars = children.where((e) => e is Radar && e.radarOn).cast();
    Iterable<Component> scanbles = children.where((e) => e is Scanable && e.scanable).cast();

    radars.forEach((element) {
      (element as Radar).radarScan(scanbles);
    });
  }

  void processEnemySmartMove() {
    Iterable<Component> enemies = children.where((e) => e is EnemyComponent && e.active).cast();
    enemies.forEach((element) {
      (element as EnemyComponent).moveSmart(gateEnd.position);
    });
  }

  /* Load Initialization */
  late NeutralComponent gateStart;
  late NeutralComponent gateEnd;
  @override
  Future<void>? onLoad() {
    super.onLoad();
    loadGate();
    return null;
  }

  void loadGate() async {
    /*random gate */
    double rndx = Random().nextDouble();
    double rndy = Random().nextDouble();
    Vector2 start, end;

    if (rndx < rndy) {
      start = Vector2(0, (Random().nextDouble() * gameSetting.mapGrid.y).toInt().toDouble());
      end = Vector2(gameSetting.mapGrid.x - 1, (Random().nextDouble() * gameSetting.mapGrid.y).toInt().toDouble());
    } else {
      start = Vector2((Random().nextDouble() * gameSetting.mapGrid.x).toInt().toDouble(), 0);
      end = Vector2((Random().nextDouble() * gameSetting.mapGrid.x).toInt().toDouble(), gameSetting.mapGrid.y - 1);
    }
    start = gameSetting.dotMultiple(start, gameSetting.mapTileSize) + (gameSetting.mapTileSize / 2);
    end = gameSetting.dotMultiple(end, gameSetting.mapTileSize) + (gameSetting.mapTileSize / 2);

    final images = Images();
    gateStart = NeutralComponent(position: start, size: gameSetting.mapTileSize, neutualType: NeutralType.GATE_START)
      ..sprite = Sprite(await images.load('blackhole.png'));
    gateEnd = NeutralComponent(position: end, size: gameSetting.mapTileSize, neutualType: NeutralType.GATE_END)
      ..sprite = Sprite(await images.load('whitehole.png'));
    add(gateStart);
    add(gateEnd);
  }
}
