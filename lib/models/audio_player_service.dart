// audio_player_service.dart

import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentIndex = -1;

  bool get isPlaying => _isPlaying;
  int get currentIndex => _currentIndex;

  Future<void> playAudio(String audioUrl, int index) async {
    await audioPlayer.stop();
    await audioPlayer.play(audioUrl);
    _isPlaying = true;
    _currentIndex = index;
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> resumeAudio() async {
    await audioPlayer.resume();
    _isPlaying = true;
    // _currentIndex = index;
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    _isPlaying = false;
    _currentIndex = -1;
  }
}

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';

// class AudioPlayerService extends ChangeNotifier {
//   final audioPlayer = AudioPlayer();
//   bool _isPlaying = false;
//   int _currentIndex = -1;

//   bool get isPlaying => _isPlaying;
//   int get currentIndex => _currentIndex;

//   Future<void> playAudio(String audioUrl, int index) async {
//     await audioPlayer.stop();
//     await audioPlayer.play(audioUrl);
//     _isPlaying = true;
//     _currentIndex = index;
//     notifyListeners(); // Notify listeners of the change
//   }

//   Future<void> pauseAudio() async {
//     await audioPlayer.pause();
//     _isPlaying = false;
//     notifyListeners(); // Notify listeners of the change
//   }

//   Future<void> resumeAudio() async {
//     await audioPlayer.resume();
//     _isPlaying = true;
//     // _currentIndex = index;
//     notifyListeners(); // Notify listeners of the change
//   }

//   Future<void> stopAudio() async {
//     await audioPlayer.stop();
//     _isPlaying = false;
//     _currentIndex = -1;
//     notifyListeners(); // Notify listeners of the change
//   }
// }
