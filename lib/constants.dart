import 'dart:math';
import 'package:flame/components.dart';

class GameConfig {
  static late double screenWidth;
  static late double screenHeight;

  // Bird
  static late double birdWidth;
  static late double birdHeight;
  static late double birdStartX;
  static late double birdStartY;

  // Physics
  static late double gravity;
  static late double jumpHeight;

  // Ground
  static late double groundHeight;
  static late double groundSpeed;

  // Pipes
  static late double pipeWidth;
  static late double pipeSpeed;
  static late double pipeGap;
  static late double minPipeHeight;
  static late double pipeSpawnInterval;

  // UI
  static late double buttonSize;
  static late double buttonMargin;
  static late double buttonFontSize;
  static late double scoreFontSize;
  static late double highScoreFontSize;
  static late double highScoreBoxWidth;
  static late double highScoreBoxHeight;

  static void init(Vector2 size) {
    screenWidth = size.x;
    screenHeight = size.y;

    // Bird sizing
    birdWidth = screenWidth * 0.08;
    birdHeight = screenHeight * 0.05;
    birdStartX = screenWidth * 0.15;
    birdStartY = screenHeight * 0.30;

    // Physics scaled to screen height so gameplay feels consistent
    gravity = screenHeight * 1.2;
    jumpHeight = screenHeight * -0.45;

    // Ground
    groundHeight = screenHeight * 0.12;
    groundSpeed = screenWidth * 0.15;

    // Pipes
    pipeWidth = screenWidth * 0.08;
    pipeSpeed = screenWidth * 0.15;
    pipeGap = screenHeight * 0.22;
    minPipeHeight = screenHeight * 0.08;
    pipeSpawnInterval = 2.0;

    // UI elements
    buttonSize = max(36.0, screenWidth * 0.06);
    buttonMargin = screenWidth * 0.03;
    buttonFontSize = buttonSize * 0.75;
    scoreFontSize = screenHeight * 0.05;
    highScoreFontSize = screenHeight * 0.035;
    highScoreBoxWidth = screenWidth * 0.35;
    highScoreBoxHeight = screenHeight * 0.07;
  }
}
