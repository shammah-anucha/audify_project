import 'package:audio_book_app/providers/reset_password.dart';
import 'package:audio_book_app/screens/login_screen.dart';
import 'package:audio_book_app/widgets/thankyou.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import '../models/http_exception.dart';
import 'package:provider/provider.dart';

class RecoverPasswordScreen extends StatefulWidget {
  static const routeName = '/recover-password';

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _userData = {
    'email': '',
  };
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'))
        ],
      ),
    );
  }

  Future<void> _submit() async {
    // print(_userData['email']);
    print("here");
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ForgotPassword>(context, listen: false).request(
        _userData['email'],
      );
      Navigator.of(context).pushReplacementNamed(Thankyou.routeName);
    } catch (error) {
      const errorMessage = 'Could not Send Email. Please try again later';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
        ),
        body: Center(
          child: Column(children: [
            SizedBox(
              height: deviceSize.height * 0.1,
            ),
            const Text(
              "Forgot your Password?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.orange,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Enter your E-Mail Address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.orange,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              color: Colors.white,
              width: deviceSize.width * 0.75,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userData['email'] = value!;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        child: const Text('SUBMIT'),
                      ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
