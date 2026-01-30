import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappygame/constants.dart';
import 'package:flappygame/game.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameReference<FlappyGame> {
  ScoreText()
      : super(
          text: '0',
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: GameConfig.scoreFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(2, 4),
                ),
              ],
            ),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    priority = 100;
    position = Vector2(
      (game.size.x - size.x) / 2,
      game.size.y * 0.15, // Move to top center
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(
      (size.x - this.size.x) / 2,
      size.y * 0.15,
    );
  }

  @override
  void update(double dt) {
    final newScore = game.score.toString();
    if (newScore != text) {
      text = newScore;
      // Re-center if text length changes
      position.x = (game.size.x - size.x) / 2;
    }
    super.update(dt);
  }
}
