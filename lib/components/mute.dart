import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import 'components.dart';

class MuteButton extends PositionComponent with TapCallbacks {
  final FlappyGame game;
  late final TextComponent muteText;
  final Paint _bgPaint;
  bool isMuted = false;

  MuteButton(this.game)
      : _bgPaint = Paint()..color = Colors.white.withOpacity(0.7) {
    size = Vector2(40, 40);
    position = Vector2(game.size.x - size.x - 40, 90);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    muteText = TextComponent(
      text: '🔇',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black,
        ),
      ),
    );

    muteText.position = Vector2(
      (size.x - muteText.size.x) / 2,
      (size.y - muteText.size.y) / 2,
    );

    add(muteText);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(
      size.x - this.size.x - 40,
      90,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    SoundManager.toggleMute();
    isMuted = !isMuted;
    muteText.text = isMuted ? '🔊' : '🔇';
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      _bgPaint,
    );
    super.render(canvas);
  }
}
