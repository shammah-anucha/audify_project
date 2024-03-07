import 'package:flutter/material.dart';
import 'package:audio_book_app/providers/audio.dart';
import 'package:audio_book_app/models/audio_player_service.dart';
import 'package:provider/provider.dart';

class PlayList extends StatefulWidget {
  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  late AudioPlayerService audioPlayerService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    audioPlayerService = Provider.of<AudioPlayerService>(context);
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerService = Provider.of<AudioPlayerService>(context);
    final audio = Provider.of<Audio>(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                if (audioPlayerService.isPlaying &&
                    audio.audioId == audioPlayerService.currentIndex) {
                  await audioPlayerService.pauseAudio();
                } else {
                  await audioPlayerService.playAudio(
                      audio.audioFile, audio.audioId);
                }
                setState(() {
                  // Update the UI by triggering a rebuild
                });
                if (audioPlayerService.isPlaying) {
                  setState(() {});
                }
              },
              icon: Icon(
                audioPlayerService.isPlaying &&
                        audio.audioId == audioPlayerService.currentIndex
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outlined,
                size: 50,
                color: Colors.orange,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(audio.audioName),
                const Text(
                  "pages 1-10",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Text(
              '12:09',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(),
        )
      ],
    );
  }
}
