// import 'dart:io';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'audio.dart';
import 'package:http/http.dart' as http;

class Audios with ChangeNotifier {
  List<Audio> _audios = [];

  // current song playing index
  int? _currentAudioIndex;

/*

A U D I O P L A Y E R

*/

// audio player

  final AudioPlayer _audioPlayer = AudioPlayer();

// durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

// constructor
  Audios() {
    listenToDuration();
  }

// initially not playing
  bool _isPlaying = false;

// play the audio

  void playAudio() async {
    final String url = _audios[_currentAudioIndex!].audioFile;
    await _audioPlayer.stop(); // stop the current song
    await _audioPlayer.play(url); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

// pause current song
  void pauseAudio() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

// resume playing
  void resumeAudio() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

// pause or resume
  void pauseOrResumeAudio() async {
    if (_isPlaying) {
      pauseAudio();
    } else {
      resumeAudio();
    }
    notifyListeners();
  }

// seek to a specific position in the current audio
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

// play next song
  void playNextAudio() {
    if (_currentAudioIndex != null) {
      if (_currentAudioIndex! < _audios.length - 1) {
        // go to the next audio if it's not the last audio
        currentAudioIndex = _currentAudioIndex! + 1;
      } else {
        // if it's the last song, loop back to the first song
        currentAudioIndex = 0;
      }
    }
  }

// play previous song

  void playPreviousAudio() {
    // if more than 2 seconds have passed, restart the current audio
    if (_currentDuration.inSeconds > 2) {
      // if it's within first 2 second of the audio, go to previous song
      seek(Duration.zero);
    } else {
      if (_currentAudioIndex! > 0) {
        currentAudioIndex = _currentAudioIndex! - 1;
      } else {
        // if it's the first song, loop back to last song
        currentAudioIndex = _audios.length - 1;
      }
    }
  }

// listen to duration
  void listenToDuration() {
    // listen for total Duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current Duration
    _audioPlayer.onAudioPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerCompletion.listen((event) {});
  }

// dispose audio player

/*

G E T T E R S


*/

  // List<Audio> get items {
  //   return [...audios];
  // }
  List<Audio> get audios => _audios;
  int? get currentAudioIndex => _currentAudioIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  // String getAudioFilesById(int audioId) {
  //   final audio = _audios.firstWhere((audio) => audio.audioId == audioId,
  //       orElse: () => throw Exception('Audio ID not found'));
  //   return audio.audioFile;
  // }

/*


S E T T E R S


*/

  set currentAudioIndex(int? newIndex) {
    //update current Audio Index
    _currentAudioIndex = newIndex;

    if (newIndex != null) {
      playAudio();
    }

    //update UI
    notifyListeners();
  }

  Audio findById(int id) {
    return audios.firstWhere((audio) => audio.audioId == id);
  }

  Future<void> fetchAndSetAudios(String? token) async {
    String tokenString = token!;

    final url = Uri.parse('http://127.0.0.1:8000/api/v1/audios/');

    Map<String, String>? headers = {
      'Authorization': 'Bearer $tokenString',
      'Content-Type': 'application/json',
    };

    // I modified the http.dart to Map<String, String?>? for it to work
    final response = await http.get(url, headers: headers);
    final decodedResponse = json.decode(response.body);
    final int numberOfObjects = decodedResponse.length;
    final List<Audio> loadedBook = [];
    final extractedData = json.decode(response.body);
    if (extractedData == null) {
      return;
    }

    int i = 0;
    while (i < numberOfObjects) {
      loadedBook.add(Audio(
          audioId: extractedData[i]['audio_id'],
          bookId: extractedData[i]['book_id'],
          userId: extractedData[i]['user_id'],
          audioName: extractedData[i]['audio_name'],
          audioFile: extractedData[i]['audio_file'],
          bookImage: extractedData[i]['book_image']));
      i++;
    }

    _audios = loadedBook.toList();

    notifyListeners();
  }

  Future<void> addAudio(int bookId, String audioName, String? token) async {
    String tokenString = token!;

    final url = Uri.parse(
        'http://127.0.0.1:8000/api/v1/audios/text_to_audio/$bookId?audio_name=$audioName');

    Map<String, String>? headers = {
      'Authorization': 'Bearer $tokenString',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            "book_id": bookId,
            "audio_name": audioName,
          }));
      final responseData = json.decode(response.body);
      final newAudio = Audio(
        audioId: responseData['audio_id'],
        bookId: responseData['book_id'],
        userId: responseData['user_id'],
        audioFile: responseData['audio_file'],
        bookImage: responseData['book_image'],
        audioName: responseData['audio_name'],
      );
      _audios.add(newAudio);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAudio(int id) async {
    final audioIndex = _audios.indexWhere((audio) => audio.audioId == id);
    final audioId = _audios[audioIndex].audioId;
    var existingAudio = _audios[audioIndex];
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/Books/$audioId');
    _audios.removeAt(audioIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _audios.insert(audioIndex, existingAudio);
      notifyListeners();
      throw Exception('Could not delete product.');
    }
    // existingBook = null;
  }

  Future<void> deleteAll(int bookId, String? token) async {
    String tokenString = token!;

    Map<String, String>? headers = {
      'Authorization': 'Bearer $tokenString',
      'Content-Type': 'application/json',
    };
    final url =
        Uri.parse('http://127.0.0.1:8000/api/v1/audios/Delete_All/$bookId');

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode >= 400) {
        throw Exception('Could not delete audio.');
      }
    } catch (e) {
      rethrow;
    }
  }
}
