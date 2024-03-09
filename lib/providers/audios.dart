// import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'audio.dart';
// import 'package:http/http.dart' as http;
// import 'package:uuid/uuid.dart';
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:audio_book_app/models/http_exception.dart';

class Audios with ChangeNotifier {
  final List<Audio> _audios = [
    Audio(
        audioId: 1,
        bookId: 'b1',
        userId: 'u1',
        audioFile:
            "https://myaudiobookapp.s3.eu-central-1.amazonaws.com/the_frog_prince_part1.mp3",
        audioName: "the_frog_prince_part1.mp3"),
    Audio(
        audioId: 2,
        bookId: 'b1',
        userId: 'u1',
        audioFile:
            "https://myaudiobookapp.s3.eu-central-1.amazonaws.com/the_frog_prince_part2.mp3",
        audioName: "the_frog_prince_part2.mp3"),
    Audio(
        audioId: 3,
        bookId: 'b1',
        userId: 'u1',
        audioFile:
            "https://myaudiobookapp.s3.eu-central-1.amazonaws.com/the_frog_prince_part3.mp3",
        audioName: "the_frog_prince_part3.mp3"),
  ];

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

  void playAudio(int index) async {
    final audIndex = _audios.indexWhere((aud) => aud.audioId == index + 1);
    final audioUrl = _audios[audIndex].audioFile;
    print('index is: $index');
    print('audIndex is: $audIndex');
    print('audioUrl is: $audioUrl');
    await _audioPlayer.stop();
    await _audioPlayer.play(audioUrl);
    _isPlaying = true;
    _currentAudioIndex = index;
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

/*


S E T T E R S


*/

  set currentAudioIndex(int? newIndex) {
    //update current Audio Index
    _currentAudioIndex = newIndex;

    if (newIndex != null) {
      playAudio(newIndex);
    }

    //update UI
    notifyListeners();
  }

  Audio findById(String id) {
    return audios.firstWhere((audio) => audio.audioId == id);
  }

//   Future<void> fetchAndSetEvents() async {
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/');
//     final response = await http.get(url);
//     final decoded_response = json.decode(response.body);
//     final int number_of_objects = decoded_response.length;
//     print(json.decode(response.body));
//     print(response.body.length);
//     final List<Event> loadedEvent = [];
//     final extractedData = json.decode(response.body);
//     // print(extractedData["name"]);
//     if (extractedData == null) {
//       return;
//     }
//     // extractedData.forEach((eventId, eventData) {
//     int i = 0;
//     while (i < number_of_objects) {
//       loadedEvent.add(Event(
//         event_id: extractedData[i]['event_id'],
//         title: extractedData[i]['title'],
//         eventdate: extractedData[i]['eventdate'],
//         time: extractedData[i]['time'],
//         imageUrl: extractedData[i]['imageUrl'],
//         location: extractedData[i]['location'],
//         location_url: extractedData[i]['location_url'],
//         host: extractedData[i]['host'],
//       ));
//       i++;
//     }

//     _events = loadedEvent.reversed.toList();
//     notifyListeners();
//   }

//   // final String baseUrl = "http://127.0.0.1:8000/api/v1/events/";

//   // void _fetchDataFromTheServer() async {
//   //   final Dio dio = Dio();
//   // }

// // http://127.0.0.1:8000/api/v1/events/
//   Future<void> addEvent(Event event) async {
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/{event_id}');
//     var uuid = Uuid();
//     try {
//       final response = await http.post(url,
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: json.encode({
//             // 'event_id': uuid.v4(),
//             'title': event.title,
//             'eventdate': event.eventdate,
//             'time': event.time,
//             'imageUrl': event.imageUrl,
//             'location': event.location,
//             'location_url': event.location_url,
//             'host': event.host,
//           }));
//       print(json.decode(response.body));
//       final newEvent = Event(
//         event_id: json.decode(response.body)['event_id'],
//         title: event.title,
//         eventdate: event.eventdate,
//         time: event.time,
//         imageUrl: event.imageUrl,
//         location: event.location,
//         location_url: event.location_url,
//         host: event.host,
//       );
//       _events.add(newEvent);
//       notifyListeners();
//     } catch (error) {
//       print(error);
//       throw (error);
//     }
//   }

//   Future<void> updateEvent(String id, Event newEvent) async {
//     final evIndex = _events.indexWhere((ev) => ev.event_id == id);
//     final event_id = _events[evIndex].event_id;
//     if (evIndex != null) {
//       final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/$event_id');
//       await http.put(url,
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//           body: json.encode({
//             'title': newEvent.title,
//             'eventdate': newEvent.eventdate,
//             'time': newEvent.time,
//             'imageUrl': newEvent.imageUrl,
//             'location': newEvent.location,
//             'location_url': newEvent.location_url,
//             'host': newEvent.host
//           }));
//       print(event_id);
//       _events[evIndex] = newEvent;
//       notifyListeners();
//     } else {
//       print('...');
//     }
//   }

//   Future<void> deleteEvent(String id) async {
//     final evIndex = _events.indexWhere((ev) => ev.event_id == id);
//     final event_id = _events[evIndex].event_id;
//     var existingEvent = _events[evIndex];
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/events/$event_id');
//     _events.removeAt(evIndex);
//     notifyListeners();
//     final response = await http.delete(url);
//     if (response.statusCode >= 400) {
//       _events.insert(evIndex, existingEvent);
//       notifyListeners();
//       throw HttpException('Could not delete product.');
//     }
//     existingEvent = null;
//   }
}
