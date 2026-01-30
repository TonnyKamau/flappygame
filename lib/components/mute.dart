import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flappygame/constants.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import 'components.dart';

class MuteButton extends PositionComponent with TapCallbacks {
  final FlappyGame game;
  late final TextComponent muteText;
  bool isMuted = false;

  MuteButton(this.game) {
    size = Vector2(GameConfig.buttonSize, GameConfig.buttonSize);
    position = Vector2(
      game.size.x - size.x - GameConfig.buttonMargin,
      GameConfig.buttonMargin * 2 + GameConfig.buttonSize,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;

    isMuted = SoundManager.isMuted;

    muteText = TextComponent(
      text: isMuted ? '🔇' : '🔊',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: GameConfig.buttonFontSize * 0.7,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );

    muteText.anchor = Anchor.center;
    muteText.position = size / 2;
    add(muteText);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = Vector2(GameConfig.buttonSize, GameConfig.buttonSize);
    position = Vector2(
      size.x - this.size.x - GameConfig.buttonMargin,
      GameConfig.buttonMargin * 2 + GameConfig.buttonSize,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    SoundManager.toggleMute();
    isMuted = SoundManager.isMuted;
    muteText.text = isMuted ? '🔇' : '🔊';
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.buttonRadius)),
      Paint()..color = GameConfig.glassColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(GameConfig.buttonRadius)),
      Paint()
        ..color = GameConfig.glassBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    super.render(canvas);
  }
}
