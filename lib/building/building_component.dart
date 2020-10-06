import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:mindcraft/base/game_component.dart';

class BuildingComponent extends GameComponent {
  double life;
  double maxLife;

  BuildingComponent({
    @required Position initPosition,
    Size size,
    this.life = 100,
  }) : super(initPosition: initPosition, size: size) {
    maxLife = life;

    // registerGestureEvent(GestureType.TapDown);
  }
}
