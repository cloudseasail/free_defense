import 'dart:ui';

import 'package:flame/position.dart';

import '../building_component.dart';

class WeaponComponent extends BuildingComponent {
  WeaponComponent({
    Position initPosition,
    Size size,
    double life = 100,
  }) : super(initPosition: initPosition, size: size, life: life);
}
