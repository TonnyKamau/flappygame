import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flappygame/constants.dart';
import 'package:flutter/material.dart';
import '../game.dart';

class PauseButton extends PositionComponent
    with TapCallbacks, HasGameReference<FlappyGame> {
  late final TextComponent pauseText;

  PauseButton(FlappyGame game) : super() {
    size = Vector2(GameConfig.buttonSize, GameConfig.buttonSize);
    position = Vector2(
      game.size.x - size.x - GameConfig.buttonMargin,
      GameConfig.buttonMargin,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;

    pauseText = TextComponent(
      text: 'II',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: GameConfig.buttonFontSize * 0.8,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );

    pauseText.anchor = Anchor.center;
    pauseText.position = size / 2;
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
  void update(double dt) {
    super.update(dt);
    // Sync icon with game state (pausing/resuming)
    final expectedText = game.isPaused ? '▶' : 'II';
    if (pauseText.text != expectedText) {
      pauseText.text = expectedText;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (game.isGameOver || game.isReady) return;

    if (game.isPaused) {
      // If we're already paused, resume (this handles if dialog was closed manually)
      game.isPaused = false;
      game.resumeEngine();
      // Close any open dialogs if possible (though resume happens inside dialog usually)
    } else {
      game.pauseGame();
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.buttonRadius)),
      Paint()..color = GameConfig.glassColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.buttonRadius)),
      Paint()
        ..color = GameConfig.glassBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    super.render(canvas);
  }
}
