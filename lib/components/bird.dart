import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappygame/constants.dart';

import '../game.dart';
import 'components.dart';

class Bird extends SpriteComponent with CollisionCallbacks {
  Bird()
      : super(
          position: Vector2(birdStartX, birdStartY),
          size: Vector2(birdWidth, birdHeight),
        );
  double velocity = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  void flap() {
    velocity = jumpHeight;
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;
    position.y += velocity * dt;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Ground) {
      _audioPlayer.play(AssetSource('audio/die.wav'));
      (parent as FlappyGame).gameOver();
    }
    if (other is Pipe) {
      _audioPlayer.play(AssetSource('audio/hit.wav'));
      (parent as FlappyGame).gameOver();
    }
  }
}
