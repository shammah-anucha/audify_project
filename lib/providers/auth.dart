import 'dart:async';
// import 'dart:html';
// import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String? _token;
  int? _userId;
  late Timer _authTimer;

  bool get isAuth {
    print(token != null);
    return token != null;
  }

  String? get token {
    return _token;
  }

  int? get userId {
    return _userId;
  }

  // Future<String?> _authenticate(String? email, String? password) async {
  //   // final url = Uri.parse('http://127.0.0.1:8000/api/v1/login/access-token');
  //   var dio = Dio();

  //   try {
  //     final body = FormData.fromMap({
  //       "username": email,
  //       "password": password,
  //     });

  //     var response = await dio.post(
  //       "http://127.0.0.1:8000/api/v1/login/access-token",
  //       data: body,
  //     );

  //     final responseData = response.data;

  //     if (response.statusCode == 200) {
  //       _token = responseData['access_token'];
  //       _userId = responseData['user_id'];
  //       print('Logged in successfully with access token: $_token');
  //       notifyListeners();
  //       return _token!;
  //     } else if (response.statusCode == 405) {
  //       throw Exception('Method Not Allowed');
  //     } else if (response.statusCode == 400) {
  //       throw Exception('Incorrect email or password');
  //     } else {
  //       throw Exception('Authentication failed');
  //     }
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<String?> _authenticate(String? email, String? password) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/v1/login/access-token');

    try {
      final response = await http.post(
        url,
        body: {
          "username": email,
          "password": password,
        },
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final _token = responseData['access_token'] as String;
        // final _userId = responseData['user_id'] as String;
        print('Logged in successfully with access token: $_token');
        notifyListeners();
        return _token;
      } else if (response.statusCode == 405) {
        throw Exception('Method Not Allowed');
      } else if (response.statusCode == 400) {
        throw Exception('Incorrect email or password');
      } else {
        throw Exception('Authentication failed');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String? email, String? password) async {
    await _authenticate(email, password);
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }

  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;
  // }

  void logout() {
    _token = null;
    _userId = null;
    _authTimer.cancel();
    notifyListeners();
  }

  Auth() {
    _authTimer =
        Timer(Duration(seconds: 0), () {}); // Initialize with a dummy timer
  }
}
