import 'package:flutter/material.dart';

class ConvertingSecondScreen extends StatelessWidget {
  const ConvertingSecondScreen({super.key});
  static const routeName = '/converting-second-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "In Just a Moment, Your Audio Files will be Ready!",
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
