import 'package:audio_book_app/screens/recover_password.dart';
import 'package:audio_book_app/screens/reset_password.dart';
import 'package:flutter/material.dart';

class Thankyou extends StatelessWidget {
  static const routeName = '/thankyou';
  const Thankyou({super.key});

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
                "Thank you for providing your Email Address.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.orange),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Please check your email box and enter the token sent",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(ResetPassWordScreen.routeName),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
