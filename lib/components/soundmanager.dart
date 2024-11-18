import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playWingSound() async {
    await _audioPlayer.play(AssetSource('audio/wing.wav'));
  }

  static Future<void> playDieSound() async {
    await _audioPlayer.play(AssetSource('audio/die.wav'));
  }

  static Future<void> playHitSound() async {
    await _audioPlayer.play(AssetSource('audio/hit.wav'));
  }
}
