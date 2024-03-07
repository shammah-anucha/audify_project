import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:audio_book_app/widgets/playlist.dart';
import 'package:audio_book_app/models/audio_player_service.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);
  static const routeName = '/audioplayerscreen';

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayerService _audioPlayerService;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayerService =
        Provider.of<AudioPlayerService>(context, listen: false);

    // Listen to states: playing, paused, stopped
    _audioPlayerService.audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          isPlaying = state == PlayerState.PLAYING;
        });
      }
    });

    /// Listen to audio duration
    _audioPlayerService.audioPlayer.onDurationChanged.listen((newDuration) {
      setState(
        () {
          duration = newDuration;
        },
      );
    });

    /// Listen to audio duration
    _audioPlayerService.audioPlayer.onAudioPositionChanged
        .listen((newPosition) {
      setState(
        () {
          position = newPosition;
        },
      );
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    final audiosData = Provider.of<Audios>(context);
    final audios = audiosData.items;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Library'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Stack(
            children: [
              Positioned(
                height: 200,
                width: 200,
                top: 10,
                left: 115,
                child: Image.asset('assets/output.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Positioned(
                width: 320,
                top: 66,
                left: 60,
                child: Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayerService.audioPlayer.seek(position);
                    await _audioPlayerService.resumeAudio();
                    setState(() {});
                  },
                ),
              ),
              Positioned(
                width: 320,
                top: 100,
                left: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(position),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        formatTime(duration - position),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                width: 300,
                top: 115,
                left: 115,
                child: Row(
                  children: [
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.fast_rewind,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (isPlaying) {
                          await _audioPlayerService.pauseAudio();
                        } else {
                          await _audioPlayerService.resumeAudio();
                        }
                        setState(() {
                          // Update the UI by triggering a rebuild
                        });
                      },
                    ),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.fast_forward,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: audios[i],
                child: PlayList(),
              ),
              itemCount: audios.length,
            ),
          ),
        ],
      ),
    );
  }
}
