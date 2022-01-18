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
    if (_selected == null) return Center();

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
    return Positioned(
      top: anchor.y,
      left: anchor.x,
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/diaglog.png"),
                  fit: BoxFit.fill)),
          width: size.x,
          height: size.y,
          child: Stack(alignment: Alignment.center, children: [
            Positioned(
                bottom: 100,
                child: SpriteButton.asset(
                  path: 'destroy.png',
                  pressedPath: 'destroy2.png',
                  width: 50,
                  height: 50,
                  onPressed: () {
                    _selected?.active = false;
                    _selected?.removeFromParent();
                    _selected?.gameRef.gameController.send(
                        _selected as GameComponent,
                        GameControl.WEAPON_DESTROYED);
                    hide();
                  },
                  label: const Text(
                    'Destroy',
                    style: TextStyle(color: Color(0xFF5D275D)),
                  ),
                ))
          ])),
    );
  }

  static WeaponComponent? _selected;

  static show(WeaponComponent w) {
    _selected = w;
    _selected?.gameRef.overlays.add(name);
  }

  static hide() {
    _selected?.gameRef.overlays.remove(name);
    _selected = null;
  }
}
