import 'package:audio_book_app/providers/auth.dart';
import 'package:audio_book_app/screens/mylibrary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text('Audify'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: (() {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text('My Library'),
          onTap: (() {
            Navigator.of(context)
                .pushReplacementNamed(MyLibraryScreen.routeName);
          }),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: (() {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          }),
        ),
      ]),
    );
  }
}
