import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ForgotPassword with ChangeNotifier {
  Future<String> _recoverPassword(String email) async {
    final url = Uri.parse(
      "http://127.0.0.1:8000/api/v1/password-reset/request/?email=$email",
    );

    try {
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        notifyListeners();
        return ('Email Sent Successfully');
      } else if (response.statusCode == 405) {
        throw Exception('Method Not Allowed');
      } else if (response.statusCode == 404) {
        throw Exception('Incorrect email or password');
      } else {
        throw Exception('Authentication failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> _resetPassword(
      String token, String newPassword, String confirmPassword) async {
    final url = Uri.parse(
        "http://127.0.0.1:8000/api/v1/password-reset/reset-password/?token=$token&new_password=$newPassword&confirm_password=$confirmPassword");

    try {
      var response = await http.put(
        url,
      );

      if (response.statusCode == 200) {
        notifyListeners();
        return ('Password Successfully Changed!');
      } else if (response.statusCode == 405) {
        throw Exception('Method Not Allowed');
      } else if (response.statusCode == 401) {
        throw Exception('This token has expired');
      } else {
        throw Exception('Authentication failed');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> request(String? email) async {
    await _recoverPassword(email!);
  }

  Future<void> reset(
      String? token, String? newPassword, String? oldPassword) async {
    await _resetPassword(token!, newPassword!, oldPassword!);
  }
}
