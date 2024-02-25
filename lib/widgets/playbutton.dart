// import 'package:audio_book_app/providers/audio.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:audioplayers/audioplayers.dart';

// class PlayButton extends StatefulWidget {
//   const PlayButton({super.key});

//   @override
//   State<PlayButton> createState() => _PlayButtonState();
// }

// class _PlayButtonState extends State<PlayButton> {
//   final audioplayer = AudioPlayer();
//   bool isPlaying = false;

//   @override
//   Widget build(BuildContext context) {
//     final audio = Provider.of<Audio>(context, listen: false);
//     return IconButton(
//       onPressed: () async {
//         if (isPlaying) {
//           await audioplayer.pause();
//         } else {
//           await audioplayer.play(audio.audioFile);
//         }
//       },
//       icon: Icon(
//         isPlaying ? Icons.pause : Icons.play_arrow,
//         size: 50,
//         color: Colors.white,
//       ),
//     );
//   }
// }
