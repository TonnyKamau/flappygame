import 'package:flappygame/game.dart';
import 'package:flappygame/sound/sound_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuteButton extends StatelessWidget {
  final FlappyGame game;

  const MuteButton(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundControl, bool>(
      builder: (context, isMuted) {
        return Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              context.read<SoundControl>().toggleMute();
            },
          ),
        );
      },
    );
  }
}
