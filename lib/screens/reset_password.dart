import 'package:audio_book_app/providers/reset_password.dart';
import 'package:audio_book_app/widgets/success.dart';
import 'package:audio_book_app/widgets/thankyou.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassWordScreen extends StatefulWidget {
  const ResetPassWordScreen({super.key});
  static const routeName = '/reset-password';
  @override
  State<ResetPassWordScreen> createState() => _ResetPassWordScreenState();
}

class _ResetPassWordScreenState extends State<ResetPassWordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();

  final Map<String, String> _userData = {
    'token': '',
    'new_password': '',
    'confirm_password': '',
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
      await Provider.of<ForgotPassword>(context, listen: false).reset(
        _userData['token'],
        _userData['new_password'],
        _userData['confirm_password'],
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(SuccessScreen.routeName);
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Thankyou.routeName);
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: deviceSize.width * 0.75,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: deviceSize.height * 0.1,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Token',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Token!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userData['token'] = value!;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'New Password',
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
                    _userData['new_password'] = value!;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userData['confirm_password'] = value!;
                  },
                ),
                const SizedBox(
                  height: 40,
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
      ),
    );
  }
}
