import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentIndex = -1;

  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;

  Future<void> playAudio(String audioUrl, int index) async {
    await audioPlayer.stop();
    await audioPlayer.play(audioUrl);
    _isPlaying = true;
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> resumeAudio() async {
    await audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    _isPlaying = false;
    _currentIndex = -1;
    notifyListeners();
  }
}
