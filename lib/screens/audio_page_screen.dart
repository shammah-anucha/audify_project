import 'package:audio_book_app/providers/audio.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/widgets/neu_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPage extends StatelessWidget {
  final List<Audio> filteredAudios;

  const AudioPage({super.key, required this.filteredAudios});

  // convert duration into min:sec
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
    return Consumer<Audios>(builder: (context, value, child) {
      // get playlist
      // Filter audios based on the bookId
      final audios = value.audios;
      // get current song index
      final currentAudio = audios[value.currentAudioIndex ?? 0];

      // return Scaffold UI
      return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('PlayList'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                // album artwork
                NeuBox(
                    child: Column(
                  children: [
                    // image
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(currentAudio.bookImage)),
                    ),

                    // audio name
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          // audio name
                          SizedBox(
                            width: 300,
                            child: Text(
                              currentAudio.audioName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
                const SizedBox(
                  height: 20,
                ),

                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 0),
                  ),
                  child: Slider(
                    min: 0,
                    max: value.totalDuration.inSeconds.toDouble(),
                    value: value.currentDuration.inSeconds.toDouble(),
                    onChanged: (double double) {
                      // during when the user is sliding around
                    },
                    onChangeEnd: (double double) {
                      // sliding has finished, go to that position in song duration
                      value.seek(Duration(seconds: double.toInt()));
                    },
                    activeColor: Colors.orange,
                  ),
                ),
                // song duration progress

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // start and end time
                          Text(formatTime(value.currentDuration)),
                          Text(formatTime(value.totalDuration)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // playback controls

                Row(
                  children: [
                    // skip previous
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playPreviousAudio,
                        child: const NeuBox(
                          child: Icon(
                            Icons.skip_previous,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // play pause
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: value.pauseOrResumeAudio,
                        child: NeuBox(
                          child: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // skip forward
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextAudio,
                        child: const NeuBox(
                          child: Icon(
                            Icons.skip_next,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
    });
  }
}
