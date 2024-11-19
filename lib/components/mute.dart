import 'package:flame/components.dart'; // Import Flame components for game development
import 'package:flame/events.dart'; // Import Flame event handling
import 'package:flutter/material.dart'; // Import Flutter material design
import '../game.dart';
import 'components.dart'; // Import the game logic

// Class representing a mute button in the game
class MuteButton extends PositionComponent with TapCallbacks {
  final FlappyGame game; // Reference to the game instance
  late final TextComponent muteText; // Text component for the mute icon
  final Paint _bgPaint; // Paint object for the button background
  bool isMuted = false; // State to track if sound is muted

  // Constructor for MuteButton
  MuteButton(this.game)
      : _bgPaint = Paint()..color = Colors.white.withOpacity(0.7) {
    // Initialize background paint
    size = Vector2(40, 40); // Button size

    // Position will be set in onGameResize
    position = Vector2(
        game.size.x - size.x - 40, // Same X position as PauseButton
        90 // 50 pixels below the PauseButton
        );

    // Initialize the mute text component
    muteText = TextComponent(
      text: '🔇', // Mute icon
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 30, // Font size for the mute icon
          color: Colors.black, // Color of the mute icon
        ),
      ),
    );

    // Center the mute icon in the button
    muteText.position = Vector2(
      (size.x - muteText.size.x) / 2, // Center horizontally
      (size.y - muteText.size.y) / 2, // Center vertically
    );

    add(muteText); // Add the mute text to the button
  }

  // Method called when the game is resized
  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize); // Call the superclass method
    // Update position when game size changes
    position = Vector2(
      gameSize.x - size.x - 40, // Recalculate X position
      90, // 50 pixels below the PauseButton
    );
  }

  // Method called when the button is tapped
  @override
  bool onTapDown(TapDownEvent event) {
    SoundManager.toggleMute(); // Toggle mute state
    isMuted = !isMuted; // Update local state
    muteText.text = isMuted ? '🔊' : '🔇'; // Update the button icon
    return true;
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
