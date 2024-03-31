// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import '../models/http_exception.dart';

// class Auth with ChangeNotifier {
//   late String _token;
//   // DateTime _expiryDate;
//   late String _userId;
//   late Timer _authTimer;

//   bool get isAuth {
//     print(token != null);
//     return token != null;
//   }

//   String get token {
//     if (_token != null) {
//       return _token;
//     }
//     return null;
//   }

//   String get user_id {
//     if (_userId != null) {
//       return _userId;
//     }
//     return null;
//   }

//   Future<String> _authenticate(String email, String password) async {
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/login/');

//     try {
//       final response = await http.post(url,
//           body: json.encode({
//             'username': email,
//             'password': password,
//             'access_token': true,
//           }),
//           headers: {'Content-Type': 'application/json'});
//       final responseData = json.decode(response.body);
//       // print(responseData);
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final accessToken = jsonResponse['access_token'];
//         print('Logged in successfully with access token: $accessToken');
//         // Store the access token securely in the app for future use
//       } else {
//         HttpException(responseData);
//       }
//       _token = responseData['access_token'];
//       _userId = responseData['user_id'];
//       print(_token);
//       print(_userId);
//       // _autoLogout();
//       notifyListeners();
//       // final prefs = await SharedPreferences.getInstance();
//       // final userData = json.encode({
//       //   'token': _token,
//       //   'userId': _userId,
//       //   'expiryDate': _expiryDate.toIso8601String(),
//       // });
//       // prefs.setString('userData', userData);
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<String> _register(String email) async {
//     final url = Uri.parse('http://10.0.2.2:8000/api/v1/user/');

//     try {
//       final response = await http.post(url,
//           body: json.encode({
//             'username': email,
//             'access_token': true,
//           }),
//           headers: {'Content-Type': 'application/json'});
//       final responseData = json.decode(response.body);
//       // print(responseData);
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         final accessToken = jsonResponse['access_token'];
//         print('Logged in successfully with access token: $accessToken');
//         // Store the access token securely in the app for future use
//       } else {
//         HttpException(responseData);
//       }
//       _token = responseData['access_token'];
//       print(_token);
//       // _autoLogout();
//       notifyListeners();
//       // final prefs = await SharedPreferences.getInstance();
//       // final userData = json.encode({
//       //   'token': _token,
//       //   'userId': _userId,
//       //   'expiryDate': _expiryDate.toIso8601String(),
//       // });
//       // prefs.setString('userData', userData);
//     } catch (error) {
//       throw error;
//     }
//   }

//   Future<void> signup(String email, String password) async {
//     return _register(email);
//   }

//   Future<void> login(String email, String password) async {
//     return _authenticate(email, password);
//   }

//   // Future<bool> tryAutoLogin() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   if (!prefs.containsKey('userData')) {
//   //     return false;
//   //   }
//   //   final extractedUserData =
//   //       json.decode(prefs.getString('userData')) as Map<String, Object>;
//   //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

//   //   if (expiryDate.isBefore(DateTime.now())) {
//   //     return false;
//   //   }

//   //   _token = extractedUserData['token'];
//   //   _userId = extractedUserData['userId'];
//   //   _expiryDate = expiryDate;
//   //   notifyListeners();
//   //   _autoLogout();
//   //   return true;
//   // }

//   void logout() async {
//     _token = null;
//     _userId = null;
//     // _expiryDate = null;
//     if (_authTimer != null) {
//       _authTimer.cancel();
//       _authTimer = null;
//     }
//     notifyListeners();
//     // final prefs = await SharedPreferences.getInstance();
//     // To be used if you have more than the user data stored in the sharedpreferences
//     // prefs.remove('userData');
//     // prefs.clear();
//   }

// //   void _autoLogout() {
// //     if (_authTimer != null) {
// //       _authTimer.cancel();
// //     }
// //     final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
// //     _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
// //   }
// }

import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<String?> _authenticate(String? email, String? password) async {
    // final url = Uri.parse('http://127.0.0.1:8000/api/v1/login/access-token');
    var dio = Dio();

    try {
      final body = FormData.fromMap({
        "username": email,
        "password": password,
      });

      var response = await dio.post(
        "http://127.0.0.1:8000/api/v1/login/access-token",
        data: body,
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        _token = responseData['access_token'];
        _userId = responseData['user_id'];
        print('Logged in successfully with access token: $_token');
        notifyListeners();
        return _token!;
      } else if (response.statusCode == 405) {
        throw HttpException('Method Not Allowed');
      } else {
        throw HttpException('Authentication failed');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> _register(String email) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/v1/login');

    try {
      final response = await http.post(url,
          body: json.encode({
            'username': email,
            'access_token': true,
          }),
          headers: {'Content-Type': 'application/json'});

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        _token = responseData['access_token'];
        print('Registered successfully with access token: $_token');
        notifyListeners();
      } else {
        throw HttpException('Registration failed');
      }
      return _token!;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    await _register(email);
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

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
