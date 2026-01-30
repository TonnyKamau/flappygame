import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappygame/components/pipe.dart';
import 'package:flappygame/constants.dart';

import 'package:flappygame/game.dart';

class PipeManager extends Component with HasGameReference<FlappyGame> {
  PipeManager() : super();

  double pipeSpawnTimer = 0;

  @override
  void update(double dt) {
    pipeSpawnTimer += dt;

    if (pipeSpawnTimer > GameConfig.pipeSpawnInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
    super.update(dt);
  }

  void spawnPipe() {
    final double screenHeight = game.size.y;

    final maxPipeHeight =
        screenHeight - GameConfig.groundHeight - GameConfig.pipeGap - GameConfig.minPipeHeight;

    final bottomHeight =
        Random().nextDouble() * (maxPipeHeight - GameConfig.minPipeHeight) + GameConfig.minPipeHeight;
    final topHeight =
        screenHeight - GameConfig.groundHeight - GameConfig.pipeGap - bottomHeight;

    final bottomPipe = Pipe(
      Vector2(GameConfig.pipeWidth, bottomHeight),
      Vector2(game.size.x, screenHeight - GameConfig.groundHeight - bottomHeight),
      isTop: false,
    );
    final topPipe = Pipe(
      Vector2(GameConfig.pipeWidth, topHeight),
      Vector2(game.size.x, 0),
      isTop: true,
    );

    game.add(bottomPipe);
    game.add(topPipe);
  }
}
