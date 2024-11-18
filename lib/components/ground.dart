import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flappygame/constants.dart';
import 'package:flappygame/game.dart';

class Ground extends SpriteComponent
    with HasGameRef<FlappyGame>, CollisionCallbacks {
  Ground() : super();

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - size.y);
    sprite = await Sprite.load('base.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.x -= groundSpeed * dt;
    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
    return super.update(dt);
  }
}
