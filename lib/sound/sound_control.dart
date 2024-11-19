import 'package:flutter_bloc/flutter_bloc.dart';

class SoundControl extends Cubit<bool> {
  SoundControl() : super(false);

  void toggleMute() {
    emit(!state);
  }
}
