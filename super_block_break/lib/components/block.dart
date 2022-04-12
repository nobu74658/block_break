import 'package:super_block_break/components/ball.dart';
import 'package:super_block_break/game.dart';
import 'package:flame/components.dart';

class BreakableBlock extends RectangleComponent
  with Collidable, HasGameRef<GameLoop> {
  BreakableBlock(size, position) : super(size: size, position: position);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is Ball) {
      gameRef.gameLoopState.incrementScore();
      gameRef.remove(this);
    }
  }
}