import 'package:audio_book_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../models/http_exception.dart';

class Users with ChangeNotifier {
  // final BuildContext context;

  // Users(this.context);

  List<User> _users = [];

  List<User> get items {
    return [..._users];
  }

  User findById(int id) {
    return _users.firstWhere((user) => user.userId == id);
  }

  // Future<void> fetchAndSetUsers() async {
  //   final url = Uri.parse('http://10.0.2.2:8000/api/v1/user/');
  //   final response = await http.get(url);
  //   final decoded_response = json.decode(response.body);
  //   final int number_of_objects = decoded_response.length;
  //   print(json.decode(response.body));
  //   print(response.body.length);
  //   final List<User> loadedUser = [];
  //   final extractedData = json.decode(response.body);
  //   // print(extractedData["name"]);
  //   if (extractedData == null) {
  //     return;
  //   }
  //   // extractedData.forEach((UserId, UserData) {
  //   int i = 0;
  //   while (i < number_of_objects) {
  //     loadedUser.add(User(
  //       user_id: extractedData[i]['user_id'],
  //       title: extractedData[i]['title'],
  //       Userdate: extractedData[i]['Userdate'],
  //       time: extractedData[i]['time'],
  //       imageUrl: extractedData[i]['imageUrl'],
  //       location: extractedData[i]['location'],
  //       location_url: extractedData[i]['location_url'],
  //       host: extractedData[i]['host'],
  //     ));
  //     i++;
  //   }

  //   _users = loadedUser.reversed.toList();
  //   notifyListeners();
  // }

  // final String baseUrl = "http://127.0.0.1:8000/api/v1/Users/";

  // void _fetchDataFromTheServer() async {
  //   final Dio dio = Dio();
  // }

  // Future<void> updateUser(int id, User newUser) async {
  //   final userIndex = _users.indexWhere((ev) => ev.userId == id);
  //   final user_id = _users[userIndex].userId;
  //   if (userIndex != null) {
  //     final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/$user_id');
  //     await http.put(url,
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: json.encode({
  //           'firstname': newUser.firstName,
  //           'lastname': newUser.lastName,
  //           'email': newUser.email,
  //           'dob': newUser.country,
  //           'phone': newUser.password,
  //         }));
  //     print(user_id);
  //     _users[userIndex] = newUser;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  // Future<void> deleteUser(String id) async {
  //   final userIndex = _users.indexWhere((ev) => ev.userId == id);
  //   final userId = _users[userIndex].userId;
  //   var existingUser = _users[userIndex];
  //   final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/$userId');
  //   _users.removeAt(userIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _users.insert(userIndex, existingUser);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingUser = null;
  // }

  Future<void> updateUser(int id, User newUser) async {
    final userIndex = _users.indexWhere((user) => user.userId == id);
    if (userIndex != -1) {
      final user_id = _users[userIndex].userId;
      final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/$user_id');
      try {
        await http.put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            'firstname': newUser.firstName,
            'lastname': newUser.lastName,
            'email': newUser.email,
            'dob': newUser.country,
            'phone': newUser.password,
          }),
        );
        print(user_id);
        _users[userIndex] = newUser;
        notifyListeners();
      } catch (error) {
        throw HttpException('Failed to update user.');
      }
    } else {
      print('User not found');
    }
  }

  Future<void> deleteUser(int id) async {
    final userIndex = _users.indexWhere((user) => user.userId == id);
    if (userIndex != -1) {
      final userId = _users[userIndex].userId;
      var existingUser = _users[userIndex];
      final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/$userId');
      _users.removeAt(userIndex);
      notifyListeners();
      try {
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
          _users.insert(userIndex, existingUser);
          notifyListeners();
          throw HttpException('Could not delete user.');
        }
      } catch (error) {
        _users.insert(userIndex, existingUser);
        notifyListeners();
        throw HttpException('Failed to delete user.');
      }
      // existingUser = null;
    } else {
      print('User not found');
    }
  }
}
