import 'package:audio_book_app/providers/book.dart';
import 'package:audio_book_app/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLibrary extends StatelessWidget {
  const MyLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<Book>(context, listen: false);
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 45, horizontal: 18),
          width: 550,
          height: 100,
          color: Colors.white,
        ),
        Positioned(
          child: Image.asset(
            book.bookImage, // Replace with your image asset path
            width: 180,
            height: 130,
          ),
        ),
        Positioned(
          left: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.bookName),
              const Text("John Smith"),
            ],
          ),
        ),
        Positioned(
          left: 330,
          top: 70,
          child: IconButton(
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(AudioPlayerScreen.routeName),
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.orange,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}
