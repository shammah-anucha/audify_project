import 'dart:ffi';
import 'dart:io';
import 'package:audio_book_app/providers/user.dart';
import 'package:audio_book_app/providers/users.dart';
import 'package:audio_book_app/screens/home_screen.dart';
import 'package:audio_book_app/screens/login_screen.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import '../widgets/audify_title.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  // TextEditingController _selectedDate = TextEditingController();
  String _selectedCountry = '';

  var _editedUser = User(
    userId: null,
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

  @override
  void didChangeDependencies() {
    final userId = ModalRoute.of(context)?.settings.arguments as Int?;
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

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      } else if (response.statusCode == 400) {
        throw const HttpException('Email Already Registered');
      } else {
        throw Exception(response.body);
      }
    } catch (error) {
      rethrow;
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
      _editedUser = User(
        firstName: _editedUser.firstName,
        lastName: _editedUser.lastName,
        email: _editedUser.email,
        country: _selectedCountry, // Assign the selected country
        password: _editedUser.password,
      );
      await addUser(_editedUser);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (error) {
      if (error is HttpException) {
        // Handle specific error, in this case, email already registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // For generic errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error occurred: $error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
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
                      child: CSCPicker(
                        onCountryChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                        onStateChanged: (value) {},
                        onCityChanged: (value) {},
                        countryDropdownLabel: "Country",
                        dropdownDialogRadius: 30,
                        dropdownDecoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.grey.shade600),
                        ),
                        showCities: false,
                        showStates: false,
                        flagState: CountryFlag.DISABLE,
                      ),
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
      ),
    );
  }
}
