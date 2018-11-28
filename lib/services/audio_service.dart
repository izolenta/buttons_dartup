import 'dart:async';

import 'package:audioplayers/audio_cache.dart';

class AudioService {

  AudioCache audioPlugin = AudioCache();

  AudioService() {
    _loadSounds();
  }

  Future playButtonSound() async {
    audioPlugin.play('sounds/switch1.wav');
  }

  Future _loadSounds() async {
    await audioPlugin.loadAll(['sounds/switch1.wav']);
    print("Sounds are loaded");
  }
}