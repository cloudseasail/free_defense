/* 
 * canvas-astar.dart
 * MIT licensed
 *
 * Created by Daniel Imms, http://www.growingwiththeweb.com
 */

class AstarNode {
  AstarNode parent;
  AstarNode next;
  int x;
  int y;
  double g;
  double f;

  AstarNode(this.x, this.y, {this.parent, double cost: 0.0}) {
    g = (parent != null ? parent.g : 0) + cost;
  }

  bool operator ==(covariant other) {
    return (x == other.x && y == other.y);
  }

  int get hashCode => super.hashCode;
}
