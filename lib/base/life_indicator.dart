import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:freedefense/base/game_component.dart';

mixin LifeIndicator on GameComponent {
  double maxLife = 0;
  double life = 0;

  void renderLifIndicator(Canvas c) {
    if (maxLife == 0) return;
    Vector2 start = Vector2.zero();
    Vector2 end = Vector2((life / maxLife) * size.x, 0);
    c.drawLine(start.toOffset(), end.toOffset(), Paint()..color = Colors.green);
  }
}
