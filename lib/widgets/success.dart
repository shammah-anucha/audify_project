import 'package:audio_book_app/screens/login_screen.dart';
import 'package:audio_book_app/screens/recover_password.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  static const routeName = '/success';
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(RecoverPasswordScreen.routeName);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: deviceSize.height * 0.1,
              ),
              const Text(
                "Your Password has been changed successfully!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.orange),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Please login again",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthScreen.routeName,
                    (route) => true, // Remove all routes from the stack
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
