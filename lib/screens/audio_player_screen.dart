import 'package:audio_book_app/providers/audio.dart';
import 'package:audio_book_app/providers/auth.dart';
import 'package:audio_book_app/providers/book.dart';
import 'package:audio_book_app/providers/books.dart';
import 'package:audio_book_app/screens/audio_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  static const routeName = '/audioplayerscreen';

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  // ignore: unused_field
  final _isInit = true;
  // ignore: unused_field
  var _isLoading = false;
  late final dynamic audiosprovider;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audiosprovider = Provider.of<Audios>(context, listen: false);
    setState(() {
      _isLoading = true;
    });

    final authData = Provider.of<Auth>(context, listen: false);
    Provider.of<Audios>(context, listen: false)
        .fetchAndSetAudios(authData.token)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void goToAudio(BuildContext context, Audio audio) {
    final audiosProvider = Provider.of<Audios>(context, listen: false);
    audiosProvider.currentAudioIndex = audiosProvider.audios.indexOf(audio);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPage(filteredAudios: [audio]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Audio List'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<Audios>(
        builder: (context, value, child) {
          final filteredAudios = value.audios
              .where((element) => element.bookId == bookId)
              .toList();

          return ListView.builder(
            itemCount: filteredAudios.length,
            itemBuilder: (context, index) {
              final Audio audio = filteredAudios[index];
              final Book book = Provider.of<Books>(context, listen: false)
                  .findById(audio.bookId); // Find book by audio's bookId
              return ListTile(
                title: Text(audio.audioName),
                subtitle: Text(book.bookName),
                leading: Image.network(audio.bookImage),
                onTap: () =>
                    goToAudio(context, audio), // Pass audio instead of index
              );
            },
          );
        },
      ),
    );
  }
}
