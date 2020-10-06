import 'package:mindcraft/base/game_component.dart';

mixin EnemyComponent on GameComponent {
  double life;
  double maxLife;

  // EnemyComponent({
  //   Position initPosition,
  //   Size size,
  //   this.life = 100,
  // }) : super(initPosition: initPosition, size: size) {
  //   maxLife = life;
  // }

  void setType(String name) {}

  @override
  void update(double t) {
    super.update(t);
    if (life < 0) {
      this.remove();
    }
  }

  void receiveDamage(double damage) {
    life -= damage;
  }
}
