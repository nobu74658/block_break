import 'package:super_block_break/components/ball.dart';
import 'package:super_block_break/components/block.dart';
import 'package:super_block_break/views/gameover_view.dart';
import 'package:super_block_break/views/initial_view.dart';
import 'package:super_block_break/components/paddle.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class GameLoopWidget extends StatelessWidget {
  GameLoopWidget({Key? key}) : super(key: key);

  final gameLoop = GameLoop(GameLoopState(0, false));

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SizedBox(
        height: deviceHeight * 0.8,
        width: deviceWidth * 0.8,
        child: GameWidget(
            game: gameLoop,
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
        overlayBuilderMap: {
          'initial':(context, GameLoop gameLoop) => InitialView(
            gameLoop: gameLoop,
          ),
          'game over': (context, GameLoop gameLoop) =>
              GameOverView(gameLoop: gameLoop),
        },
        initialActiveOverlays: const ['initial'],
        ),
      ),
    );
  }
}

class GameLoop extends FlameGame
  with HasCollidables, HasKeyboardHandlerComponents {
  static const blockColCount = 6;
  static const blockRowCount = 2;
  final GameLoopState gameLoopState;

  GameLoop(this.gameLoopState) : super();

  void onOverlayChanged() {
    if (overlays.isActive('initial')) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }

  @override
  void update(double dt) {
    if (gameLoopState.isGameOver || gameLoopState.score >= blockColCount * blockRowCount) {
      var allBlocks = children.query<BreakableBlock>();
      var ball = children.query<Ball>();
      removeAll(allBlocks);
      removeAll(ball);
      overlays.add('game over');
    }
    super.update(dt);
  }

  void reload(){
    addInitialBlock();
    addInitialBall();
    gameLoopState.reset();
  }

  void addInitialBlock() {
    final blockWidth = canvasSize.x * 0.1;
    final blockHeight = blockWidth * 0.6;
    for (var i = 0; i < blockColCount; i++) {
      for (var j = 0; j < blockRowCount; j++) {
        var blockPositionX = (canvasSize.x / (blockColCount + 1)) * (i + 1) - blockWidth / 2;
        var blockPositionY = canvasSize.y * 0.03 * (j + 1) + blockHeight * j;
        add(BreakableBlock(Vector2(blockWidth, blockHeight),
        Vector2(blockPositionX, blockPositionY)));
      }
    }
  }

  void addInitialPaddle() {
    final paddleWidth = canvasSize.x * 0.2;
    final paddleHeight = paddleWidth * 0.1;
    final paddleX = (canvasSize.x - paddleWidth) /2;
    final paddleY = canvasSize.y * 0.9;
    add(Paddle(Vector2(paddleWidth, paddleHeight), Vector2(paddleX, paddleY)));
  }

  void addInitialBall() {
    final ballRadius = canvasSize.x *0.03;
    final ballX = (canvasSize.x - ballRadius) / 2;
    final ballY = canvasSize.y / 2;
    add(Ball(ballRadius, Vector2(ballX, ballY)));
  }

  @override
  void onMount() {
    paused = true;
    overlays.addListener(onOverlayChanged);
    super.onMount();
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    add(ScreenCollidable());
    addInitialBlock();
    addInitialPaddle();
    addInitialBall();
    children.register<BreakableBlock>();
    children.register<Ball>();
  }
}

class GameLoopState {
  int score;
  bool isGameOver;

  GameLoopState(this.score, this.isGameOver);

  void reset() {
    score = 0;
    isGameOver = false;
  }

  void incrementScore() {
    score++;
  }

  void gameOver() {
    isGameOver = true;
  }
}
