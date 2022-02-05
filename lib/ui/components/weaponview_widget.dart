import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/widgets.dart';
import '../../base/game_component.dart';
import '../../game/game_main.dart';
import '../../game/game_setting.dart';
import '../../game_controller/game_controller.dart';
import '../../weapon/weapon_component.dart';

import 'package:flutter/material.dart';

class WeaponViewWidget {
  static const String name = 'weaponview';
  static Widget builder(BuildContext buildContext, GameMain game) {
    final Size fullScreenSize = MediaQuery.of(buildContext).size;
    print('full size $fullScreenSize');
    final Vector2 fullSize =
        Vector2(fullScreenSize.width, fullScreenSize.height);
    print('fullSize $fullSize');
    Vector2 screenSize =
        Vector2(GameSetting().screenSize.x, GameSetting().screenSize.x);
    Vector2 tileSize = GameSetting().mapTileSize;
    print('screenSize $screenSize');

    final double paddingY = fullSize.y - screenSize.y;
    print('paddingY $paddingY');

    Vector2 size = Vector2(
        GameSetting().screenSize.x * 0.28, GameSetting().screenSize.x * 0.2);
    Vector2 arrowSize = Vector2(4, 4);
    if (_selected == null) return const Center();

    Vector2 anchor =
        game.gameController.absolutePositionOf(_selected!.position);
    Vector2 mapTileSize = GameSetting().mapTileSize;
    if (anchor.y >= fullSize.y - (paddingY / 2) - (tileSize.y * 2)) {
      anchor.y = fullSize.y - (paddingY / 2) - (tileSize.y * 4);
      print('===============YYY =====');
    }
    if (anchor.y <= ((paddingY / 2) + (tileSize.y * 2))) {
      anchor.y = tileSize.y * 2;
      print('---------------${anchor.y}');
      // - size.y

    }
    if (anchor.x >= fullScreenSize.width - tileSize.x) {
      anchor.x = fullScreenSize.width - tileSize.x - size.x;
      print('----aaaaaa----${anchor.x}');
      // - size.y

    } else if (true) {
      anchor = Vector2(anchor.x - size.x / 2,
          anchor.y + _selected!.size.y / 2 + arrowSize.y);
    }
    anchor.x = GameSetting().screenSize.x / 2 - size.x / 2;
    return Positioned(
        top: anchor.y,
        left: anchor.x,
        child: SizedBox.fromSize(
          size: Size(size.x, size.y),
          child: DecoratedBox(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/diaglog.png"),
                      fit: BoxFit.fill)),
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
                            GameControl.weaponDestroyed);
                        hide();
                      },
                      label: const Text(
                        'Destroy',
                        style: TextStyle(color: Color(0xFF5D275D)),
                      ),
                    ))
              ])),
        ));
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
