import 'dart:math';

import 'package:flame/components.dart';
import 'package:flappygame/components/pipe.dart';
import 'package:flappygame/constants.dart';

import 'package:flappygame/game.dart';

class PipeManager extends Component with HasGameRef<FlappyGame> {
  // Constructor for PipeManager
  PipeManager() : super();

  // Timer to track pipe spawning intervals
  double pipeSpawnTimer = 0; // Corrected typo

  @override
  void update(double dt) {
    // Increment the timer with the delta time
    pipeSpawnTimer += dt;

    // Check if it's time to spawn a new pipe
    if (pipeSpawnTimer > pipeSpawnInterval) {
      pipeSpawnTimer = 0; // Reset the timer
      spawnPipe(); // Call the method to spawn pipes
    }
    super.update(dt); // Call the superclass update method
  }

  void spawnPipe() {
    // Get the height of the game screen
    final double screenHeight = gameRef.size.y;

    // Calculate the maximum height for the bottom pipe
    final maxPipeHeight = screenHeight - groundHeight - pipeGap - minPipeHeight;

    // Determine the height of the bottom pipe randomly
    final bottomHeight =
        Random().nextDouble() * (maxPipeHeight - minPipeHeight) + minPipeHeight;
    // Calculate the height of the top pipe based on the bottom pipe height
    final topHeight = screenHeight - groundHeight - pipeGap - bottomHeight;

    // Create the bottom pipe
    final bottomPipe = Pipe(
      Vector2(pipeWidth, bottomHeight),
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomHeight),
      isTop: false,
    );
    // Create the top pipe
    final topPipe = Pipe(
      Vector2(pipeWidth, topHeight),
      Vector2(gameRef.size.x, 0),
      isTop: true,
    );

    // Add both pipes to the game
    gameRef.add(bottomPipe);
    gameRef.add(topPipe);
  }
}
