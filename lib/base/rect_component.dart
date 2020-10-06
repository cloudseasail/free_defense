import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/position.dart';

mixin RectComponent on PositionComponent {
  Rect area;
  Position _position;
  Size _size;
  Anchor anchor = Anchor.center;

  set position(Position p) => updatePosition(p);
  get position => Position(x, y);

  set size(Size s) => updateSize(s);
  get size => _size;

  void setByRect(Rect rect) {
    super.setByRect(rect);
  }

  void updatePosition(Position p) {
    _position = p;
    setByPosition(_position);
    area = toRect();
  }

  void updateSize(Size s) {
    _size = s;
    setBySize(Position.fromSize(_size));
    area = toRect();
  }

  prepareCanvas(Canvas canvas) {
    if (angle > 0) {
      canvas.translate(x, y);
      canvas.rotate(angle);
      canvas.translate(-x, -y);
    }

    // // Handle inverted rendering by moving center and flipping.
    // if (renderFlipX || renderFlipY) {
    //   canvas.translate(width / 2, height / 2);
    //   canvas.scale(renderFlipX ? -1.0 : 1.0, renderFlipY ? -1.0 : 1.0);
    //   canvas.translate(-width / 2, -height / 2);
    // }

    if (debugMode) {
      renderDebugMode(canvas);
    }
  }
}
