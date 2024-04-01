import 'package:audio_book_app/providers/audio.dart';
import 'package:audio_book_app/providers/auth.dart';
import 'package:audio_book_app/providers/book.dart';
import 'package:audio_book_app/providers/books.dart';
// import 'package:audio_book_app/providers/book.dart';
// import 'package:audio_book_app/providers/books.dart';
// import 'package:audio_book_app/providers/auth.dart';
// import 'package:audio_book_app/providers/book.dart';
// import 'package:audio_book_app/providers/books.dart';
import 'package:audio_book_app/screens/audio_page_screen.dart';
// import 'package:audio_book_app/widgets/audio_list.dart';
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
  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;
  late final dynamic audiosprovider;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // @override
  // void initState() {
  //   super.initState();
  //   audiosprovider = Provider.of<Audios>(context, listen: false);
  // }

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

  // void goToAudio(int audioIndex) {
  //   // update current audio index
  //   audiosprovider.currentAudioIndex = audioIndex;

  //   // navigate to song page
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const AudioPage(),
  //     ),
  //   );
  // }

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

  // void goToAudio(int audioIndex) {
  //   // update current audio index
  //   audiosprovider.currentAudioIndex = audioIndex;

  //   // get the bookId of the current audio
  //   int bookId = audiosprovider.audios[audioIndex].bookId;

  //   // navigate to song page and pass the bookId
  //   Navigator.pushNamed(
  //     context,
  //     AudioPage.routeName,
  //     arguments: {
  //       'bookId': bookId,
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Audio List'),
      ),
      drawer: AppDrawer(),
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
      // body: Consumer<Audios>(
      //   builder: (context, value, child) {
      //     final audios = value.audios
      //         .where((element) => element.bookId == bookId)
      //         .toList(); // Convert to list
      //     return ListView.builder(
      //       itemCount: audios.length,
      //       itemBuilder: (context, index) {
      //         final Audio audio = audios[index]; // Get audio at index
      //         final Book book = Provider.of<Books>(context, listen: false)
      //             .findById(audio.bookId); // Find book by audio's bookId
      //         return ListTile(
      //           title: Text(audio.audioName),
      //           subtitle:
      //               Text(book.bookName), // Display book name as subtitle
      //           leading: Image.network(audio.bookImage),
      //           onTap: () => goToAudio(index), // Pass audio instead of index
      //         );
      //       },
      //     );
      //   },
      // )
    );
  }
}

// // Consumer<Audios>(
// //   builder: (context, value, child) {
// // final List<Audio> audios = value.audios;
// //       return AudiosList(
// //         audioFiles: audios
// //             .map((audio) => audio.audioFile)
// //             .expand((x) => x)
// //             .toList(),
// //       );
// //     },
// //   ),
// // );

// // Consumer<Audios>(builder: (context, value, child) {
// //   final audios = value.audios.where((element) => element.bookId == 1);
// //   // final List<Audio> au

// //   return ListView.builder(
// //     itemCount: audios.length,
// //     itemBuilder: (context, index) {
// //       // final Audio audio = audios[index];
// //       // final Book book = Provider.of<Books>(context, listen: false)
// //           // .findById(audio.bookId);

// //       return ListTile(
// //         title: Text(audio[index].audioName),
// //         subtitle: Text(audio.audioName),
// //         leading: Image.network(book.bookImage),
// //         onTap: () => goToAudio(index),
// //       );
// //     },
// //   );

// import 'package:audio_book_app/providers/audios.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:audio_book_app/providers/audio.dart';
// import 'package:audio_book_app/screens/audio_page_screen.dart';
// import 'package:audio_book_app/widgets/app_drawer.dart';

// class AudioPlayerScreen extends StatefulWidget {
//   const AudioPlayerScreen({Key? key}) : super(key: key);
//   static const routeName = '/audioplayerscreen';

//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // audiosprovider = Provider.of<Audios>(context, listen: false);
//     // final work = Provider.of<Audio>(context, listen: false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bookId = ModalRoute.of(context)!.settings.arguments as int;
//     // final work =

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 243, 243, 243),
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: const Text('Audio List'),
//       ),
//       drawer: AppDrawer(),
//       body: Consumer<Audios>(
//         builder: (context, value, child) {
//           final audios = value.audios
//               .where((element) => element.bookId == bookId)
//               .toList();

//           return ListView.builder(
//             itemCount: audios.length,
//             itemBuilder: (context, index) {
//               final Audio audio = audios[index];
//               return ListTile(
//                 title: Text(audio.audioName),
//                 leading: Image.network(audio.bookImage),
//                 onTap: () => null,
//               );
//             },
//           );
//         },
//       ),

//       // Consumer<Audios>(
//       //   builder: (context, value, child) {
//       //     final audios = value.audios
//       //         .where((element) => element.bookId == bookId)
//       //         .toList();

//       //     int totalAudioFiles = 0;
//       //     for (final audio in audios) {
//       //       totalAudioFiles += audio.audioFile.length;
//       //     }

//       //     return ListView.builder(
//       //       itemCount: audios.length,
//       //       itemBuilder: (context, index) {
//       //         final Audio audio = audios[index];
//       //         final Book book = Provider.of<Books>(context, listen: false)
//       //             .findById(audio.bookId);
//       //         return ListTile(
//       //           title: Text(audio.audioName),
//       //           subtitle: Text(book.bookName),
//       //           leading: Image.network(book.bookImage),
//       //           onTap: () => goToAudio(context, audio.audioId),
//       //         );
//       //       },
//       //     );
//       //   },
//       // ),
//     );
//   }

//   void goToAudio(BuildContext context, int audioId) {
//     final audiosProvider = Provider.of<Audios>(context, listen: false);
//     audiosProvider.currentAudioIndex = audioId;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AudioPage(),
//       ),
//     );
//   }
// }

// import 'package:audio_book_app/providers/audio.dart';
// import 'package:audio_book_app/providers/audio.dart';
// import 'package:audio_book_app/providers/audios.dart';
// import 'package:audio_book_app/screens/audio_page_screen.dart';
// import 'package:audio_book_app/widgets/audio_list.dart';
// import 'package:flutter/material.dart';
// // import 'package:audio_book_app/providers/audios.dart';
// import 'package:audio_book_app/widgets/app_drawer.dart';
// import 'package:provider/provider.dart';
// // import 'package:provider/provider.dart';

// class AudioPlayerScreen extends StatefulWidget {
//   // final int bookId;

//   // AudioPlayerScreen({required this.bookId});
//   static const routeName = '/audioplayerscreen';

//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   late final dynamic audiosprovider;
//   late List audioFiles = [];
//   bool isPlaying = false;
//   // Duration duration = Duration.zero;
//   // Duration position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     audiosprovider = Provider.of<Audios>(context, listen: false);
//     // final int bookId = widget.bookId; // Receive bookId from widget
//     // audioFiles = audiosprovider.getAudioFilesById(bookId);
//   }

//   void goToAudio(int audioIndex) {
//     // update current audio index
//     audiosprovider.currentAudioIndex = audioIndex;

//     // navigate to song page
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AudioPage(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 243, 243, 243),
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//           title: const Text('My Library'),
//         ),
//         drawer: AppDrawer(),
//         body:  Consumer<Audios>(
//         builder: (context, value, child) {
//           // final
//           // final audios = value.audios
//           //     .where((element) => element.bookId == audio.bookId)
//           //     .toList();

//           // int totalAudioFiles = 0;
//           // for (final audio in audios) {
//           //   totalAudioFiles += audio.audioFile.length;
//           // }

//           return ListView.builder(
//             itemCount: audios.length,
//             itemBuilder: (context, index) {
//               final Audio audio = audios[index];
              
//               return ListTile(
//                 title: Text(audio.audioName),
//                 subtitle: Text(audio.audioName),
//                 leading: Image.network(audio.bookImage),
//                 onTap: () => null,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
