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

    final highestScore = await AppDatabase.instance.getHighestScore();

    backgroundBox = RectangleComponent(
      size: Vector2(GameConfig.highScoreBoxWidth, GameConfig.highScoreBoxHeight),
      position: Vector2(GameConfig.buttonMargin, GameConfig.buttonMargin),
      paint: Paint()..color = const Color(0xAA000000),
    );
    add(backgroundBox);

    textComponent = TextComponent(
      text: 'High Score: $highestScore',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: GameConfig.highScoreFontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: Color(0xFF000000),
            ),
          ],
        ),
      ),
    );

    textComponent.position = backgroundBox.size / 2;
    backgroundBox.add(textComponent);
  }

  /// Called from game.dart after game over to refresh the displayed score.
  /// This replaces the old approach of querying the database every frame.
  void refreshScore() async {
    final highestScore = await AppDatabase.instance.getHighestScore();
    final newText = 'High Score: $highestScore';

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
