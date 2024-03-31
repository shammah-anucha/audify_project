import 'package:audio_book_app/providers/user.dart';
import 'package:audio_book_app/providers/users.dart';
import 'package:audio_book_app/screens/home_screen.dart';
import 'package:audio_book_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/audify_title.dart';
import 'package:provider/provider.dart';
// import '../models/http_exception.dart';
import 'dart:convert';
// import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  // TextEditingController _selectedDate = TextEditingController();

  var _editedUser = User(
    userId: '',
    firstName: '',
    lastName: '',
    email: '',
    country: '',
    password: '',
  );
  var _initValues = {
    'userId': '',
    'firstName': '',
    'lastName': '',
    'email': '',
    'country': '',
    'password': '',
  };
  // ignore: unused_field
  var _isInit = true;
  // ignore: unused_field
  var _isLoading = false;
  // Map<String, String> _authData = {
  //   'username': '',
  //   'password': '',
  // };

  @override
  void didChangeDependencies() {
    final userId = ModalRoute.of(context)?.settings.arguments as int?;
    if (userId != null) {
      _editedUser = Provider.of<Users>(context, listen: false).findById(userId);
      _initValues = {
        'firstname': _editedUser.firstName,
        'lastname': _editedUser.lastName,
        'email': _editedUser.email,
        'country': _editedUser.country,
        'password': _editedUser.password,
      };
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> addUser(User user) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/login/');
    // var uuid = Uuid();
    try {
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            // 'user_id': uuid.v4(),
            'Firstname': user.firstName,
            'Lastname': user.lastName,
            'email': user.email,
            'country_of_residence': user.country,
            'password': user.password,
          }));
      print(json.decode(response.body));
      // ignore: unused_field
      final newUser = User(
        userId: json.decode(response.body)['userId'],
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        country: user.country,
        password: user.password,
      );
      print(newUser.firstName);
      print(newUser.email);
      print(newUser.password);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else {
        print('Sign Up Failed');
        print(json.decode(response.body));
      }

      // }
    } catch (error) {
      // print(error);
      // print(error);
      throw (error);
    }
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      addUser(_editedUser);
    } catch (error) {
      throw (error);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // void _presentDatePicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //   ).then((pickedEventDate) {
  //     if (pickedEventDate == null) {
  //       return;
  //     } else {
  //       String _formattedEventDate =
  //           DateFormat('yyyy-MM-dd').format(pickedEventDate);
  //       print(_formattedEventDate);

  //       setState(() {
  //         _selectedDate.text = _formattedEventDate;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          // width: deviceSize.width * 0.75,
          height: 1000,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const AudifyTitle(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                        initialValue: _initValues['firstName'],
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            firstName: value!,
                            lastName: _editedUser.lastName,
                            email: _editedUser.email,
                            country: _editedUser.country,
                            password: _editedUser.password,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                        initialValue: _initValues['lastName'],
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            firstName: _editedUser.firstName,
                            lastName: value!,
                            email: _editedUser.email,
                            country: _editedUser.country,
                            password: _editedUser.password,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                        initialValue: _initValues['email'],
                        decoration: InputDecoration(
                          labelText: 'Email Address',
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
                          _editedUser = User(
                            firstName: _editedUser.firstName,
                            lastName: _editedUser.lastName,
                            email: value!,
                            country: _editedUser.country,
                            password: _editedUser.password,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                        initialValue: _initValues['country'],
                        decoration: InputDecoration(
                          labelText: 'Country of Residence',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your country!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedUser = User(
                            firstName: _editedUser.firstName,
                            lastName: _editedUser.lastName,
                            email: _editedUser.email,
                            country: value!,
                            password: _editedUser.password,
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                        // initialValue: _initValues['password'],
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
                          _editedUser = User(
                            firstName: _editedUser.firstName,
                            lastName: _editedUser.lastName,
                            email: _editedUser.email,
                            country: _editedUser.country,
                            password: value!,
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      // initialValue: _initValues['password'],
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
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: const Text('SIGN UP'),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    child: const Text(
                      'Already Have an Account? LogIn!',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AuthScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
