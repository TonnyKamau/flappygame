import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappygame/constants.dart';
import 'package:flappygame/game.dart';

class Ground extends SpriteComponent
    with HasGameReference<FlappyGame>, CollisionCallbacks {
  Ground() : super();

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(2 * game.size.x, GameConfig.groundHeight);
    position = Vector2(0, game.size.y - size.y);
    sprite = await Sprite.load('base.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = Vector2(2 * size.x, GameConfig.groundHeight);
    position = Vector2(position.x, size.y - this.size.y);
  }

  @override
  void update(double dt) {
    if (game.isPaused || game.isGameOver) return;

    position.x -= GameConfig.groundSpeed * dt;
    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
    return super.update(dt);
  }
}
