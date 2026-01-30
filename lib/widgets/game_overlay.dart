import 'package:flutter/material.dart';
import '../game.dart';
import '../constants.dart';
import '../components/soundmanager.dart';

class GameOverlay extends StatefulWidget {
  final FlappyGame game;

  const GameOverlay({super.key, required this.game});

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  bool isMuted = SoundManager.isMuted;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Right Buttons
        Positioned(
          top: GameConfig.buttonMargin,
          right: GameConfig.buttonMargin,
          child: Column(
            children: [
              // Pause Toggle
              _buildGlassButton(
                onPressed: () {
                  if (widget.game.isPaused) {
                    setState(() {}); // Refresh local state
                    widget.game.isPaused = false;
                    // Note: If using dialogs, user might need to close it
                  } else {
                    widget.game.pauseGame();
                    setState(() {});
                  }
                },
                child: Text(
                  widget.game.isPaused ? '▶' : 'II',
                  style: TextStyle(
                    fontSize: GameConfig.buttonFontSize * 0.8,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Mute Toggle
              _buildGlassButton(
                onPressed: () {
                  setState(() {
                    SoundManager.toggleMute();
                    isMuted = SoundManager.isMuted;
                  });
                },
                child: Text(
                  isMuted ? '🔇' : '🔊',
                  style: TextStyle(
                    fontSize: GameConfig.buttonFontSize * 0.7,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassButton(
      {required VoidCallback onPressed, required Widget child}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: GameConfig.buttonSize,
        height: GameConfig.buttonSize,
        decoration: BoxDecoration(
          color: GameConfig.glassColor,
          borderRadius: BorderRadius.circular(GameConfig.buttonRadius),
          border: Border.all(color: GameConfig.glassBorderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
