import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappygame/constants.dart';
import 'package:flappygame/database/database.dart';
import 'package:flutter/material.dart';

class HighestScore extends PositionComponent {
  late final TextComponent textComponent;
  late final RectangleComponent backgroundBox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;

    final highestScore = await AppDatabase.instance.getHighestScore();

    backgroundBox = RectangleComponent(
      size:
          Vector2(GameConfig.highScoreBoxWidth, GameConfig.highScoreBoxHeight),
      position: Vector2(GameConfig.buttonMargin, GameConfig.buttonMargin),
      paint: Paint()..color = GameConfig.glassColor,
    );
    // Add rounded corners style via decoration or manual drawing
    add(backgroundBox);

    textComponent = TextComponent(
      text: 'HIGH SCORE: $highestScore',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: GameConfig.highScoreFontSize,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
      ),
    );

    textComponent.position = backgroundBox.size / 2;
    backgroundBox.add(textComponent);
  }

  @override
  void render(Canvas canvas) {
    // Draw rounded background
    final rect = Rect.fromLTWH(
      GameConfig.buttonMargin,
      GameConfig.buttonMargin,
      GameConfig.highScoreBoxWidth,
      GameConfig.highScoreBoxHeight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.buttonRadius)),
      Paint()..color = GameConfig.glassColor,
    );
    // Draw border
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.buttonRadius)),
      Paint()
        ..color = GameConfig.glassBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void refreshScore() async {
    final highestScore = await AppDatabase.instance.getHighestScore();
    final newText = 'HIGH SCORE: $highestScore';

    if (textComponent.text != newText) {
      textComponent.text = newText;

      textComponent.add(
        ScaleEffect.to(
          Vector2(1.2, 1.2),
          EffectController(duration: 0.2, reverseDuration: 0.2),
        ),
      );
    }
  }
}
