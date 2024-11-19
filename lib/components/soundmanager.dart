import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _wingPlayer = AudioPlayer();
  static final AudioPlayer _diePlayer = AudioPlayer();
  static final AudioPlayer _hitPlayer = AudioPlayer();
  static final AudioPlayer _pointPlayer = AudioPlayer();
  static bool isMuted = false; // Global mute flag

  static Future<void> playWingSound() async {
    if (!isMuted) {
      await _wingPlayer.play(AssetSource('audio/wing.wav'));
    }
  }

  static Future<void> playDieSound() async {
    if (!isMuted) {
      await _diePlayer.play(AssetSource('audio/die.wav'));
    }
  }

  static Future<void> playHitSound() async {
    if (!isMuted) {
      await _hitPlayer.play(AssetSource('audio/hit.wav'));
    }
  }

  static void playPointSound() async {
    if (!isMuted) {
      await _pointPlayer.play(AssetSource('audio/point.wav'));
    }
  }

  static void toggleMute() {
    isMuted = !isMuted;
  }

  static void stopAllSounds() {
    _wingPlayer.stop();
    _diePlayer.stop();
    _hitPlayer.stop();
    _pointPlayer.stop();
  }
}
