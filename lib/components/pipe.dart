import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappygame/constants.dart';
import 'package:flappygame/game.dart';

import 'components.dart';

class Pipe extends SpriteComponent
    with HasGameReference<FlappyGame>, CollisionCallbacks {
  final bool isTop;
  bool scored = false;

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
    if (game.isPaused || game.isGameOver) return;

    position.x -= GameConfig.pipeSpeed * dt;

    if (!scored && position.x + size.x / 2 <= game.bird.position.x) {
      scored = true;
      if (isTop) {
        _playPointSound();
        game.updateScore();
      }
    }

    if (position.x + size.x / 2 <= 0) {
      removeFromParent();
    }
  }

  void _playPointSound() async {
    try {
      SoundManager.playPointSound();
      // ignore: empty_catches
    } catch (e) {}
  }
}
