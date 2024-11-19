import 'package:flame/events.dart'; // Importing event handling
import 'package:flame/flame.dart'; // Importing Flame engine functionalities
import 'package:flame/game.dart'; // Importing game functionalities
import 'package:flappygame/database/database.dart';
import 'package:flappygame/models/score.dart';
import 'package:flutter/material.dart'; // Importing Flutter material design
import 'package:flappygame/constants.dart'; // Importing constants for the game
import 'components/components.dart'; // Importing game components

class FlappyGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird; // The bird character
  late Background background; // The game background
  late Ground ground; // The ground in the game
  late PipeManager pipeManager; // Manages the pipes
  late ScoreText scoreText; // Displays the score
  late PauseButton pauseButton; // Button to pause the game
  late MuteButton muteButton; // Button to mute the game
  late HighestScore highestScore; // Displays the highest score
  bool isPaused = false; // Indicates if the game is paused
  bool isGameOver = false; // Indicates if the game is over
  bool isReady = true; // For "Get Ready" screen
  int score = 0; // Player's score

  @override
  Future<void> onLoad() async {
    super.onLoad(); // Call the parent class's onLoad method
    await Flame.images.load('message.png'); // Load the "Get Ready" image
    background = Background(size); // Initialize the background
    bird = Bird(); // Initialize the bird
    ground = Ground(); // Initialize the ground
    pipeManager = PipeManager(); // Initialize the pipe manager
    scoreText = ScoreText(); // Initialize the score text
    pauseButton = PauseButton(this); // Initialize the pause button
    highestScore = HighestScore(); // Initialize the highest score
    muteButton = MuteButton(this); // Initialize the mute button

    // Add all components to the game
    add(background);
    add(bird);
    add(ground);
    add(pipeManager);
    add(scoreText);
    add(pauseButton);
    add(muteButton);
    add(highestScore);
  }

  @override
  void onTap() {
    // Handle tap events
    if (isReady) {
      isReady = false; // Start the game when tapped
      return;
    }

    if (!isPaused && !isGameOver) {
      bird.flap(); // Make the bird flap if the game is active
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas); // Call the parent class's render method

    if (isReady) {
      final image =
          Flame.images.fromCache('message.png'); // Get the "Get Ready" image
      final imageSize = Vector2(
          image.width.toDouble(), image.height.toDouble()); // Get image size
      final position = Vector2(
        (size.x - imageSize.x) / 2, // Center the image horizontally
        (size.y - imageSize.y) / 3, // Position the image vertically
      );
      canvas.drawImage(
          image, position.toOffset(), Paint()); // Draw the image on the canvas
    }
  }

  @override
  void update(double dt) {
    super.update(dt); // Call the parent class's update method

    // Prevent bird from dropping until the "Get Ready" screen is tapped
    if (isReady) {
      bird.velocity = 0; // Keep the bird stationary
      return; // Skip further updates if the game is not started
    }

    if (bird.isColliding && !isGameOver) {
      gameOver(); // Trigger game over if the bird collides
    }
  }

  /// Increment the score
  void updateScore() {
    score++; // Increase the score by 1
  }

  /// Pause the game and show pause dialog
  void pauseGame() {
    if (isPaused || isGameOver) {
      return; // Do nothing if already paused or game over
    }
    isPaused = true; // Set the game to paused
    pauseEngine(); // Pause the game engine

    // Show a dialog to inform the player that the game is paused
    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for the dialog
        ),
        title: const Center(
          child: Text(
            'Game Paused',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        content: const Text(
          'Take a breather!', // Message in the dialog
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                isPaused = false; // Unpause the game
                resumeEngine(); // Resume the game engine
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded button
                ),
              ),
              child: const Text(
                'Resume', // Button text
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle game over logic
  void gameOver() async {
    isGameOver = true; // Set the game to over
    pauseEngine(); // Pause the game engine
    // Fetch the highest score from the database
    final highestScore = await AppDatabase.instance.getHighestScore();
    // Insert the score only if it's higher than the current highest
    if (score > highestScore) {
      await AppDatabase.instance.insertScoreAndUpdateRanks(
        Score(score: score, date: DateTime.now()),
      );
    }
    // Show a dialog to inform the player that the game is over
    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Rounded corners for the dialog
        ),
        title: const Center(
          child: Text(
            'Game Over',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/gameover.png'), // Show game over image
            const SizedBox(height: 20),
            Text(
              'Your Score: $score', // Display the player's score
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Better luck next time!', // Message for the player
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                restartEngine(); // Restart the game engine
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent, // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded button
                ),
              ),
              child: const Text(
                'Restart', // Button text
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reset game state and restart engine
  void restartEngine() {
    isGameOver = false; // Reset game over state
    isReady = true; // Set game to ready state
    score = 0; // Reset score
    bird.position = Vector2(birdStartX, birdStartY); // Reset bird position
    bird.velocity = 0; // Reset bird velocity
    ground.position.x = 0; // Reset ground position
    children
        .whereType<Pipe>()
        .forEach((pipe) => pipe.removeFromParent()); // Remove all pipes
    resumeEngine(); // Resume the game engine
  }
}
