import 'package:flame/components.dart';
import 'package:flappygame/database/database.dart';
import 'package:flutter/material.dart';

class HighestScore extends PositionComponent {
  late final TextComponent textComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Fetch the highest score from the database
    final highestScore = await AppDatabase.instance.getHighestScore();

    // Initialize the TextComponent
    textComponent = TextComponent(
      text: 'Highest Score: $highestScore',
      anchor: Anchor.topLeft, // Align text relative to its top-left corner
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24, // Adjust font size as needed
          color: Color(0xFFFFFFFF), // White text for contrast
        ),
      ),
    );

    // Position the HighestScore text 20 pixels from the top and 20 pixels from the left
    textComponent.position = Vector2(40, 40);

    // Add the TextComponent as a child of HighestScore
    add(textComponent);
  }
}
