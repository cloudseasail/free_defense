import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/game/game_controller.dart';
import 'package:freedefense/game/game_setting.dart';
import 'package:freedefense/view/mine_view.dart';
import 'package:freedefense/weapon/cannon.dart';
import 'package:freedefense/weapon/machine_gun.dart';
import 'package:freedefense/weapon/missile.dart';
import 'package:freedefense/weapon/weapon_component.dart';

GameSetting gameSetting = GameSetting();

class WeaponFactoryView extends GameComponent {
  late SingleWeaponView selectedWeapon;
  WeaponComponent? buildWeapon(Vector2 anchor) {
    if (selectedWeapon.mineEnough)
      return selectedWeapon.build(anchor);
    else {
      return null;
    }
  }

  WeaponFactoryView()
      : super(
            position: Vector2(gameSetting.viewSize.x * (1 / 3), gameSetting.viewPosition.y),
            size: Vector2(
                gameSetting.viewSize.x * (2 / 3) - gameSetting.mapTileSize.x, gameSetting.viewSize.y * (2 / 3)));

  List<SingleWeaponView> weapons = [];

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    weapons.add(_loadSingleView(0, WeaponType.CANNON));
    weapons.add(_loadSingleView(1, WeaponType.MG));
    weapons.add(_loadSingleView(2, WeaponType.MISSILE));
    // weapons.add(_loadSingleView(3, WeaponType.MINNER));
    select(weapons[0]);
  }

  SingleWeaponView _loadSingleView(int slot, WeaponType type) {
    SingleWeaponView view = SingleWeaponView(
        position: Vector2(size.x * (slot / 3 + 1 / 4), size.y / 3),
        size: Vector2(size.x / 4, size.y),
        weaponType: type);
    add(view);
    return view;
  }

  SingleWeaponView select(SingleWeaponView target) {
    selectedWeapon = target;
    weapons.forEach((e) {
      if (e == target) {
        e.selected = true;
      } else {
        e.selected = false;
      }
    });
    return target;
  }

  int onBuildDone(WeaponComponent c) {
    weapons[c.weaponType.index].count++;
    gameRef.gamebarView.mineCollected -= weapons[c.weaponType.index].cost;

    return weapons[c.weaponType.index].count;
  }

  int onDestroy(WeaponComponent c) {
    weapons[c.weaponType.index].count--;
    return weapons[c.weaponType.index].count;
  }
}

class SingleWeaponView extends GameComponent with TapCallbacks {
  SingleWeaponView({required Vector2 position, required Vector2 size, required this.weaponType})
      : super(position: position, size: size) {
    _baseCost = GameSetting().weapons.weapon[weaponType.index].cost;
    costDelta = _baseCost * 0.2;
    count = 0;
  }
  WeaponType weaponType;
  int _baseCost = 0;
  int cost = 0;
  int _count = 0;
  double costDelta = 0;
  bool mineEnough = false;

  int get count => _count;
  set count(int c) {
    _count = c;
    cost = _baseCost + (_count * costDelta).toInt();
  }

  late WeaponComponent weapon;
  late MineView mine;
  @override
  FutureOr<void>? onLoad() {
    Vector2 base = gameSetting.mapTileSize * 0.9;
    Vector2 center = size / 2, wp, ws, mp, ms;
    if (size.x >= size.y) {
      wp = Vector2(center.x - (base.x * 1.5 / 6), center.y);
      ws = base;
      mp = Vector2(center.x + (base.x * 3 / 6), center.y);
      ms = Vector2(base.x / 2, base.y);
    } else {
      wp = Vector2(center.x, center.y - (base.y * 1.5 / 6));
      ws = base;
      mp = Vector2(center.x, center.y + (base.y * 3 / 6));
      ms = Vector2(base.x, base.y / 2);
    }

    weapon = build(wp)
      ..size = ws
      ..buildDone = true
      ..dialogVisible = false
      ..active = false;
    mine = MineView(position: mp, size: ms);

    add(weapon);
    add(mine);
    return super.onLoad();
  }

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool b) {
    _selected = b;
    if (_selected) {
      _setOpacity(this, 1.0);
    } else {
      _setOpacity(this, 0.4);
      mine.maskGreen = null;
    }
  }

  void _setOpacity(GameComponent c, double o) {
    c.setOpacity(o);
    if (c.children.length > 0) {
      c.children.forEach((e) {
        if (e is GameComponent) _setOpacity(e, o);
      });
    }
  }

  WeaponComponent build(Vector2 anchor) {
    late WeaponComponent weapon;
    switch (weaponType) {
      case WeaponType.CANNON:
        weapon = Cannon(position: anchor, weaponSetting: GameSetting().weapons.weapon[WeaponType.CANNON.index]);
        break;
      case WeaponType.MG:
        weapon = MachineGun(position: anchor, weaponSetting: GameSetting().weapons.weapon[WeaponType.MG.index]);
        break;
      case WeaponType.MISSILE:
        weapon = Missile(position: anchor, weaponSetting: GameSetting().weapons.weapon[WeaponType.MISSILE.index]);
        break;
      default:
        break;
    }
    return weapon;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (selected) {
      gameRef.gameController.send(this, GameControl.WEAPON_SHOW_PROFILE);
    } else {
      gameRef.gameController.send(this, GameControl.WEAPON_SELECTED);
    }
    return false;
  }

  @override
  void update(double t) {
    int collectedMine = gameRef.gamebarView.mine.number;
    if (collectedMine >= cost) {
      mineEnough = true;
    } else {
      mineEnough = false;
    }

    mine.number = cost;

    if (selected) {
      mine.maskGreen = mineEnough;
    }
    super.update(t);
  }
}
