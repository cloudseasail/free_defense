import 'package:flame/components.dart';
import 'package:freedefense/base/game_component.dart';
import 'package:freedefense/base/radar.dart';
import 'package:freedefense/enemy/enemy_component.dart';

enum NeutralType { GATE_START, GATE_END, MINDER, STONE }

class NeutralComponent extends GameComponent with Radar<EnemyComponent> {
  double life = 0;
  late NeutralType neutualType;
  NeutralComponent({
    required Vector2 position,
    required Vector2 size,
    required this.neutualType,
  }) : super(position: position, size: size, priority: 20) {
    radarOn = false;

    if (neutualType == NeutralType.GATE_END) {
      radarOn = true;
      radarRange = (size.x + size.y) / 4;
      radarCollisionDepth = 0.9;
      radarScanAlert = (c) => (c as EnemyComponent).onArrived();
    }
  }
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
  }
}
