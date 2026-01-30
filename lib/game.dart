import 'dart:ui' as ui;

import 'package:flame/events.dart';
import 'package:flame/flame.dart';
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
  late PauseButton pauseButton;
  late MuteButton muteButton;
  late HighestScore highestScore;
  bool isPaused = false;
  bool isGameOver = false;
  bool isReady = true;
  int score = 0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    GameConfig.init(size);

    await Flame.images.load('message.png');
    background = Background(size);
    bird = Bird();
    ground = Ground();
    pipeManager = PipeManager();
    scoreText = ScoreText();
    pauseButton = PauseButton(this);
    highestScore = HighestScore();
    muteButton = MuteButton(this);

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
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    GameConfig.init(size);
  }

  @override
  void onTapDown(TapDownEvent event) {
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

    if (isReady) {
      final image = Flame.images.fromCache('message.png');
      final imgW = image.width.toDouble();
      final imgH = image.height.toDouble();

      // Scale the image to fit ~60% of screen width
      final targetWidth = size.x * 0.6;
      final scale = targetWidth / imgW;
      final targetHeight = imgH * scale;

      final destRect = Rect.fromLTWH(
        (size.x - targetWidth) / 2,
        (size.y - targetHeight) / 3,
        targetWidth,
        targetHeight,
      );
      final srcRect = Rect.fromLTWH(0, 0, imgW, imgH);

      canvas.drawImageRect(
        image,
        srcRect,
        destRect,
        Paint()..filterQuality = ui.FilterQuality.medium,
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isReady) {
      bird.velocity = 0;
      return;
    }

    if (bird.isColliding && !isGameOver) {
      gameOver();
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
    pauseEngine();

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
          'Take a breather!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                isPaused = false;
                resumeEngine();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Resume',
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

  void gameOver() async {
    isGameOver = true;
    pauseEngine();

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
            Image.asset('assets/images/gameover.png'),
            const SizedBox(height: 20),
            Text(
              'Your Score: $score',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Better luck next time!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                restartEngine();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Restart',
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

  void restartEngine() {
    isGameOver = false;
    isReady = true;
    score = 0;
    bird.position = Vector2(GameConfig.birdStartX, GameConfig.birdStartY);
    bird.velocity = 0;
    ground.position.x = 0;
    children
        .whereType<Pipe>()
        .forEach((pipe) => pipe.removeFromParent());
    resumeEngine();
  }
}
