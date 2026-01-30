import 'dart:ui' as ui;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappygame/database/database.dart';
import 'package:flappygame/models/score.dart';
import 'package:flutter/material.dart';
import 'package:flappygame/constants.dart';
import 'components/components.dart';

class FlappyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreText scoreText;
  late HighestScore highestScore;
  bool isPaused = false;
  bool isGameOver = false;
  bool isReady = true;
  int score = 0;
  bool _isGameOverProcessing = false;

  // Cached rendering objects for performance
  final Paint _readyPaint = Paint()..filterQuality = ui.FilterQuality.medium;
  Rect? _readySrcRect;
  Rect? _readyDestRect;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    GameConfig.init(size);

    // Preload all assets in parallel to prevent stutter during gameplay
    // We use the game instance 'images' cache
    await images.loadAll([
      'message.png',
      'bird.png',
      'pipe_top.png',
      'pipe_bottom.png',
      'base.png',
      'background.png',
    ]);

    _initReadyScreenDimensions();
    background = Background(size);
    bird = Bird();
    ground = Ground();
    pipeManager = PipeManager();
    scoreText = ScoreText();
    highestScore = HighestScore();

    add(background);
    add(bird);
    add(ground);
    add(pipeManager);
    add(scoreText);
    add(highestScore);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    GameConfig.init(size);
    // Guard against calling before assets are loaded
    if (images.containsKey('message.png')) {
      _initReadyScreenDimensions();
    }
  }

  void _initReadyScreenDimensions() {
    if (!images.containsKey('message.png')) return;
    final image = images.fromCache('message.png');
    final imgW = image.width.toDouble();
    final imgH = image.height.toDouble();

    // Scale the image to fit ~60% of screen width
    final targetWidth = size.x * 0.6;
    final scale = targetWidth / imgW;
    final targetHeight = imgH * scale;

    _readyDestRect = Rect.fromLTWH(
      (size.x - targetWidth) / 2,
      (size.y - targetHeight) / 3,
      targetWidth,
      targetHeight,
    );
    _readySrcRect = Rect.fromLTWH(0, 0, imgW, imgH);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super
        .onTapDown(event); // Crucial: Allow components to handle their own taps

    if (isReady) {
      isReady = false;
      return;
    }

    if (!isPaused && !isGameOver) {
      bird.flap();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isReady && _readySrcRect != null && _readyDestRect != null) {
      if (images.containsKey('message.png')) {
        final image = images.fromCache('message.png');
        canvas.drawImageRect(
          image,
          _readySrcRect!,
          _readyDestRect!,
          _readyPaint,
        );
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isReady) {
      bird.velocity = 0;
      return;
    }
  }

  void updateScore() {
    score++;
  }

  void pauseGame() {
    if (isPaused || isGameOver) {
      return;
    }
    isPaused = true;
    // Removed pauseEngine() to keep UI buttons interactive

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: GameConfig.primaryColor, width: 2),
        ),
        title: const Center(
          child: Text(
            'PAUSED',
            style: TextStyle(
              color: GameConfig.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pause_circle_filled,
                size: 64, color: GameConfig.primaryColor),
            SizedBox(height: 16),
            Text(
              'Time for a quick break!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [GameConfig.primaryColor, Color(0xFF64B5F6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: GameConfig.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  isPaused = false;
                  // Removed resumeEngine()
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void gameOver() async {
    if (_isGameOverProcessing || isGameOver) {
      return;
    }
    _isGameOverProcessing = true;
    isGameOver = true;
    // Removed pauseEngine()

    final currentHighest = await AppDatabase.instance.getHighestScore();
    if (score > currentHighest) {
      await AppDatabase.instance.insertScoreAndUpdateRanks(
        Score(score: score, date: DateTime.now()),
      );
    }

    highestScore.refreshScore();

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.95),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: GameConfig.dangerColor, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Image.asset('assets/images/gameover.png', height: 120),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('SCORE',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey)),
                  Text(
                    '$score',
                    style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Better luck next time!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                    colors: [GameConfig.accentColor, Color(0xFF00C853)]),
                boxShadow: [
                  BoxShadow(
                    color: GameConfig.accentColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  restartEngine();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'RESTART',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void restartEngine() {
    isGameOver = false;
    _isGameOverProcessing = false;
    isReady = true;
    isPaused = false;
    score = 0;
    bird.position = Vector2(GameConfig.birdStartX, GameConfig.birdStartY);
    bird.velocity = 0;
    ground.position.x = 0;
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
  }
}
