import 'package:audio_book_app/providers/audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = Provider.of<Audio>(context, listen: false);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.play_circle_outlined,
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
