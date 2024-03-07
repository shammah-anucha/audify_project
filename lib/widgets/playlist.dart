// import 'package:audio_book_app/providers/audio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:audioplayers/audioplayers.dart';

// class PlayList extends StatefulWidget {
//   final Function onStopAudio;

//   const PlayList({Key? key, required this.onStopAudio}) : super(key: key);

//   @override
//   State<PlayList> createState() => _PlayListState();
// }

// class _PlayListState extends State<PlayList> {
//   final audioPlayer = AudioPlayer();

//   @override
//   void dispose() {
//     audioPlayer.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final audio = Provider.of<Audio>(context, listen: false);

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               onPressed: () async {
//                 widget.onStopAudio();
//                 String url = audio.audioFile;
//                 await audioPlayer.play(url);
//               },
//               icon: Icon(
//                 Icons.play_circle_outlined,
//                 size: 50,
//                 color: Colors.orange,
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(audio.audioName),
//                 const Text(
//                   "pages 1-10",
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ],
//             ),
//             const Text(
//               '12:09',
//               style: TextStyle(color: Colors.grey),
//             )
//           ],
//         ),
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.0),
//           child: Divider(),
//         )
//       ],
//     );
//   }
// }

// playlist.dart

import 'package:flutter/material.dart';
import 'package:audio_book_app/providers/audio.dart';
import 'package:audio_book_app/models/audio_player_service.dart';
import 'package:provider/provider.dart';

class PlayList extends StatefulWidget {
  final AudioPlayerService audioPlayerService;

  const PlayList({Key? key, required this.audioPlayerService})
      : super(key: key);

  @override
  State<PlayList> createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<Audio>(context, listen: false);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                print('audio.audioId: ${audio.audioId}');
                print(
                    'widget.audioPlayerService.currentIndex: ${widget.audioPlayerService.currentIndex}');
                print("isPlaying: ${widget.audioPlayerService.isPlaying}");

                if (widget.audioPlayerService.isPlaying &&
                    audio.audioId == widget.audioPlayerService.currentIndex) {
                  // If the tapped item is the currently playing item, pause it
                  await widget.audioPlayerService.pauseAudio();
                } else {
                  // Play the tapped audio
                  await widget.audioPlayerService
                      .playAudio(audio.audioFile, audio.audioId);
                }

                setState(() {
                  // Update the UI by triggering a rebuild
                });
              },
              icon: Icon(
                widget.audioPlayerService.isPlaying &&
                        audio.audioId == widget.audioPlayerService.currentIndex
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
