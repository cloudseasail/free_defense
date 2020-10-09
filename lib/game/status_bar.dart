import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/palette.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:freedefense/base/game_component.dart';

class StatusBar extends GameComponent {
  TextComponent waveStatus;
  TextComponent killedStatus;
  TextComponent missedStatus;
  TextComponent startIndicator;
  int killedEnemey = 0;
  int missedEnemey = 0;
  StatusBar({
    Position initPosition,
    Size size,
  }) : super(initPosition: initPosition, size: size);

  @override
  void initialize() {
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

    showStartIndicator();
  }

  @override
  void update(double t) {
    super.update(t);

    killedStatus.text = 'killed: $killedEnemey';
    missedStatus.text = 'missed: $missedEnemey';
  }

  void setWaveStatus(int wave) {
    showWaveIndicator(wave);
    waveStatus.text = 'Wave $wave';
  }

  void showWaveIndicator(int wave) {
    TextConfig textConfig = TextConfig(color: BasicPalette.white.color);
    TextComponent waveIndicator =
        TextComponent('Wave $wave', config: textConfig.withFontSize(80.0))
          ..anchor = Anchor.center
          ..x = gameRef.setting.screenSize.width / 2
          ..y = gameRef.setting.screenSize.height / 2;
    gameRef.add(waveIndicator);
    gameRef.util
        .timer(3, repeat: false, callback: () => gameRef.remove(waveIndicator))
        .start();
  }

  void showStartIndicator() {
    TextConfig textConfig = TextConfig(color: BasicPalette.white.color);
    startIndicator =
        TextComponent('Click to Start', config: textConfig.withFontSize(50.0))
          ..anchor = Anchor.center
          ..x = gameRef.setting.screenSize.width / 2
          ..y = gameRef.setting.screenSize.height / 2;
    gameRef.add(startIndicator);
  }

  void removeStartIndicator() {
    gameRef.remove(startIndicator);
  }
}
