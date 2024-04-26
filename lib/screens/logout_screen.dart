import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});
  static const routeName = '/logout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Audify'),
      ),
      drawer: const AppDrawer(),
      body: const Column(
        children: [Center(child: Text("Not ready"))],
      ),
    );
  }
}
