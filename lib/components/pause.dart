import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flappygame/constants.dart';
import 'package:flutter/material.dart';
import '../game.dart';

class PauseButton extends PositionComponent with TapCallbacks {
  final FlappyGame game;
  late final TextComponent pauseText;
  final Paint _bgPaint;

  PauseButton(this.game)
      : _bgPaint = Paint()..color = Colors.white.withValues(alpha: 0.7) {
    size = Vector2(GameConfig.buttonSize, GameConfig.buttonSize);
    position = Vector2(
      game.size.x - size.x - GameConfig.buttonMargin,
      GameConfig.buttonMargin,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    pauseText = TextComponent(
      text: '⏸️',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: GameConfig.buttonFontSize,
          color: Colors.black,
        ),
      ),
    );

    pauseText.position = Vector2(
      (size.x - pauseText.size.x) / 2,
      (size.y - pauseText.size.y) / 2,
    );

    add(pauseText);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = Vector2(GameConfig.buttonSize, GameConfig.buttonSize);
    position = Vector2(
      size.x - this.size.x - GameConfig.buttonMargin,
      GameConfig.buttonMargin,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!game.isGameOver && !game.isReady) {
      game.pauseGame();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      _bgPaint,
    );
    super.render(canvas);
  }
}
