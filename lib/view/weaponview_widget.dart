import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/game/game_controller.dart';
import 'package:freedefense/game/game_main.dart';
import 'package:freedefense/game/game_setting.dart';
import 'package:freedefense/weapon/weapon_component.dart';

class WeaponViewWidget {
  static const String name = 'weaponview';

  static Widget builder(BuildContext buildContext, GameMain game) {
    Vector2 size = Vector2(GameSetting().screenSize.x * 0.8, 500);
    Vector2 arrowSize = Vector2(20, 20);
    if (_selected == null) {
      return Center();
    } else {
      _selected?.dialogVisible = false;
    }
    Vector2 anchor =
        game.gameController.absolutePositionOf(_selected!.position);
    if (anchor.y > GameSetting().screenSize.y / 2) {
      anchor = Vector2(anchor.x - size.x / 2,
          anchor.y - _selected!.size.y / 2 - size.y - arrowSize.y);
    } else {
      anchor = Vector2(anchor.x - size.x / 2,
          anchor.y + _selected!.size.y / 2 + arrowSize.y);
    }
    anchor.x = GameSetting().screenSize.x / 2 - size.x / 2;
    String imagePath = "";
    int index =_selected?.barrelModelIndex ?? 2;
    if (index < 2) {
      imagePath = _selected?.setting.paths[(_selected?.barrelModelIndex ?? 0) + 1] ?? "";
    }

    _selected?.dialogVisible = true;
    return Positioned(
      top: anchor.y,
      left: anchor.x,
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/diaglog.png"),
                  fit: BoxFit.fill)),
          width: size.x / 2,
          height: size.y / 2,
          child: Stack(alignment: Alignment.center, children: [
            (imagePath != "")
                ? Positioned(
                    top: 75,
                    child: SpriteButton.asset(
                      path: imagePath ,
                      pressedPath: imagePath,
                      width: 45,
                      height: 45,
                      onPressed: () {
                        _selected?.upgradeBarrel();
                        _selected?.dialogVisible = false;
                        hide();
                      },
                      label: const Text(
                        'Upgrade',
                        style: TextStyle(color: Color(0xFF5D275D)),
                      ),
                    ))
                : Container(),
            Positioned(
                top: 25,
                child: SpriteButton.asset(
                  path: 'destroy.png',
                  pressedPath: 'destroy2.png',
                  width: 45,
                  height: 45,
                  onPressed: () {
                    _selected?.active = false;
                    _selected?.removeFromParent();
                    _selected?.gameRef.gameController.send(
                        _selected as GameComponent,
                        GameControl.WEAPON_DESTROYED);
                    _selected?.dialogVisible = false;
                    hide();
                  },
                  label: const Text(
                    'Destroy0',
                    style: TextStyle(color: Color(0xFF5D275D)),
                  ),
                ))
          ])),
    );
  }

  static int count = 0;
  static WeaponComponent? _selected;

  static show(WeaponComponent w) {
    _selected?.dialogVisible = false;
    _selected = w;
    String finalName = "$name-${_selected?.weaponType}";
    _selected?.gameRef.overlays.add(finalName);
  }

  static hide() {
    _selected?.dialogVisible = false;
    String finalName = "$name-${_selected?.weaponType}";
    _selected?.gameRef.overlays.remove(finalName);
    _selected = null;
    count++;
  }
}
