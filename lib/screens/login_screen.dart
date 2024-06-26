import 'package:audio_book_app/screens/home_screen.dart';
import 'package:audio_book_app/screens/recover_password.dart';
import 'package:audio_book_app/widgets/audify_title.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          color: Colors.white,
        ),
        SingleChildScrollView(
          child: SizedBox(
            height: 1000,
            width: deviceSize.width,
            child: Column(children: [
              const AudifyTitle(),
              Flexible(
                child: SizedBox(
                  height: deviceSize.height * 0.4,
                  child: Center(
                    child: Image.asset('assets/png-clipart-audio-book.png'),
                  ),
                ),
              ),
              Flexible(
                flex: deviceSize.width > 800 ? 2 : 1,
                child: const AuthCard(),
              ),
            ]),
          ),
        )
      ]),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'username': '',
    'password': '',
  };
  var _isLoading = false;

  void _showErrorDialog(Object error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text("$error"),
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
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['username'],
        _authData['password'],
      );
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (error) {
      _showErrorDialog(error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Material(
      child: Container(
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
                  _authData['username'] = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    // onPressed: null,
                    child: const Text(
                      'Forgot your Password?',
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          RecoverPasswordScreen.routeName);
                    },
                  ),
                ],
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('LOGIN'),
                ),
              const SizedBox(
                height: 5,
              ),
              Flexible(
                child: TextButton(
                  child: const Text(
                    'No Account? Join the Community!',
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignUpScreen.routeName);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
