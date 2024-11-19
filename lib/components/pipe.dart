import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappygame/constants.dart';
import 'package:flappygame/game.dart';

import 'components.dart';

class Pipe extends SpriteComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  final bool isTop; // Indicates if the pipe is the top pipe
  bool scored = false; // Tracks if the pipe has been scored

  Pipe(Vector2 size, Vector2 position, {required this.isTop})
      : super(size: size, position: position);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(isTop ? 'pipe_top.png' : 'pipe_bottom.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= pipeSpeed * dt;

    // Check if the pipe has been scored
    if (!scored && position.x + size.x / 2 <= gameRef.bird.position.x) {
      scored = true;
      if (isTop) {
        _playPointSound(); // Play the point sound
        gameRef.updateScore(); // Update the score
      }
    }

    // Remove the pipe if it moves off-screen
    if (position.x + size.x / 2 <= 0) {
      removeFromParent();
    }
  }

  // Play the point sound
  void _playPointSound() async {
    try {
      SoundManager.playPointSound();
      // ignore: empty_catches
    } catch (e) {}
  }
}
