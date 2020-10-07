import 'dart:ui';
import 'package:flame/animation.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/position.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Animation;
import 'package:freedefense/base/flame_game.dart';
import 'package:freedefense/base/rect_component.dart';
import 'package:freedefense/game/game_main.dart';

enum GestureType {
  Tap,
  TapDown,
  LongPress,
  PanUpdate,
}

class GameComponent extends PositionComponent
    with RectComponent, HasGameRef<GameMain> {
  /// Position used to draw on the screen
  Position initPosition = Position(0, 0);

  List<GestureType> registeredGestures = [];

  /// Variable used to control whether the component has been destroyed.
  bool _isDestroyed = false;
  Animation animation;

  int priority() => 100;

  GameComponent({this.initPosition, Size size}) {
    //use clone to avoid another  component ref to same position and causing corruption.
    position = initPosition.clone();
    this.size = size;
  }

  void render(Canvas canvas) {
    prepareCanvas(canvas);
    if (animation != null) {
      animation.getSprite().renderRect(canvas, area);
    }
  }

  void update(double t) {
    super.update(t);
    if (animation != null) {
      animation.update(t);
    }
  }

  @override
  bool destroy() {
    return _isDestroyed;
  }

  /// This method destroy of the component
  void remove() {
    _isDestroyed = true;
  }

  bool isVisibleInCamera() {
    return true;
  }

  void registerGestureEvent(GestureType gestureType) {
    registeredGestures.add(gestureType);
  }

  void deregisterGestureEvent(GestureType gestureType) {
    registeredGestures.remove(gestureType);
  }

  void registerToGame(FlameGame gameRef, {bool later = false}) {
    if (later) {
      gameRef.addLater(this);
    } else {
      gameRef.add(this);
    }
  }

  bool gestureHandlable(GestureType gestureType) {
    return registeredGestures.contains(gestureType);
  }

  bool offsetInArea(Offset p) {
    return area.contains(p);
  }

  void onTap() {}

  void onDoubleTap() {}

  void onLongPressStart(LongPressStartDetails details) {}

  void onPanUpdate(DragUpdateDetails details) {}

  void onTapDown(TapDownDetails details) {}

  void receiveDamage(double damage) {}
}
