import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flappygame/database/database.dart';
import 'package:flutter/material.dart';

class HighestScore extends PositionComponent {
  late final TextComponent textComponent;
  late final RectangleComponent backgroundBox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Fetch the highest score from the database
    final highestScore = await AppDatabase.instance.getHighestScore();

    // Create a background box for the score
    backgroundBox = RectangleComponent(
      size: Vector2(250, 60), // Adjust size as needed
      position: Vector2(20, 20), // Align the box
      paint: Paint()..color = const Color(0xAA000000), // Semi-transparent black
    );
    add(backgroundBox);

    // Initialize the TextComponent
    textComponent = TextComponent(
      text: '🏆 High Score: $highestScore',
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: Color(0xFF000000), // Shadow for better contrast
            ),
          ],
        ),
      ),
    );

    // Center the text inside the box
    textComponent.position = backgroundBox.size / 2;
    backgroundBox.add(textComponent);
  }

  @override
  Future<void> update(double dt) async {
    final highestScore = await AppDatabase.instance.getHighestScore();

    if (textComponent.text != '🏆 High Score: $highestScore') {
      textComponent.text = '🏆 High Score: $highestScore';

      // Optional: Add a glowing effect when the score updates
      textComponent.add(
        ScaleEffect.to(
          Vector2(1.2, 1.2),
          EffectController(duration: 0.2, reverseDuration: 0.2),
        ),
      );
    }
    super.update(dt);
  }
}
