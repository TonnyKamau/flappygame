import 'dart:async';

import 'package:flame/components.dart';
import 'package:flappygame/game.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent with HasGameRef<FlappyGame> {
  ScoreText()
      : super(
          text: '0',
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey.shade800,
            ),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );
  }

  @override
  void update(double dt) {
    final newScore = gameRef.score.toString();
    if (newScore != text) {
      text = newScore;
    }
    super.update(dt);
  }
}
