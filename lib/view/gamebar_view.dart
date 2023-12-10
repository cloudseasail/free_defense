import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/game/game_controller.dart';
import 'package:freedefense/game/game_setting.dart';
import 'package:freedefense/view/mine_view.dart';

GameSetting setting = GameSetting();

class GamebarView extends GameComponent {
  GamebarView() : super(position: setting.barPosition, size: setting.barSize) {
    active = false;
  }
  late TextComponent startIndicator;

  late TextComponent missedStatus;
  late TextComponent killedStatus;
  late TextComponent waveStatus;

  late MineView mine;

  int _wave = 0;
  int _killedEnemy = 0;
  int _missedEnemy = 0;
  int _mineCollected = 0;
  int _lives = 20;

  @override
  FutureOr<void>? onLoad() {
    waveStatus = TextComponent(
      textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white70, fontSize: 22)),
      position: (size / 2),
      anchor: Anchor.center,
    );
    add(waveStatus);

    missedStatus = TextComponent(
      textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
      position: (size / 2)..x = (size.x * (1 / 8)),
      anchor: Anchor.center,
    );
    add(missedStatus);

    killedStatus = TextComponent(
      textRenderer: TextPaint(
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
      position: (size / 2)..x = (size.x * (3 / 8)),
      anchor: Anchor.center,
    );
    add(killedStatus);

    mine = MineView(
        position: (size / 2)..x = (size.x * (6 / 8)),
        size: Vector2(size.y * 1.5, size.y) * 0.7,
        style: const TextStyle(color: Colors.white70, fontSize: 12));
    add(mine);

    return super.onLoad();
  }

  int get wave => _wave;
  set wave(n) {
    _wave = n;
    waveStatus.text = 'Wave: $_wave';
  }

  int get killedEnemy => _killedEnemy;
  set killedEnemy(int n) {
    _killedEnemy = n;
    killedStatus.text = 'Killed: $_killedEnemy';
  }

  int get missedEnemy => _missedEnemy;
  set missedEnemy(int n) {
    _missedEnemy = n;
    missedStatus.text = 'Lives: ${_lives - _missedEnemy}';
    if (_lives - _missedEnemy <= 0) {
      gameRef.gameController.send(this, GameControl.GAME_OVER);
    }
  }

  int get mineCollected => _mineCollected;
  set mineCollected(int n) {
    _mineCollected = n;
    mine.number = _mineCollected;
  }
}
