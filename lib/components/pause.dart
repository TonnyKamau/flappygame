import 'package:flame/components.dart'; // Import Flame components for game development
import 'package:flame/events.dart'; // Import Flame event handling
import 'package:flutter/material.dart'; // Import Flutter material design
import '../game.dart'; // Import the game logic

// Class representing a pause button in the game
class PauseButton extends PositionComponent with TapCallbacks {
  final FlappyGame game; // Reference to the game instance
  late final TextComponent pauseText; // Text component for the pause icon
  final Paint _bgPaint; // Paint object for the button background

  // Constructor for PauseButton
  PauseButton(this.game)
      : _bgPaint = Paint()..color = Colors.white.withOpacity(0.7) {
    // Initialize background paint
    size = Vector2(40, 40); // Button size

    // Position will be set in onGameResize
    position = Vector2(
        game.size.x - size.x - 40, // 20 pixels from right edge
        40 // 20 pixels from top
        );

    // Initialize the pause text component
    pauseText = TextComponent(
      text: '⏸️', // Pause icon
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40, // Font size for the pause icon
          color: Colors.black, // Color of the pause icon
        ),
      ),
    );

    // Center the pause icon in the button
    pauseText.position = Vector2(
      (size.x - pauseText.size.x) / 2, // Center horizontally
      (size.y - pauseText.size.y) / 2, // Center vertically
    );

    add(pauseText); // Add the pause text to the button
  }

  // Method called when the game is resized
  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize); // Call the superclass method
    // Update position when game size changes
    position = Vector2(
      gameSize.x - size.x - 40, // Recalculate position based on new game size
      40,
    );
  }

  // Method called when the button is tapped
  @override
  bool onTapDown(TapDownEvent event) {
    if (!game.isGameOver && !game.isReady) {
      // Check if the game is not over and ready
      game.pauseGame(); // Pause the game
    }
    return true; // Indicate that the tap was handled
  }

  // Method to render the button on the canvas
  @override
  void render(Canvas canvas) {
    // Draw rounded rectangle background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            0, 0, size.x, size.y), // Define the rectangle for the button
        const Radius.circular(8), // Set the corner radius
      ),
      _bgPaint, // Use the background paint
    );
    super.render(canvas); // Call the superclass render method
  }
}
