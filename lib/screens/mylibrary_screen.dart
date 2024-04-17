import 'package:audio_book_app/providers/audios.dart';
import 'package:audio_book_app/providers/auth.dart';
import 'package:audio_book_app/providers/books.dart';
import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:audio_book_app/widgets/mylibrary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({Key? key}) : super(key: key);
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
    super.initState();
    _isLoading = true;
    final authData = Provider.of<Auth>(context, listen: false);
    Provider.of<Books>(context, listen: false)
        .fetchAndSetBooks(authData.token)
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context)
                  .pop(false), // Dismiss dialog without deleting
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // Confirm deletion
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
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
        itemCount: books.length,
        itemBuilder: (ctx, i) => Dismissible(
          key: UniqueKey(), // Unique key for each Dismissible item
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) => _showDeleteConfirmationDialog(context),
          onDismissed: (direction) {
            final authData = Provider.of<Auth>(context, listen: false);
            Provider.of<Audios>(context, listen: false)
                .deleteAll(books[i].bookId, authData.token);
          },
          child: ChangeNotifierProvider.value(
            value: books[i],
            child: MyLibrary(bookId: books[i].bookId), // Pass bookId here
          ),
        ),
      ),
    );
  }
}
