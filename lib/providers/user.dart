import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String userId;
  final String email;
  final String hashedPassword;
  final String firstName;
  final String lastName;
  final String country;

  User({
    required this.userId,
    required this.email,
    required this.hashedPassword,
    required this.firstName,
    required this.lastName,
    required this.country,
  });
}
