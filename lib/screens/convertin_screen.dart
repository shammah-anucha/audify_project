import 'package:audio_book_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class ConvertingScreen extends StatelessWidget {
  const ConvertingScreen({super.key});
  static const routeName = '/converting-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audify'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Something is Cooking on the Backend",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 52, 51, 51),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Image.asset('assets/ezgif-3-6113523cf7.gif'),
            const SizedBox(height: 50),
            const Text(
              "Your Audio will be ready in the My Library Tab after conversion",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 52, 51, 51),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
