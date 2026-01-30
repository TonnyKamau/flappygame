import 'package:flame/components.dart';
import 'package:flutter/material.dart';

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
  static late double buttonRadius;
  static late double buttonFontSize;
  static late double scoreFontSize;
  static late double highScoreFontSize;
  static late double highScoreBoxWidth;
  static late double highScoreBoxHeight;

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color accentColor = Color(0xFF00E676);
  static const Color dangerColor = Color(0xFFFF5252);
  static const Color glassColor = Color(0x99FFFFFF);
  static const Color glassBorderColor = Color(0x33000000);

  static void init(Vector2 size) {
    screenWidth = size.x;
    screenHeight = size.y;

    // Bird sizing
    birdWidth = screenWidth * 0.10; // Slightly larger for better visibility
    birdHeight = birdWidth * 0.75;
    birdStartX = screenWidth * 0.20;
    birdStartY = screenHeight * 0.40;

    // Physics scaled to screen height
    gravity = screenHeight * 1.5;
    jumpHeight = screenHeight * -0.50;

    // Ground
    groundHeight = screenHeight * 0.15;
    groundSpeed = screenWidth * 0.25;

    // Pipes
    pipeWidth = screenWidth * 0.14;
    pipeSpeed = screenWidth * 0.25;
    pipeGap = screenHeight * 0.24;
    minPipeHeight = screenHeight * 0.10;
    pipeSpawnInterval = 1.8;

    // UI elements
    buttonMargin = 20.0;
    buttonSize = 60.0; // Increased from 48
    buttonRadius = 16.0;
    buttonFontSize = 32.0; // Increased from 24
    scoreFontSize = screenHeight * 0.09;
    highScoreFontSize = 16.0;
    highScoreBoxWidth = screenWidth * 0.50;
    highScoreBoxHeight = 50.0; // Increased from 40
  }
}
