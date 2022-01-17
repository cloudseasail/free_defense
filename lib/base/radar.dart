import 'package:flame/components.dart';
import 'package:freedefense/base/game_component.dart';

mixin Radar<T> on GameComponent {
  bool _radarOn = false;
  bool radarScanBest = false;
  double radarRange = 0;
  double radarCollisionDepth = 0.1;
  void Function(GameComponent)? radarScanAlert;
  void Function()? radarScanNothing;

  set radarOn(bool e) {
    _radarOn = e;
  }

  bool get radarOn => _radarOn;

  void radarScan(Iterable<Component> targets) {
    if (radarOn) {
      _bestDistance = 100000;
      Iterable<Component> _targets = targets
          .where((e) => ((e is T) && ((e as GameComponent).active)))
          .cast();
      _targets
          .takeWhile((value) => _collisionTest(value as GameComponent))
          .forEach((element) {});

      if (_bestTarget != null) {
        radarScanAlert?.call(_bestTarget!);
        _bestTarget = null;
      } else {
        radarScanNothing?.call();
      }
    }
  }

  double _bestDistance = 100000;
  GameComponent? _bestTarget;

  bool _collisionTest(GameComponent target) {
    Vector2 targetPosition = target.position;
    double targetCollisionSize = (target.size.x + target.size.y) / 4;
    double collisionRange = (targetCollisionSize + radarRange);
    collisionRange = collisionRange * (1 - radarCollisionDepth);
    double distance = position.distanceTo(targetPosition);
    if (distance < collisionRange) {
      if (radarScanBest) {
        if (distance < _bestDistance) {
          _bestDistance = distance;
          _bestTarget = target;
        }
        return true;
      } else {
        _bestTarget = target;
        return false;
      }
    }
    return true;
  }

  bool collision(GameComponent target) {
    Vector2 targetPosition = target.position;
    double targetCollisionSize = (target.size.x + target.size.y) / 4;
    double collisionRange = (targetCollisionSize + radarRange);
    collisionRange = collisionRange * (1 - radarCollisionDepth);
    double distance = position.distanceTo(targetPosition);
    if (distance < collisionRange) {
      return true;
    }
    return false;
  }
}
