import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/palette.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:freedefense/base/flame_game.dart';
import 'package:freedefense/base/game_component.dart';

class StatusBar extends GameComponent {
  TextComponent waveStatus;
  TextComponent killedStatus;
  TextComponent missedStatus;
  int killedEnemey = 0;
  int missedEnemey = 0;
  StatusBar({
    Position initPosition,
    Size size,
  }) : super(initPosition: initPosition, size: size);

  void registerToGame(FlameGame gameRef, {bool later = false}) {
    super.registerToGame(gameRef, later: later);
    init();
  }

  void init() {
    TextConfig textConfig = TextConfig(color: BasicPalette.white.color);
    waveStatus = TextComponent('Wave 1', config: textConfig.withFontSize(25.0))
      ..anchor = Anchor.center
      ..x = position.x
      ..y = position.y;

    killedStatus =
        TextComponent('Killed 0', config: textConfig.withFontSize(18.0))
          ..anchor = Anchor.center
          ..x = position.x / 2
          ..y = position.y;

    missedStatus =
        TextComponent('Missed 0', config: textConfig.withFontSize(18.0))
          ..anchor = Anchor.center
          ..x = position.x + position.x / 2
          ..y = position.y;
    gameRef.add(waveStatus);
    gameRef.add(killedStatus);
    gameRef.add(missedStatus);
  }

  @override
  void update(double t) {
    super.update(t);

    killedStatus.text = 'killed: $killedEnemey';
    missedStatus.text = 'missed: $missedEnemey';
  }
}
