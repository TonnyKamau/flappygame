import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _wingPlayer = AudioPlayer();
  static final AudioPlayer _diePlayer = AudioPlayer();
  static final AudioPlayer _hitPlayer = AudioPlayer();
  static final AudioPlayer _pointPlayer = AudioPlayer();
  static bool isMuted = false; // Global mute flag

  static void playWingSound() {
    if (!isMuted) {
      _wingPlayer
          .stop()
          .then((_) => _wingPlayer.play(AssetSource('audio/wing.wav')));
    }
  }

  static void playDieSound() {
    if (!isMuted) {
      _diePlayer.play(AssetSource('audio/die.wav'));
    }
  }

  static void playHitSound() {
    if (!isMuted) {
      _hitPlayer.play(AssetSource('audio/hit.wav'));
    }
  }

  static void playPointSound() {
    if (!isMuted) {
      _pointPlayer.play(AssetSource('audio/point.wav'));
    }
  }

  static void toggleMute() {
    isMuted = !isMuted;
    if (isMuted) {
      stopAllSounds();
    }
  }

  static void stopAllSounds() {
    _wingPlayer.stop();
    _diePlayer.stop();
    _hitPlayer.stop();
    _pointPlayer.stop();
  }
}
