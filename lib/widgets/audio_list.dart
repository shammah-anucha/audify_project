// import 'package:audio_book_app/screens/audio_page_screen.dart';
import 'package:audio_book_app/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:audio_book_app/providers/audio.dart';
import 'package:provider/provider.dart';

class AudioList extends StatelessWidget {
  const AudioList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Audio> audios = Provider.of<List<Audio>>(context);
    // final audios = audios
    //           .where((element) => element.bookId == audio.bookId)
    //           .toList();

    return ListView.builder(
      itemCount: audios.length,
      itemBuilder: (context, index) {
        final audio = audios[index];
        return ListTile(
          leading: Image.network(
            audio.bookImage,
            width: 50,
            height: 50,
          ),
          title: Text(audio.audioName),
          subtitle: Text(audio.audioName),
          onTap: () {
            Navigator.pushNamed(
              context,
              AudioPlayerScreen.routeName,
              arguments: audio.bookId,
            );
          },
        );
      },
    );
  }
}
