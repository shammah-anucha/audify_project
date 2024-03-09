import 'package:audio_book_app/providers/audio.dart';
import 'package:audio_book_app/screens/audio_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({Key? key}) : super(key: key);
  static const routeName = '/audioplayerscreen';

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late final dynamic audiosprovider;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audiosprovider = Provider.of<Audios>(context, listen: false);
  }

  void goToAudio(int audioIndex) {
    // update current audio index
    audiosprovider.currentAudioIndex = audioIndex;

    // navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('My Library'),
        ),
        drawer: AppDrawer(),
        body: Consumer<Audios>(builder: (context, value, child) {
          final List<Audio> audios = value.audios;

          return ListView.builder(
            itemCount: audios.length,
            itemBuilder: (context, index) {
              final Audio audio = audios[index];

              return ListTile(
                title: Text(audio.audioName),
                subtitle: Text(audio.audioName),
                leading: Image.asset('assets/output.jpg'),
                onTap: () => goToAudio(index),
              );
            },
          );
        }));
  }
}
