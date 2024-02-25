import 'package:audio_book_app/providers/books.dart';
import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:audio_book_app/widgets/mylibrary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});
  static const routeName = '/mylibrary';

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<Books>(context);
    final books = booksData.items;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Library'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: books[i],
          child: const MyLibrary(),
        ),
        itemCount: books.length,
      ),
    );
  }
}
