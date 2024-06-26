import 'package:audio_book_app/providers/book.dart';
import 'package:audio_book_app/screens/audio_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLibrary extends StatelessWidget {
  final int bookId;

  const MyLibrary({required this.bookId, super.key});

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
          child: Image.network(
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
              FadeTransition(
                opacity:
                    const AlwaysStoppedAnimation(1), // Adjust opacity as needed
                child: SizedBox(
                  width: 130,
                  child: Text(
                    book.bookName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Text("John Smith"),
            ],
          ),
        ),
        Positioned(
          left: 330,
          top: 70,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                AudioPlayerScreen.routeName,
                arguments: bookId, // Pass bookId to AudioPlayerScreen
              );
            },
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
