import 'package:super_block_break/components/block.dart';
import 'package:super_block_break/game.dart';
import 'package:super_block_break/components/paddle.dart';
import 'package:flame/components.dart';

class Ball extends CircleComponent with Collidable, HasGameRef<GameLoop> {
  var dx = 5;
  var dy = 5;
  static const radius = 20.0;

  Ball(radius, position) : super(radius: radius, position: position);

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is ScreenCollidable && x + dx + radius / 2 < 0) {
      dx *= -1;
    } else if (x + dx + radius / 2 > gameRef.canvasSize.x) {
      dx *= -1;
    } else if (other is ScreenCollidable && y + dy + radius / 2 < 0) {
      dy *= -1;
    } else if (y + dy + radius / 2 > gameRef.canvasSize.y) {
      gameRef.gameLoopState.gameOver();
    } else if (other is BreakableBlock) {
      dy *= -1;
    } else if (other is Paddle) {
      dy *= -1;
    }
  }

  @override
  void update(double dt) {
    position = Vector2(x + dx, y + dy);
  }
}