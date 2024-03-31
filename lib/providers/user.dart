import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String? userId;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String country;

  User({
    this.userId,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.country,
  });
}
