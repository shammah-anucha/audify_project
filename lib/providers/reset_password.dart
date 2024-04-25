import 'dart:async';
// import 'dart:html';
// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ForgotPassword with ChangeNotifier {
  Future<String> _recoverPassword(String email) async {
    final url = Uri.parse(
      "http://127.0.0.1:8000/api/v1/password-reset/request/?email=$email",
    );

    print(email);
    // var dio = Dio();

    try {
      // final body = json.encode({
      //   'email': email,
      // });

      var response = await http.post(
        url,
      );

      // print(body);

      if (response.statusCode == 200) {
        print('Email Sent Successfully');
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
      throw error;
    }
  }

  Future<String> _resetPassword(
      String token, String new_password, String confirm_password) async {
    final url = Uri.parse(
        "http://127.0.0.1:8000/api/v1/password-reset/reset-password/?token=$token&new_password=$new_password&confirm_password=$confirm_password");
    print("Token is: $token");
    print("New password is: $new_password");
    print("Confirm password is: $confirm_password");
    // var dio = Dio();

    try {
      // final body = FormData.fromMap({
      //   "token": token,
      //   "new_password": new_password,
      //   "confirm_password": confirm_password,
      // });

      var response = await http.put(
        url,
      );

      if (response.statusCode == 200) {
        print('Password Successfully Changed!');
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
      throw error;
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
