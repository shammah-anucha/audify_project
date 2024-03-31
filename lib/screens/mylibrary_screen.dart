import 'package:audio_book_app/providers/auth.dart';
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
  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _isLoading = true;
    final authData = Provider.of<Auth>(context, listen: false);
    Provider.of<Books>(context, listen: false)
        .fetchAndSetBooks(authData.token)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

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
          child: MyLibrary(bookId: books[i].bookId), // Pass bookId here
        ),
        itemCount: books.length,
      ),
    );
  }
}
