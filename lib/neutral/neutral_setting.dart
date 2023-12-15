import 'package:flame/cache.dart';
import 'package:flame/components.dart';

class NeutralSetting {
  late Sprite mine;
  late Sprite mineCluster;

  Future<void> load() async {
    final images = Images();
    mine = Sprite(await images.load('neutral/mine.png'));
    mineCluster = Sprite(await images.load('neutral/mine_cluster.png'));
  }
}
