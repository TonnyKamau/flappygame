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
              color: Colors.grey.shade800,
            ),
          ),
        );

  @override
  FutureOr<void> onLoad() async {
    position = Vector2(
      (game.size.x - size.x) / 2,
      game.size.y - size.y - GameConfig.groundHeight - GameConfig.buttonMargin,
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(
      (size.x - this.size.x) / 2,
      size.y - this.size.y - GameConfig.groundHeight - GameConfig.buttonMargin,
    );
  }

  @override
  void update(double dt) {
    final newScore = game.score.toString();
    if (newScore != text) {
      text = newScore;
    }
    super.update(dt);
  }
}
