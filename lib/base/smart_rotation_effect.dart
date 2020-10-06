import 'dart:math';

import 'package:flame/effects/effects.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SmartRotatorEffect extends PositionComponentEffect {
  double radians;
  double speed;
  Curve curve;

  double _originalAngle;
  double toAngle;

  SmartRotatorEffect({
    @required this.toAngle, //final angle.
    @required this.speed, // In radians per second
    this.curve,
    isInfinite = false,
    Function onComplete,
  }) : super(isInfinite, false, onComplete: onComplete);
  void initialize(_comp) {
    super.initialize(_comp);
    component.angle = (component.angle) % (pi * 2);
    radians = toAngle - component.angle;
    if (radians > pi) {
      radians = radians - (pi * 2);
    }
    if (radians < -pi) {
      radians = radians + (pi * 2);
    }
    if ((component.angle + radians) < 0) {
      component.angle += (pi * 2);
    }
    _originalAngle = component.angle;
    travelTime = (radians / speed).abs();

    if (!isAlternating) {
      endAngle = component.angle + radians;
    }
    // print('SmartRotatorEffect $_originalAngle, $radians');
  }

  void update(double dt) {
    super.update(dt);
    final double c = curve?.transform(percentage) ?? 1.0;
    component.angle = (_originalAngle + radians * c);
    // print('SmartRotatorEffect.update $radians, $percentage, $c');
  }
}
